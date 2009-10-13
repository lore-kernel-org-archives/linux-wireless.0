Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36137 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505AbZJMJt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:56 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 13/22] wl1271: Added support to scan on 5 GHz band
Date: Tue, 13 Oct 2009 12:47:50 +0300
Message-Id: <1255427279-1224-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added support to scan 802.11a access points on 5 GHz band when using
wl1273 chip.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |   10 +++
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  121 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    8 ++-
 drivers/net/wireless/wl12xx/wl1271_event.c |   37 +++++++--
 drivers/net/wireless/wl12xx/wl1271_init.c  |    8 ++
 drivers/net/wireless/wl12xx/wl1271_main.c  |   11 ++-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |    3 +
 7 files changed, 160 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index dc9957e..79a7324 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -299,6 +299,15 @@ struct wl1271_rx_mem_pool_addr {
 	u32 addr_extra;
 };
 
+struct wl1271_scan {
+	u8 state;
+	u8 ssid[IW_ESSID_MAX_SIZE+1];
+	size_t ssid_len;
+	u8 active;
+	u8 high_prio;
+	u8 probe_requests;
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
@@ -382,6 +391,7 @@ struct wl1271 {
 
 	/* Are we currently scanning */
 	bool scanning;
+	struct wl1271_scan scan;
 
 	/* Our association ID */
 	u16 aid;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 204e872..6d7a40c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -509,7 +509,7 @@ out:
 }
 
 int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
-		    u8 active_scan, u8 high_prio, u8 num_channels,
+		    u8 active_scan, u8 high_prio, u8 band,
 		    u8 probe_requests)
 {
 
@@ -518,12 +518,25 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	struct ieee80211_channel *channels;
 	int i, j, n_ch, ret;
 	u16 scan_options = 0;
+	u8 ieee_band;
+
+	if (band == WL1271_SCAN_BAND_2_4_GHZ)
+		ieee_band = IEEE80211_BAND_2GHZ;
+	else if (band == WL1271_SCAN_BAND_DUAL && wl1271_11a_enabled())
+		ieee_band = IEEE80211_BAND_2GHZ;
+	else if (band == WL1271_SCAN_BAND_5_GHZ && wl1271_11a_enabled())
+		ieee_band = IEEE80211_BAND_5GHZ;
+	else
+		return -EINVAL;
 
-	if (wl->scanning)
+	if (wl->hw->wiphy->bands[ieee_band]->channels == NULL)
 		return -EINVAL;
 
-	channels = wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels;
-	n_ch = wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->n_channels;
+	channels = wl->hw->wiphy->bands[ieee_band]->channels;
+	n_ch = wl->hw->wiphy->bands[ieee_band]->n_channels;
+
+	if (wl->scanning)
+		return -EINVAL;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
@@ -540,10 +553,16 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	params->params.scan_options = scan_options;
 
 	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le32(CONF_HW_BIT_RATE_2MBPS);
+	/* Let the fw autodetect suitable tx_rate for probes */
+	params->params.tx_rate = 0;
 	params->params.tid_trigger = 0;
 	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
+	if (band == WL1271_SCAN_BAND_DUAL)
+		params->params.band = WL1271_SCAN_BAND_2_4_GHZ;
+	else
+		params->params.band = band;
+
 	for (i = 0, j = 0; i < n_ch && i < WL1271_SCAN_MAX_CHANNELS; i++) {
 		if (!(channels[i].flags & IEEE80211_CHAN_DISABLED)) {
 			params->channels[j].min_duration =
@@ -567,7 +586,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 		memcpy(params->params.ssid, ssid, len);
 	}
 
-	ret = wl1271_cmd_build_probe_req(wl, ssid, len);
+	ret = wl1271_cmd_build_probe_req(wl, ssid, len, ieee_band);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -592,6 +611,19 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	wl1271_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
 
 	wl->scanning = true;
+	if (wl1271_11a_enabled()) {
+		wl->scan.state = band;
+		if (band == WL1271_SCAN_BAND_DUAL) {
+			wl->scan.active = active_scan;
+			wl->scan.high_prio = high_prio;
+			wl->scan.probe_requests = probe_requests;
+			if (len && ssid) {
+				wl->scan.ssid_len = len;
+				memcpy(wl->scan.ssid, ssid, len);
+			} else
+				wl->scan.ssid_len = 0;
+		}
+	}
 
 	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
 	if (ret < 0) {
@@ -654,30 +686,62 @@ out:
 	return ret;
 }
 
-static int wl1271_build_basic_rates(char *rates)
+static int wl1271_build_basic_rates(char *rates, u8 band)
 {
 	u8 index = 0;
 
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
+	if (band == IEEE80211_BAND_2GHZ) {
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
+	} else if (band == IEEE80211_BAND_5GHZ) {
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_6MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_12MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_24MB;
+	} else {
+		wl1271_error("build_basic_rates invalid band: %d", band);
+	}
 
 	return index;
 }
 
-static int wl1271_build_extended_rates(char *rates)
+static int wl1271_build_extended_rates(char *rates, u8 band)
 {
 	u8 index = 0;
 
-	rates[index++] = IEEE80211_OFDM_RATE_6MB;
-	rates[index++] = IEEE80211_OFDM_RATE_9MB;
-	rates[index++] = IEEE80211_OFDM_RATE_12MB;
-	rates[index++] = IEEE80211_OFDM_RATE_18MB;
-	rates[index++] = IEEE80211_OFDM_RATE_24MB;
-	rates[index++] = IEEE80211_OFDM_RATE_36MB;
-	rates[index++] = IEEE80211_OFDM_RATE_48MB;
-	rates[index++] = IEEE80211_OFDM_RATE_54MB;
+	if (band == IEEE80211_BAND_2GHZ) {
+		rates[index++] = IEEE80211_OFDM_RATE_6MB;
+		rates[index++] = IEEE80211_OFDM_RATE_9MB;
+		rates[index++] = IEEE80211_OFDM_RATE_12MB;
+		rates[index++] = IEEE80211_OFDM_RATE_18MB;
+		rates[index++] = IEEE80211_OFDM_RATE_24MB;
+		rates[index++] = IEEE80211_OFDM_RATE_36MB;
+		rates[index++] = IEEE80211_OFDM_RATE_48MB;
+		rates[index++] = IEEE80211_OFDM_RATE_54MB;
+	} else if (band == IEEE80211_BAND_5GHZ) {
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_9MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_18MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_24MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_36MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_48MB;
+		rates[index++] =
+			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_54MB;
+	} else {
+		wl1271_error("build_basic_rates invalid band: %d", band);
+	}
 
 	return index;
 }
@@ -720,12 +784,14 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 
 }
 
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len)
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len,
+			       u8 band)
 {
 	struct wl12xx_probe_req_template template;
 	struct wl12xx_ie_rates *rates;
 	char *ptr;
 	u16 size;
+	int ret;
 
 	ptr = (char *)&template;
 	size = sizeof(struct ieee80211_header);
@@ -747,20 +813,25 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len)
 	/* Basic Rates */
 	rates = (struct wl12xx_ie_rates *)ptr;
 	rates->header.id = WLAN_EID_SUPP_RATES;
