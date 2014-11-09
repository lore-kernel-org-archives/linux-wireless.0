Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41338 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKIQug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:36 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi2so8412605wib.13
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:35 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/16] cfg/mac80211: define TDLS channel switch feature bit
Date: Sun,  9 Nov 2014 18:50:14 +0200
Message-Id: <1415551822-20121-8-git-send-email-arik@wizery.com> (sfid-20141109_175043_192639_18A33304)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define some related TDLS protocol constants and advertise channel switch
support in the extended-capabilities IE when the feature bit is defined.

Actually supporting TDLS channel-switching also requires support for
some new nl80211 commands, to be introduced by future patches.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/ieee80211.h    | 6 ++++++
 include/uapi/linux/nl80211.h | 3 +++
 net/mac80211/tdls.c          | 9 ++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index adac1be..fbb02d2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2019,6 +2019,11 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
 
+/* TDLS capabilities in the the 4th byte of @WLAN_EID_EXT_CAPABILITY */
+#define WLAN_EXT_CAPA4_TDLS_BUFFER_STA		BIT(4)
+#define WLAN_EXT_CAPA4_TDLS_PEER_PSM		BIT(5)
+#define WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH		BIT(6)
+
 /* Interworking capabilities are set in 7th bit of 4th byte of the
  * @WLAN_EID_EXT_CAPABILITY information element
  */
@@ -2030,6 +2035,7 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA5_TDLS_ENABLED	BIT(5)
 #define WLAN_EXT_CAPA5_TDLS_PROHIBITED	BIT(6)
+#define WLAN_EXT_CAPA5_TDLS_CH_SW_PROHIBITED	BIT(7)
 
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
 #define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(7)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9b3025e..e7f01d6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4070,6 +4070,8 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
  *	the vif's MAC address upon creation.
  *	See 'macaddr' field in the vif_params (cfg80211.h).
+ * @NL80211_FEATURE_TDLS_CHANNEL_SWITCH: Driver supports channel switching when
+ *	operating as a TDLS peer.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4100,6 +4102,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
 	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
 	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 27,
+	NL80211_FEATURE_TDLS_CHANNEL_SWITCH		= 1 << 28,
 };
 
 /**
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 30a4c10..4554bdc 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -35,16 +35,19 @@ void ieee80211_tdls_peer_del_work(struct work_struct *wk)
 	mutex_unlock(&local->mtx);
 }
 
-static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
+static void ieee80211_tdls_add_ext_capab(struct ieee80211_local *local,
+					 struct sk_buff *skb)
 {
 	u8 *pos = (void *)skb_put(skb, 7);
+	bool chan_switch = local->hw.wiphy->features &
+			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 
 	*pos++ = WLAN_EID_EXT_CAPABILITY;
 	*pos++ = 5; /* len */
 	*pos++ = 0x0;
 	*pos++ = 0x0;
 	*pos++ = 0x0;
-	*pos++ = 0x0;
+	*pos++ = chan_switch ? WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH : 0;
 	*pos++ = WLAN_EXT_CAPA5_TDLS_ENABLED;
 }
 
@@ -289,7 +292,7 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
-	ieee80211_tdls_add_ext_capab(skb);
+	ieee80211_tdls_add_ext_capab(local, skb);
 
 	/* add the QoS element if we support it */
 	if (local->hw.queues >= IEEE80211_NUM_ACS &&
-- 
1.9.1

