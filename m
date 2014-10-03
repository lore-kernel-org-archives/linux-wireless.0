Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28401 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaJCV70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 17:59:26 -0400
From: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <pxu@qca.qualcomm.com>, <cfg80211mac80211@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Add support for ACS offloading
Date: Fri, 3 Oct 2014 14:58:58 -0700
Message-ID: <1412373538-17690-1-git-send-email-kyeyoonp@qca.qualcomm.com> (sfid-20141003_235933_902247_7896413D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qca.qualcomm.com>

Add support for offloading ACS functionality to the driver. A new
feature flag NL80211_FEATURE_AP_ACS_OFFLOAD was added to support
ACS (Automatic Channel Selection) offload functionality. This flag
allows the driver to advertise its ACS capability.

When hostapd starts with the "channel" configuration set to 0, it will
check whether the driver has the capability of doing the ACS on its own.
If the driver has such capability, then the channel selection will be
done in the driver. The kernel will skip the channel information
validation since it would initially be NULL when this feature is
enabled. After the channel is selected by the driver, a channel
change event will be sent from the driver to the kernel which updates
the channel information it maintains. This event is in turn sent to
hostapd and the channel information in hostapd will get updated as well.

Signed-off-by: Peng Xu <pxu@qca.qualcomm.com>
Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/nl80211.c       | 15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4b28dc0..73c0950 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4042,6 +4042,8 @@ enum nl80211_ap_sme_features {
  *	multiplexing powersave, ie. can turn off all but one chain
  *	and then wake the rest up as required after, for example,
  *	rts/cts handshake.
+ * @NL80211_FEATURE_AP_ACS_OFFLOAD: This driver supports ACS (Automatic Channel
+ *     Selection) during AP starting time.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4070,6 +4072,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
 	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
+	NL80211_FEATURE_AP_ACS_OFFLOAD			= 1 << 26,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cb9f5a4..846860d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1990,7 +1990,8 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			}
 
 			/* Only allow dynamic channel width changes */
-			if (chandef.chan != wdev->preset_chandef.chan) {
+			if ((wdev->preset_chandef.chan != NULL) &&
+			    chandef.chan != wdev->preset_chandef.chan) {
 				result = -EBUSY;
 				break;
 			}
@@ -3220,6 +3221,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
+	bool acs_offload = false;
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -3333,10 +3335,15 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	} else if (wdev->preset_chandef.chan) {
 		params.chandef = wdev->preset_chandef;
-	} else if (!nl80211_get_ap_channel(rdev, &params))
-		return -EINVAL;
+	} else if (!nl80211_get_ap_channel(rdev, &params)) {
+		if (rdev->wiphy.features & NL80211_FEATURE_AP_ACS_OFFLOAD)
+			acs_offload = true;
+		else
+			return -EINVAL;
+	}
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+	if (!acs_offload &&
+	    !cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
 				     wdev->iftype))
 		return -EINVAL;
 
-- 
1.9.1

