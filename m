Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63150 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdALXMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 18:12:44 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v3 1/4] cfg80211: Add support to randomize TA of Public Action frames
Date: Fri, 13 Jan 2017 01:12:19 +0200
Message-ID: <1484262742-3927-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170113_001247_897025_FAD9FE18)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: vamsi krishna <vamsin@qti.qualcomm.com>

Add support to use a random local address (Address 2 = TA in transmit
and the same address in receive functionality) for Public Action frames
in order to improve privacy of WLAN clients. Applications fill the
random transmit address in the frame buffer in the NL80211_CMD_FRAME
command. This can be used only with the drivers that indicate support
for random local address by setting the new
NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA and/or
NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED in ext_features.

The driver needs to configure receive behavior to accept frames to the
specified random address during the time the frame exchange is pending
and such frames need to be acknowledged similarly to frames sent to the
local permanent address when this random address functionality is not
used.

Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/mlme.c          | 21 +++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

v3:
- moved to the beginning of the series since there were no pending
  comments on this patch; no other changes

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 174f4b3..908886c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4699,6 +4699,10 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with VHT rates.
  * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
  *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
+ * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA: This driver supports randomized TA
+ *	in @NL80211_CMD_FRAME while not associated.
+ * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED: This driver supports
+ *	randomized TA in @NL80211_CMD_FRAME while associated.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4714,6 +4718,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
 	NL80211_EXT_FEATURE_FILS_STA,
+	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA,
+	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1c63a77..b876f40 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -662,8 +662,25 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
-		return -EINVAL;
+	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev))) {
+		/* Allow random TA to be used with Public Action frames if the
+		 * driver has indicated support for this. Otherwise, only allow
+		 * the local address to be used.
+		 */
+		if (!ieee80211_is_action(mgmt->frame_control) ||
+		    mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
+			return -EINVAL;
+		if (!wdev->current_bss &&
+		    !wiphy_ext_feature_isset(
+			    &rdev->wiphy,
+			    NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA))
+			return -EINVAL;
+		if (wdev->current_bss &&
+		    !wiphy_ext_feature_isset(
+			    &rdev->wiphy,
+			    NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED))
+			return -EINVAL;
+	}
 
 	/* Transmit the Action frame as requested by user space */
 	return rdev_mgmt_tx(rdev, wdev, params, cookie);
-- 
2.7.4
