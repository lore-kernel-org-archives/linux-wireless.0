Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab3BKPCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 10:02:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2] hostapd/wpa_s: use driver's extended capabilities
Date: Mon, 11 Feb 2013 16:02:04 +0100
Message-Id: <1360594924-31047-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_160218_909978_AB006764)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some extended capabilities (I'm currently interested in
"Operating Mode Notification" for VHT) are implemented
by the kernel driver and exported in nl80211. Use these
in hostapd/wpa_supplicant.

Signed-hostap: Johannes Berg <johannes.berg@intel.com>
---
 hostapd/main.c                    |  2 +
 src/ap/hostapd.h                  |  4 ++
 src/ap/ieee802_11_shared.c        | 82 +++++++++++++++++++--------------------
 src/drivers/driver.h              |  6 +++
 src/drivers/driver_nl80211.c      | 13 +++++++
 wpa_supplicant/ap.c               |  2 +
 wpa_supplicant/wpa_supplicant.c   | 52 ++++++++++++++++++-------
 wpa_supplicant/wpa_supplicant_i.h |  4 ++
 8 files changed, 109 insertions(+), 56 deletions(-)

diff --git a/hostapd/main.c b/hostapd/main.c
index d4256d0..eae89b6 100644
--- a/hostapd/main.c
+++ b/hostapd/main.c
@@ -273,6 +273,8 @@ static int hostapd_driver_init(struct hostapd_iface *iface)
 	    hapd->driver->get_capa(hapd->drv_priv, &capa) == 0) {
 		iface->drv_flags = capa.flags;
 		iface->probe_resp_offloads = capa.probe_resp_offloads;
+		iface->extended_capa = capa.extended_capa;
+		iface->extended_capa_len = capa.extended_capa_len;
 	}
 
 	return 0;
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index 8ab4f3e..4614ddd 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -229,6 +229,10 @@ struct hostapd_iface {
 	 */
 	unsigned int probe_resp_offloads;
 
+	/* extended capabilities supported by the driver */
+	u8 *extended_capa;
+	unsigned int extended_capa_len;
+
 	struct hostapd_hw_modes *hw_features;
 	int num_hw_features;
 	struct hostapd_hw_modes *current_mode;
diff --git a/src/ap/ieee802_11_shared.c b/src/ap/ieee802_11_shared.c
index 76f78a7..1b353a7 100644
--- a/src/ap/ieee802_11_shared.c
+++ b/src/ap/ieee802_11_shared.c
@@ -167,7 +167,7 @@ void ieee802_11_sa_query_action(struct hostapd_data *hapd, const u8 *sa,
 u8 * hostapd_eid_ext_capab(struct hostapd_data *hapd, u8 *eid)
 {
 	u8 *pos = eid;
-	u8 len = 0;
+	u8 len = 0, i;
 
 	if (hapd->conf->tdls & (TDLS_PROHIBIT | TDLS_PROHIBIT_CHAN_SWITCH))
 		len = 5;
@@ -181,53 +181,53 @@ u8 * hostapd_eid_ext_capab(struct hostapd_data *hapd, u8 *eid)
 	if (len < 4)
 		len = 4;
 #endif /* CONFIG_WNM */
+	if (len < hapd->iface->extended_capa_len)
+		len = hapd->iface->extended_capa_len;
 	if (len == 0)
 		return eid;
 
 	*pos++ = WLAN_EID_EXT_CAPAB;
 	*pos++ = len;
-	*pos++ = 0x00;
-	*pos++ = 0x00;
-
-	*pos = 0x00;
-	if (hapd->conf->wnm_sleep_mode)
-		*pos |= 0x02; /* Bit 17 - WNM-Sleep Mode */
-	if (hapd->conf->bss_transition)
-		*pos |= 0x08; /* Bit 19 - BSS Transition */
-	pos++;
-
-	if (len < 4)
-		return pos;
-	*pos = 0x00;
+	for (i = 0; i < len; i++, pos++) {
+		*pos = 0x00;
+
+		if (i < hapd->iface->extended_capa_len)
+			*pos |= hapd->iface->extended_capa[i];
+			
+		switch (i) {
+		case 0: /* Bits 0-7 */
+			break;
+		case 1: /* Bits 8-15 */
+			break;
+		case 2: /* Bits 16-23 */
+			if (hapd->conf->wnm_sleep_mode)
+				*pos |= 0x02; /* Bit 17 - WNM-Sleep Mode */
+			if (hapd->conf->bss_transition)
+				*pos |= 0x08; /* Bit 19 - BSS Transition */
+			break;
+		case 3: /* Bits 24-31 */
 #ifdef CONFIG_WNM
-	*pos |= 0x02; /* Bit 25 - SSID List */
+			*pos |= 0x02; /* Bit 25 - SSID List */
 #endif /* CONFIG_WNM */
-	if (hapd->conf->time_advertisement == 2)
-		*pos |= 0x08; /* Bit 27 - UTC TSF Offset */
-	if (hapd->conf->interworking)
-		*pos |= 0x80; /* Bit 31 - Interworking */
-	pos++;
-
-	if (len < 5)
-		return pos;
-	*pos = 0x00;
-	if (hapd->conf->tdls & TDLS_PROHIBIT)
-		*pos |= 0x40; /* Bit 38 - TDLS Prohibited */
-	if (hapd->conf->tdls & TDLS_PROHIBIT_CHAN_SWITCH)
-		*pos |= 0x80; /* Bit 39 - TDLS Channel Switching Prohibited */
-	pos++;
-
-	if (len < 6)
-		return pos;
-	*pos = 0x00;
-	pos++;
-
-	if (len < 7)
-		return pos;
-	*pos = 0x00;
-	if (hapd->conf->ssid.utf8_ssid)
-		*pos |= 0x01; /* Bit 48 - UTF-8 SSID */
-	pos++;
+			if (hapd->conf->time_advertisement == 2)
+				*pos |= 0x08; /* Bit 27 - UTC TSF Offset */
+			if (hapd->conf->interworking)
+				*pos |= 0x80; /* Bit 31 - Interworking */
+			break;
+		case 4: /* Bits 32-39 */
+			if (hapd->conf->tdls & TDLS_PROHIBIT)
+				*pos |= 0x40; /* Bit 38 - TDLS Prohibited */
+			if (hapd->conf->tdls & TDLS_PROHIBIT_CHAN_SWITCH)
+				*pos |= 0x80; /* Bit 39 - TDLS Channel Switching Prohibited */
+			break;
+		case 5: /* Bits 40-47 */
+			break;
+		case 6: /* Bits 48-55 */
+			if (hapd->conf->ssid.utf8_ssid)
+				*pos |= 0x01; /* Bit 48 - UTF-8 SSID */
+			break;
+		}
+	}
 
 	return pos;
 }
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 6a5b5ae..0a6df8d 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -880,6 +880,12 @@ struct wpa_driver_capa {
 /* Driver Probe Response offloading support for IEEE 802.11u (Interworking) */
 #define WPA_DRIVER_PROBE_RESP_OFFLOAD_INTERWORKING	0x00000008
 	unsigned int probe_resp_offloads;
+
+	/**
+	 * extended_capa - extended capabilities in driver/device
+	 */
+	u8 *extended_capa;
+	unsigned int extended_capa_len;
 };
 
 
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index e4b70fe..2ee5733 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2729,6 +2729,18 @@ broken_combination:
 			probe_resp_offload_support(protocols);
 	}
 
+	if (tb[NL80211_ATTR_EXT_CAPA]) {
+		capa->extended_capa =
+			os_malloc(nla_len(tb[NL80211_ATTR_EXT_CAPA]));
+		if (capa->extended_capa) {
+			os_memcpy(capa->extended_capa,
+				  nla_data(tb[NL80211_ATTR_EXT_CAPA]),
+				  nla_len(tb[NL80211_ATTR_EXT_CAPA]));
+			capa->extended_capa_len =
+				nla_len(tb[NL80211_ATTR_EXT_CAPA]);
+		}
+	}
+
 	return NL_SKIP;
 }
 
