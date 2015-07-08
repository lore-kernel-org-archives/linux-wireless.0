Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbbGHMmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] mac80211: add possibility to advertise 802.11 FTM support
Date: Wed,  8 Jul 2015 15:41:49 +0300
Message-Id: <1436359312-26533-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144228_968070_E0A49984)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Add possibility for a driver to advertise 802.11 Fine Timing Measurement
support.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h  | 6 ++++++
 include/net/mac80211.h     | 6 ++++++
 net/mac80211/debugfs.c     | 1 +
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/main.c        | 3 +++
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b9c7897..63c2209 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2077,6 +2077,12 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
 #define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(7)
 
+/*
+ * Fine Timing Measurement Initiator - bit 71 of @WLAN_EID_EXT_CAPABILITY
+ * information element
+ */
+#define WLAN_EXT_CAPA9_FTM_INITIATOR	BIT(7)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3314e5..6efb766 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1892,6 +1892,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TDLS_WIDER_BW: The device/driver supports wider bandwidth
  *	than then BSS bandwidth for a TDLS link on the base channel.
  *
+ * @IEEE80211_HW_SUPPORTS_FTM_INITIATOR:
+ *	Hardware supports 802.11 Fine Timing Measurement Initiator.
+ *	This flag should be set only if the support can be provided without
+ *	involvement of the stack; otherwise leave it to stack to decide.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1925,6 +1930,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CLONED_SKBS,
 	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS,
 	IEEE80211_HW_TDLS_WIDER_BW,
+	IEEE80211_HW_SUPPORTS_FTM_INITIATOR,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index ced6bf3..936f064 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -123,6 +123,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(SUPPORTS_CLONED_SKBS),
 	FLAG(SINGLE_SCAN_ON_ALL_BANDS),
 	FLAG(TDLS_WIDER_BW),
+	FLAG(SUPPORTS_FTM_INITIATOR),
 
 	/* keep last for the build bug below */
 	(void *)0x1
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 36f217e..38db179 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1349,7 +1349,7 @@ struct ieee80211_local {
 	struct cfg80211_chan_def monitor_chandef;
 
 	/* extended capabilities provided by mac80211 */
-	u8 ext_capa[8];
+	u8 ext_capa[9];
 
 	/* TDLS channel switch */
 	struct work_struct tdls_chsw_work;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ff79a13..ee1bc81 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1007,6 +1007,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_FTM_INITIATOR))
+		local->ext_capa[8] |= WLAN_EXT_CAPA9_FTM_INITIATOR;
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
-- 
2.1.4

