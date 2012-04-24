Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2DXNQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:16:50 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 5/6] mac80211: softamp: Netlink interface to softamp
Date: Tue, 24 Apr 2012 16:17:39 +0300
Message-Id: <1335273460-12682-6-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151709_148267_ACF80DFF)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Adds basic netlink interface. Those packets which are not handled in
softamp will be sent via netlink for processing in user space.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/mac80211/virtual_amp.c |   67 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h |   20 +++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/net/mac80211/virtual_amp.c b/net/mac80211/virtual_amp.c
index 19e5530..62ebb50 100644
--- a/net/mac80211/virtual_amp.c
+++ b/net/mac80211/virtual_amp.c
@@ -323,6 +323,72 @@ static void vamp_cmd_reset(struct vamp_data *data, struct sk_buff *skb)
 	hci_send_evt_cmplt(hdev, HCI_OP_RESET, sizeof(status), &status);
 }
 
+static struct nla_policy softamp_policy[__NL80211_CMD_SOFTAMP_LAST] = {
+	[NL80211_CMD_SOFTAMP_HCI_EVENT] = { .type = NLA_BINARY,
+					    .len = IEEE80211_MAX_DATA_LEN },
+};
+
+static int softamp_hci_event_nl(struct sk_buff *skb, struct genl_info *info)
+{
+	const u8 *frame;
+	size_t frame_len;
+
+	if (!info->attrs[NL80211_ATTR_FRAME])
+		return -EINVAL;
+
+	frame = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	frame_len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+
+	/* Handle NL event */
+
+	return 0;
+}
+
+/* Generic Netlink operations array */
+static struct genl_ops softamp_ops[] = {
+	{
+		.cmd = NL80211_CMD_SOFTAMP_HCI_EVENT,
+		.policy = softamp_policy,
+		.doit = softamp_hci_event_nl,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+void softamp_hci_cmd_nl(struct vamp_data *data, struct sk_buff *skb)
+{
+	struct cfg80211_registered_device *rdev;
+	struct hci_dev *hdev = data->hdev;
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = genlmsg_put(msg, 0, 0, &softamp_fam, 0,
+			  NL80211_CMD_SOFTAMP_HCI_EVENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	rdev = wiphy_to_dev(data->sdata->wdev.wiphy);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, (unsigned long) hdev->id);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, skb->len, skb->data);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, data->nlpid);
+
+nla_put_failure:
+	BT_ERR("%s", hdev->name);
+}
+
 static void vamp_command_packet(struct vamp_data *data, struct sk_buff *skb)
 {
 	struct hci_command_hdr *hdr = (void *) skb->data;
@@ -358,6 +424,7 @@ static void vamp_command_packet(struct vamp_data *data, struct sk_buff *skb)
 		break;
 
 	default:
+		softamp_hci_cmd_nl(data, skb);
 		break;
 	}
 
diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
index 3717530..a353ac3 100644
--- a/net/mac80211/virtual_amp.h
+++ b/net/mac80211/virtual_amp.h
@@ -10,7 +10,11 @@
  * published by the Free Software Foundation.
  */
 
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
+
 #include "ieee80211_i.h"
+#include "../wireless/core.h"
 
 #ifdef CONFIG_MAC80211_BLUETOOTH_SOFTAMP
 
@@ -41,11 +45,27 @@ struct vamp_data {
 	struct hci_dev *hdev;
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
+	__u32 nlpid;
 
 	struct work_struct work;
 	struct sk_buff_head txq;
 };
 
+/* Netlink */
+enum {
+	NL80211_CMD_SOFTAMP_HCI_EVENT,
+	__NL80211_CMD_SOFTAMP_LAST,
+};
+
+/* Soft AMP netlinf family */
+static struct genl_family softamp_fam = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "Soft AMP",
+	.version = 1,
+	.maxattr = __NL80211_CMD_SOFTAMP_LAST,
+};
+
 #else /* CONFIG_MAC80211_BLUETOOTH_SOFTAMP */
 
 static inline void
-- 
1.7.9.5

