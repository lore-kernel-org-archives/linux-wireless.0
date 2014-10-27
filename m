Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaJ0Kpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:45:34 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO
Date: Mon, 27 Oct 2014 12:44:48 +0200
Message-Id: <1414406688-3827-4-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114553_053819_C919426C)
In-Reply-To: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When deleting old radio via HWSIM_CMD_DEL_RADIO then listeners on the
multicast group "config" are informed.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 43 ++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 74bc1db..b50a739 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2293,8 +2293,39 @@ failed:
 	return err;
 }
 
-static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
+static void mcast_del_radio(int id, struct genl_info *info)
 {
+	struct sk_buff *mcast_skb;
+	void *data;
+	int ret;
+
+	mcast_skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!mcast_skb)
+		return;
+
+	data = genlmsg_put(mcast_skb, 0, 0, &hwsim_genl_family, 0,
+			   HWSIM_CMD_DEL_RADIO);
+	if (!data)
+		goto error;
+
+	ret = nla_put_u32(mcast_skb, HWSIM_ATTR_RADIO_ID, id);
+	if (ret < 0)
+		goto error;
+
+	genlmsg_end(mcast_skb, data);
+
+	mcast_msg(mcast_skb, info);
+
+	return;
+
+error:
+	nlmsg_free(mcast_skb);
+}
+
+static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
+				     struct genl_info *info)
+{
+	mcast_del_radio(data->idx, info);
 	debugfs_remove_recursive(data->debugfs);
 	ieee80211_unregister_hw(data->hw);
 	device_release_driver(data->dev);
@@ -2312,7 +2343,7 @@ static void mac80211_hwsim_free(void)
 						list))) {
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, NULL);
 		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2562,7 +2593,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 					p2p_device, use_chanctx);
 }
 
-static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
+static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
 	int idx;
@@ -2577,7 +2608,7 @@ static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			continue;
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, info);
 		return 0;
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2610,9 +2641,9 @@ static const struct genl_ops hwsim_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = HWSIM_CMD_DESTROY_RADIO,
+		.cmd = HWSIM_CMD_DEL_RADIO,
 		.policy = hwsim_genl_policy,
-		.doit = hwsim_destroy_radio_nl,
+		.doit = hwsim_del_radio_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 };
-- 
1.8.3.1

