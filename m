Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:37498 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FCHEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 03:04:32 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying any frequency
Date: Mon,  3 Jun 2013 08:39:46 +0200
Message-Id: <1370241587-2609-1-git-send-email-ordex@autistici.org> (sfid-20130603_090437_224255_02F46480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Users may want to send a frame on the current channel
without specifying it.

Make mgmt_tx pass a NULL channel to mac80211 if none has
been specified by the user.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/wireless/nl80211.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31d265f..c2376c7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7142,6 +7142,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	switch (wdev->iftype) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+			return -EINVAL;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -7149,7 +7152,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -7177,9 +7179,16 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
-	if (err)
-		return err;
+	/*
+	 * get the channel if any has been specified, otherwise pass NULL to
+	 * mac80211. The latter will use the current one
+	 */
+	chandef.chan = NULL;
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		err = nl80211_parse_chandef(rdev, info, &chandef);
+		if (err)
+			return err;
+	}
 
 	if (!dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-- 
1.8.1.5

