Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBLOGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 09:06:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL
Date: Wed, 12 Feb 2014 15:06:40 +0100
Message-Id: <1392214000-28846-1-git-send-email-johannes@sipsolutions.net> (sfid-20140212_150652_134808_F43A34DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no driver using this flag and consequently no userspace
application is actually looking at it. As it seems unlikely for
any driver to start using it, remove it and the (very little)
code that used it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 7 +------
 net/wireless/chan.c          | 6 +-----
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a12e6ca..ba1f762 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3843,11 +3843,6 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
- * @NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL: If this is set, an active
- *	P2P Device (%NL80211_IFTYPE_P2P_DEVICE) requires its own channel
- *	in the interface combinations, even when it's only used for scan
- *	and remain-on-channel. This could be due to, for example, the
- *	remain-on-channel implementation requiring a channel context.
  * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
  *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
  *	mode
@@ -3889,7 +3884,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_HT_IBSS				= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
-	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	/* bit 4 is reserved - don't use */
 	NL80211_FEATURE_SAE				= 1 << 5,
 	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index f8ab7df..5946450 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -705,12 +705,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
-		/* these interface types don't really have a channel */
-		return;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (wdev->wiphy->features &
-				NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL)
-			*chanmode = CHAN_MODE_EXCLUSIVE;
+		/* these interface types don't really have a channel */
 		return;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
-- 
1.8.5.3

