Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12616 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbcGHK2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:28:34 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <ganeshk@qti.qualcomm.com>,
	<mkalikot@qca.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Add support for user configurable beacon data rate
Date: Fri, 8 Jul 2016 15:58:10 +0530
Message-ID: <1467973690-32120-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160708_122844_220402_00258612)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow user to configure beacon tx rate from userspace. This adds
new nl80211 attribute as NL80211_ATTR_BEACON_RATE.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h       | 3 ++-
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..ad0200b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -685,6 +685,7 @@ struct cfg80211_acl_data {
  * @beacon: beacon data
  * @beacon_interval: beacon interval
  * @dtim_period: DTIM period
+ * @beacon_txrate: beacon tx rate
  * @ssid: SSID to be used in the BSS (note: may be %NULL if not provided from
  *	user space)
  * @ssid_len: length of @ssid
@@ -706,7 +707,7 @@ struct cfg80211_ap_settings {
 
 	struct cfg80211_beacon_data beacon;
 
-	int beacon_interval, dtim_period;
+	int beacon_interval, dtim_period, beacon_txrate;
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_hidden_ssid hidden_ssid;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..f338909 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1867,6 +1867,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer (u16). This is
  *	used to pull the stored data for mesh peer in power save state.
  *
+ * @NL80211_ATTR_BEACON_TXRATE: User configurable beacon data rate (u32). This is
+ *	used to set beacon tx rate.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2261,6 +2264,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PEER_AID,
 
+	NL80211_ATTR_BEACON_TXRATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5782f71..020b753 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -409,6 +409,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
+	[NL80211_ATTR_BEACON_TXRATE] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3568,6 +3569,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.smps_mode = NL80211_SMPS_OFF;
 	}
 
+	if (info->attrs[NL80211_ATTR_BEACON_TXRATE])
+		params.beacon_txrate =
+			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_TXRATE]);
+
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
 		params.acl = parse_acl_data(&rdev->wiphy, info);
 		if (IS_ERR(params.acl))
-- 
1.9.1

