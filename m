Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbYJGQ6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:18 -0400
Message-Id: <20081007100443.395429000@sipsolutions.net> (sfid-20081007_185842_408797_9F85B905)
References: <20081007100428.868688000@sipsolutions.net>
Date: Tue, 07 Oct 2008 12:04:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] mac80211: fix short slot handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 handle short slot requests from
the AP properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    8 +++--
 net/mac80211/main.c    |    9 +++--
 net/mac80211/mlme.c    |   74 ++++++++++++++++++++++++++-----------------------
 3 files changed, 52 insertions(+), 39 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-10-07 11:27:04.000000000 +0200
+++ everything/net/mac80211/main.c	2008-10-07 11:51:31.000000000 +0200
@@ -346,9 +346,12 @@ void ieee80211_bss_info_change_notify(st
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 {
-	sdata->bss_conf.use_cts_prot = 0;
-	sdata->bss_conf.use_short_preamble = 0;
-	return BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE;
+	sdata->bss_conf.use_cts_prot = false;
+	sdata->bss_conf.use_short_preamble = false;
+	sdata->bss_conf.use_short_slot = false;
+	return BSS_CHANGED_ERP_CTS_PROT |
+	       BSS_CHANGED_ERP_PREAMBLE |
+	       BSS_CHANGED_ERP_SLOT;
 }
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
--- everything.orig/net/mac80211/mlme.c	2008-10-07 11:26:49.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-10-07 11:51:30.000000000 +0200
@@ -568,9 +568,8 @@ static void ieee80211_sta_wmm_params(str
 	}
 }
 
-static u32 ieee80211_handle_protect_preamb(struct ieee80211_sub_if_data *sdata,
-					   bool use_protection,
-					   bool use_short_preamble)
+static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
+					   u16 capab, bool erp_valid, u8 erp)
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -578,6 +577,19 @@ static u32 ieee80211_handle_protect_prea
 	DECLARE_MAC_BUF(mac);
 #endif
 	u32 changed = 0;
+	bool use_protection;
+	bool use_short_preamble;
+	bool use_short_slot;
+
+	if (erp_valid) {
+		use_protection = (erp & WLAN_ERP_USE_PROTECTION) != 0;
+		use_short_preamble = (erp & WLAN_ERP_BARKER_PREAMBLE) == 0;
+	} else {
+		use_protection = false;
+		use_short_preamble = !!(capab & WLAN_CAPABILITY_SHORT_PREAMBLE);
+	}
+
+	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
 
 	if (use_protection != bss_conf->use_cts_prot) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -607,30 +619,18 @@ static u32 ieee80211_handle_protect_prea
 		changed |= BSS_CHANGED_ERP_PREAMBLE;
 	}
 
-	return changed;
-}
-
-static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
-				   u8 erp_value)
-{
-	bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
-	bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
-
-	return ieee80211_handle_protect_preamb(sdata,
-			use_protection, use_short_preamble);
-}
-
-static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
-					   struct ieee80211_bss *bss)
-{
-	u32 changed = 0;
-
-	if (bss->has_erp_value)
-		changed |= ieee80211_handle_erp_ie(sdata, bss->erp_value);
-	else {
-		u16 capab = bss->capability;
-		changed |= ieee80211_handle_protect_preamb(sdata, false,
-				(capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
+	if (use_short_slot != bss_conf->use_short_slot) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: switched to %s slot"
+			       " (BSSID=%s)\n",
+			       sdata->dev->name,
+			       use_short_slot ? "short" : "long",
+			       print_mac(mac, ifsta->bssid));
+		}
+#endif
+		bss_conf->use_short_slot = use_short_slot;
+		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
 	return changed;
@@ -721,7 +721,8 @@ static void ieee80211_set_associated(str
 		sdata->bss_conf.timestamp = bss->timestamp;
 		sdata->bss_conf.dtim_period = bss->dtim_period;
 
-		changed |= ieee80211_handle_bss_capability(sdata, bss);
+		changed |= ieee80211_handle_bss_capability(sdata,
+			bss->capability, bss->has_erp_value, bss->erp_value);
 
 		ieee80211_rx_bss_put(local, bss);
 	}
@@ -1673,6 +1674,8 @@ static void ieee80211_rx_mgmt_beacon(str
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 	u32 changed = 0;
+	bool erp_valid;
+	u8 erp_value = 0;
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
@@ -1694,13 +1697,16 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
-	if (elems.erp_info && elems.erp_info_len >= 1)
-		changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
-	else {
-		u16 capab = le16_to_cpu(mgmt->u.beacon.capab_info);
-		changed |= ieee80211_handle_protect_preamb(sdata, false,
-				(capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
+
+	if (elems.erp_info && elems.erp_info_len >= 1) {
+		erp_valid = true;
+		erp_value = elems.erp_info[0];
+	} else {
+		erp_valid = false;
 	}
+	changed |= ieee80211_handle_bss_capability(sdata,
+			le16_to_cpu(mgmt->u.beacon.capab_info),
+			erp_valid, erp_value);
 
 	if (elems.ht_cap_elem && elems.ht_info_elem &&
 	    elems.wmm_param && conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
--- everything.orig/include/net/mac80211.h	2008-10-07 11:53:41.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-07 11:54:23.000000000 +0200
@@ -180,8 +180,12 @@ enum ieee80211_bss_change {
  * @assoc: association status
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
- * @use_short_preamble: use 802.11b short preamble
- * @use_short_slot: use short slot time (only relevant for ERP)
+ * @use_short_preamble: use 802.11b short preamble;
+ *	if the hardware cannot handle this it must set the
+ *	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE hardware flag
+ * @use_short_slot: use short slot time (only relevant for ERP);
+ *	if the hardware cannot handle this it must set the
+ *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for PSM
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval

-- 