-	rates->header.len = wl1271_build_basic_rates(rates->rates);
+	rates->header.len = wl1271_build_basic_rates(rates->rates, band);
 	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
 	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
 
 	/* Extended rates */
 	rates = (struct wl12xx_ie_rates *)ptr;
 	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
-	rates->header.len = wl1271_build_extended_rates(rates->rates);
+	rates->header.len = wl1271_build_extended_rates(rates->rates, band);
 	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
 
-	return wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-				       &template, size);
+	if (band == IEEE80211_BAND_2GHZ)
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+					      &template, size);
+	else
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+					      &template, size);
+	return ret;
 }
 
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 9143087..3308940 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -39,13 +39,14 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
-		    u8 active_scan, u8 high_prio, u8 num_channels,
+		    u8 active_scan, u8 high_prio, u8 band,
 		    u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len);
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len,
+			       u8 band);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
@@ -343,6 +344,9 @@ struct wl1271_cmd_set_keys {
 #define WL1271_SCAN_OPT_PRIORITY_HIGH  4
 #define WL1271_SCAN_CHAN_MIN_DURATION  30000  /* TU */
 #define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
+#define WL1271_SCAN_BAND_2_4_GHZ 0
+#define WL1271_SCAN_BAND_5_GHZ 1
+#define WL1271_SCAN_BAND_DUAL 2
 
 struct basic_scan_params {
 	u32 rx_config_options;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 4189e97..e2d7758 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -31,19 +31,40 @@
 static int wl1271_event_scan_complete(struct wl1271 *wl,
 				      struct event_mailbox *mbox)
 {
+	int size = sizeof(struct wl12xx_probe_req_template);
 	wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 		     mbox->scheduled_scan_status);
 
 	if (wl->scanning) {
-		int size = sizeof(struct wl12xx_probe_req_template);
-		wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
-					size);
-		mutex_unlock(&wl->mutex);
-		ieee80211_scan_completed(wl->hw, false);
-		mutex_lock(&wl->mutex);
-		wl->scanning = false;
+		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
+			wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+						NULL, size);
+			/* 2.4 GHz band scanned, scan 5 GHz band, pretend
+			 * to the wl1271_cmd_scan function that we are not
+			 * scanning as it checks that.
+			 */
+			wl->scanning = false;
+			wl1271_cmd_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
+						wl->scan.active,
+						wl->scan.high_prio,
+						WL1271_SCAN_BAND_5_GHZ,
+						wl->scan.probe_requests);
+		} else {
+			if (wl->scan.state == WL1271_SCAN_BAND_2_4_GHZ)
+				wl1271_cmd_template_set(wl,
+						CMD_TEMPL_CFG_PROBE_REQ_2_4,
+						NULL, size);
+			else
+				wl1271_cmd_template_set(wl,
+						CMD_TEMPL_CFG_PROBE_REQ_5,
+						NULL, size);
+
+			mutex_unlock(&wl->mutex);
+			ieee80211_scan_completed(wl->hw, false);
+			mutex_lock(&wl->mutex);
+			wl->scanning = false;
+		}
 	}
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 6f21eea..417b415 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -59,6 +59,14 @@ static int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	if (wl1271_11a_enabled()) {
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+				NULL,
+				sizeof(struct wl12xx_probe_req_template));
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template));
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 9b1cc8d..ae41a70 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1332,13 +1332,13 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	int ret;
 	u8 *ssid = NULL;
-	size_t ssid_len = 0;
+	size_t len = 0;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
 	if (req->n_ssids) {
 		ssid = req->ssids[0].ssid;
-		ssid_len = req->ssids[0].ssid_len;
+		len = req->ssids[0].ssid_len;
 	}
 
 	mutex_lock(&wl->mutex);
@@ -1347,7 +1347,12 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_cmd_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+	if (wl1271_11a_enabled())
+		ret = wl1271_cmd_scan(hw->priv, ssid, len, 1, 0,
+				      WL1271_SCAN_BAND_DUAL, 3);
+	else
+		ret = wl1271_cmd_scan(hw->priv, ssid, len, 1, 0,
+				      WL1271_SCAN_BAND_2_4_GHZ, 3);
 
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 7979b69..66b83e9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -79,6 +79,9 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
 		status->band = IEEE80211_BAND_2GHZ;
+	else if ((desc->flags & WL1271_RX_DESC_BAND_MASK) ==
+		 WL1271_RX_DESC_BAND_A)
+		status->band = IEEE80211_BAND_5GHZ;
 	else
 		wl1271_warning("unsupported band 0x%x",
 			       desc->flags & WL1271_RX_DESC_BAND_MASK);
-- 
1.5.6.5