@@ -3601,6 +3613,7 @@ static void wpa_driver_nl80211_deinit(struct i802_bss *bss)
 	if (drv->in_interface_list)
 		dl_list_del(&drv->list);
 
+	os_free(drv->capa.extended_capa);
 	os_free(drv);
 }
 
diff --git a/wpa_supplicant/ap.c b/wpa_supplicant/ap.c
index 85ee6cb..f348a5f 100644
--- a/wpa_supplicant/ap.c
+++ b/wpa_supplicant/ap.c
@@ -486,6 +486,8 @@ int wpa_supplicant_create_ap(struct wpa_supplicant *wpa_s,
 	hapd_iface->owner = wpa_s;
 	hapd_iface->drv_flags = wpa_s->drv_flags;
 	hapd_iface->probe_resp_offloads = wpa_s->probe_resp_offloads;
+	hapd_iface->extended_capa = wpa_s->extended_capa;
+	hapd_iface->extended_capa_len = wpa_s->extended_capa_len;
 
 	wpa_s->ap_iface->conf = conf = hostapd_config_defaults();
 	if (conf == NULL) {
diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index ae4f22f..ccb869a 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -1189,26 +1189,46 @@ int wpa_supplicant_set_suites(struct wpa_supplicant *wpa_s,
 
 int wpas_build_ext_capab(struct wpa_supplicant *wpa_s, u8 *buf)
 {
-	u32 ext_capab = 0;
 	u8 *pos = buf;
+	u8 len = 4, i;
 
-#ifdef CONFIG_INTERWORKING
-	if (wpa_s->conf->interworking)
-		ext_capab |= BIT(31); /* Interworking */
-#endif /* CONFIG_INTERWORKING */
+	if (len < wpa_s->extended_capa_len)
+		len = wpa_s->extended_capa_len;
 
+	*pos++ = WLAN_EID_EXT_CAPAB;
+	*pos++ = len;
+	for (i = 0; i < len; i++, pos++) {
+		*pos = 0x00;
+
+		if (i < wpa_s->extended_capa_len)
+			*pos |= wpa_s->extended_capa[i];
+			
+		switch (i) {
+		case 0: /* Bits 0-7 */
+			break;
+		case 1: /* Bits 8-15 */
+			break;
+		case 2: /* Bits 16-23 */
+#ifdef CONFIG_WNM
+			*pos |= 0x02; /* Bit 17 - WNM-Sleep Mode */
+			*pos |= 0x08; /* Bit 19 - BSS Transition */
+#endif
+			break;
+		case 3: /* Bits 24-31 */
 #ifdef CONFIG_WNM
-	ext_capab |= BIT(17); /* WNM-Sleep Mode */
-	ext_capab |= BIT(19); /* BSS Transition */
+			*pos |= 0x02; /* Bit 25 - SSID List */
 #endif /* CONFIG_WNM */
-
-	if (!ext_capab)
-		return 0;
-
-	*pos++ = WLAN_EID_EXT_CAPAB;
-	*pos++ = 4;
-	WPA_PUT_LE32(pos, ext_capab);
-	pos += 4;
+			if (wpa_s->conf->interworking)
+				*pos |= 0x80; /* Bit 31 - Interworking */
+			break;
+		case 4: /* Bits 32-39 */
+			break;
+		case 5: /* Bits 40-47 */
+			break;
+		case 6: /* Bits 48-55 */
+			break;
+		}
+	}
 
 	return pos - buf;
 }
@@ -2862,6 +2882,8 @@ next_driver:
 		wpa_s->max_match_sets = capa.max_match_sets;
 		wpa_s->max_remain_on_chan = capa.max_remain_on_chan;
 		wpa_s->max_stations = capa.max_stations;
+		wpa_s->extended_capa = capa.extended_capa;
+		wpa_s->extended_capa_len = capa.extended_capa_len;
 	}
 	if (wpa_s->max_remain_on_chan == 0)
 		wpa_s->max_remain_on_chan = 1000;
diff --git a/wpa_supplicant/wpa_supplicant_i.h b/wpa_supplicant/wpa_supplicant_i.h
index 0f51f8e..5a43e12 100644
--- a/wpa_supplicant/wpa_supplicant_i.h
+++ b/wpa_supplicant/wpa_supplicant_i.h
@@ -459,6 +459,10 @@ struct wpa_supplicant {
 	 */
 	unsigned int probe_resp_offloads;
 
+	/* extended capabilities supported by the driver */
+	u8 *extended_capa;
+	unsigned int extended_capa_len;
+
 	int max_scan_ssids;
 	int max_sched_scan_ssids;
 	int sched_scan_supported;
-- 
1.8.0

