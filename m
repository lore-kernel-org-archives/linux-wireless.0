Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:56117 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYCaPFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 11:05:16 -0400
Message-ID: <47F0FDA6.3000609@work.ksp.sk> (sfid-20080331_160527_968711_C78127FB)
Date: Mon, 31 Mar 2008 17:05:10 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 2/2] mac80211: use short_preamble mode from capability if
 ERP IE not present
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When associating to a b-only AP where there is no ERP IE, short preamble
mode is left at previous state (probably also protection mode). In this
case, disable protection and use short preamble mode as specified in
capability field. The same is done if capability field is changed on-the-fly.

Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

---
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 6fb179a..2b49852 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -353,14 +353,12 @@ static void ieee80211_sta_wmm_params(struct net_device *dev,
 	}
 }

-
-static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
-				   u8 erp_value)
+static u32 ieee80211_handle_protect_preamb(struct ieee80211_sub_if_data *sdata,
+					   bool use_protection,
+					   bool use_short_preamble)
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
-	bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
 	DECLARE_MAC_BUF(mac);
 	u32 changed = 0;

@@ -391,6 +389,32 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }

+static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
+				   u8 erp_value)
+{
+	bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
+	bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
+
+	return ieee80211_handle_protect_preamb(sdata,
+			use_protection, use_short_preamble);
+}
+
+static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_sta_bss *bss)
+{
+	u32 changed = 0;
+
+	if (bss->has_erp_value)
+		changed |= ieee80211_handle_erp_ie(sdata, bss->erp_value);
+	else {
+		u16 capab = bss->capability;
+		changed |= ieee80211_handle_protect_preamb(sdata, false,
+				(capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
+	}
+
+	return changed;
+}
+
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 				   struct ieee80211_ht_info *ht_info)
 {
@@ -509,9 +533,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
-			if (bss->has_erp_value)
-				changed |= ieee80211_handle_erp_ie(
-						sdata, bss->erp_value);
+			changed |= ieee80211_handle_bss_capability(sdata, bss);
 			ieee80211_rx_bss_put(dev, bss);
 		}

@@ -2756,6 +2778,11 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,

 	if (elems.erp_info && elems.erp_info_len >= 1)
 		changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
+	else {
+		u16 capab = le16_to_cpu(mgmt->u.beacon.capab_info);
+		changed |= ieee80211_handle_protect_preamb(sdata, false,
+				(capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
+	}

 	if (elems.ht_cap_elem && elems.ht_info_elem &&
 	    elems.wmm_param && local->ops->conf_ht &&
