Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49371 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaJVHem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 03:34:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make WMM TSPEC support flag an nl80211 feature flag
Date: Wed, 22 Oct 2014 09:34:32 +0200
Message-Id: <1413963272-17873-1-git-send-email-johannes@sipsolutions.net> (sfid-20141022_093445_577306_7DB33153)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During the review of the corresponding wpa_supplicant patches we
noticed that the only way for it to detect that this functionality
is supported currently is to check for the command support. This
can be misleading though, as the command was also designed to, in
the future, support pure 802.11 TSPECs.

Expose the WMM-TSPEC feature flag to nl80211 so later we can also
expose an 802.11-TSPEC feature flag (if needed) to differentiate
the two cases.

Note: this change isn't needed in 3.18 as there's no driver there
yet that supports the functionality at all.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  6 +-----
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 14 ++++++--------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed896c0b5b8b..77aa805d7e7c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2646,13 +2646,9 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
- * @WIPHY_FLAG_SUPPORTS_WMM_ADMISSION: the device supports setting up WMM
- *	TSPEC sessions (TID aka TSID 0-7) with the NL80211_CMD_ADD_TX_TS
- *	command. Standard IEEE 802.11 TSPEC setup is not yet supported, it
- *	needs to be able to handle Block-Ack agreements and other things.
  */
 enum wiphy_flags {
-	WIPHY_FLAG_SUPPORTS_WMM_ADMISSION	= BIT(0),
+	/* use hole at 0 */
 	/* use hole at 1 */
 	/* use hole at 2 */
 	WIPHY_FLAG_NETNS_OK			= BIT(3),
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b553c48404d3..be1d5def304d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4052,6 +4052,10 @@ enum nl80211_ap_sme_features {
  *	multiplexing powersave, ie. can turn off all but one chain
  *	and then wake the rest up as required after, for example,
  *	rts/cts handshake.
+ * @NL80211_FEATURE_SUPPORTS_WMM_ADMISSION: the device supports setting up WMM
+ *	TSPEC sessions (TID aka TSID 0-7) with the %NL80211_CMD_ADD_TX_TS
+ *	command. Standard IEEE 802.11 TSPEC setup is not yet supported, it
+ *	needs to be able to handle Block-Ack agreements and other things.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4080,6 +4084,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
 	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
+	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d05fe6d6481d..fe7994b251ab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1514,8 +1514,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
 			CMD(set_qos_map, SET_QOS_MAP);
-			if (rdev->wiphy.flags &
-					WIPHY_FLAG_SUPPORTS_WMM_ADMISSION)
+			if (rdev->wiphy.features &
+					NL80211_FEATURE_SUPPORTS_WMM_ADMISSION)
 				CMD(add_tx_ts, ADD_TX_TS);
 		}
 		/* add into the if now */
@@ -9557,7 +9557,7 @@ static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
 	u16 admitted_time = 0;
 	int err;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_WMM_ADMISSION))
+	if (!(rdev->wiphy.features & NL80211_FEATURE_SUPPORTS_WMM_ADMISSION))
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_TSID] || !info->attrs[NL80211_ATTR_MAC] ||
@@ -9573,12 +9573,10 @@ static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* WMM uses TIDs 0-7 even for TSPEC */
-	if (tsid < IEEE80211_FIRST_TSPEC_TSID) {
-		if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_WMM_ADMISSION))
-			return -EINVAL;
-	} else {
+	if (tsid >= IEEE80211_FIRST_TSPEC_TSID) {
 		/* TODO: handle 802.11 TSPEC/admission control
-		 * need more attributes for that (e.g. BA session requirement)
+		 * need more attributes for that (e.g. BA session requirement),
+		 * change code above to allow both in that case.
 		 */
 		return -EINVAL;
 	}
-- 
2.1.0

