Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:51119 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3FEPLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:11:52 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv4 4/4] nl80211: allow sending CMD_FRAME without specifying any frequency
Date: Wed,  5 Jun 2013 17:09:49 +0200
Message-Id: <1370444989-2095-4-git-send-email-ordex@autistici.org> (sfid-20130605_171156_346187_50752627)
In-Reply-To: <1370444989-2095-1-git-send-email-ordex@autistici.org>
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Users may want to send a frame on the current channel
without specifying it.

This is particularly useful for the correct implementation
of the IBSS/RSN support in wpa_supplicant which requires to
receive and send AUTH frames.

Make mgmt_tx pass a NULL channel to the driver if none has
been specified by the user.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

v3:
- moved from 1/4 to 4/4


 net/wireless/nl80211.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 88e820b..06af395 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7139,6 +7139,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	switch (wdev->iftype) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+			return -EINVAL;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -7146,7 +7149,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -7174,9 +7176,15 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
-	if (err)
-		return err;
+	/* get the channel if any has been specified, otherwise pass NULL to
+	 * the driver. The latter will use the current one
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

