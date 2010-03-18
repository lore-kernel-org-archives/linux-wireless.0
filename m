Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33059 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab0CRK1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/21] wl1271: get probe request template from mac80211
Date: Thu, 18 Mar 2010 12:26:35 +0200
Message-Id: <1268908006-16992-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

If we get probe request from mac80211, we can remove two functions.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  137 ++++++----------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   11 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c  |    6 +-
 4 files changed, 40 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 3a615fa..8364270 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -546,9 +546,9 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
-		    u8 active_scan, u8 high_prio, u8 band,
-		    u8 probe_requests)
+int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+		    const u8 *ie, size_t ie_len, u8 active_scan,
+		    u8 high_prio, u8 band, u8 probe_requests)
 {
 
 	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
@@ -619,12 +619,13 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 
 	params->params.num_channels = j;
 
-	if (len && ssid) {
-		params->params.ssid_len = len;
-		memcpy(params->params.ssid, ssid, len);
+	if (ssid_len && ssid) {
+		params->params.ssid_len = ssid_len;
+		memcpy(params->params.ssid, ssid, ssid_len);
 	}
 
-	ret = wl1271_cmd_build_probe_req(wl, ssid, len, ieee_band);
+	ret = wl1271_cmd_build_probe_req(wl, ssid, ssid_len,
+					 ie, ie_len, ieee_band);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -655,9 +656,9 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 			wl->scan.active = active_scan;
 			wl->scan.high_prio = high_prio;
 			wl->scan.probe_requests = probe_requests;
-			if (len && ssid) {
-				wl->scan.ssid_len = len;
-				memcpy(wl->scan.ssid, ssid, len);
+			if (ssid_len && ssid) {
+				wl->scan.ssid_len = ssid_len;
+				memcpy(wl->scan.ssid, ssid, ssid_len);
 			} else
 				wl->scan.ssid_len = 0;
 		}
@@ -714,66 +715,6 @@ out:
 	return ret;
 }
 
-static int wl1271_build_basic_rates(u8 *rates, u8 band)
-{
-	u8 index = 0;
-
-	if (band == IEEE80211_BAND_2GHZ) {
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
-	} else if (band == IEEE80211_BAND_5GHZ) {
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_6MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_12MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_24MB;
-	} else {
-		wl1271_error("build_basic_rates invalid band: %d", band);
-	}
-
-	return index;
-}
-
-static int wl1271_build_extended_rates(u8 *rates, u8 band)
-{
-	u8 index = 0;
-
-	if (band == IEEE80211_BAND_2GHZ) {
-		rates[index++] = IEEE80211_OFDM_RATE_6MB;
-		rates[index++] = IEEE80211_OFDM_RATE_9MB;
-		rates[index++] = IEEE80211_OFDM_RATE_12MB;
-		rates[index++] = IEEE80211_OFDM_RATE_18MB;
-		rates[index++] = IEEE80211_OFDM_RATE_24MB;
-		rates[index++] = IEEE80211_OFDM_RATE_36MB;
-		rates[index++] = IEEE80211_OFDM_RATE_48MB;
-		rates[index++] = IEEE80211_OFDM_RATE_54MB;
-	} else if (band == IEEE80211_BAND_5GHZ) {
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_9MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_18MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_24MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_36MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_48MB;
-		rates[index++] =
-			IEEE80211_BASIC_RATE_MASK | IEEE80211_OFDM_RATE_54MB;
-	} else {
-		wl1271_error("build_basic_rates invalid band: %d", band);
-	}
-
-	return index;
-}
-
 int wl1271_cmd_build_null_data(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
@@ -809,53 +750,31 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len,
-			       u8 band)
+int wl1271_cmd_build_probe_req(struct wl1271 *wl,
+			       const u8 *ssid, size_t ssid_len,
+			       const u8 *ie, size_t ie_len, u8 band)
 {
-	struct wl12xx_probe_req_template template;
-	struct wl12xx_ie_rates *rates;
-	char *ptr;
-	u16 size;
+	struct sk_buff *skb;
 	int ret;
 
-	ptr = (char *)&template;
-	size = sizeof(struct ieee80211_header);
-
-	memset(template.header.da, 0xff, ETH_ALEN);
-	memset(template.header.bssid, 0xff, ETH_ALEN);
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-
-	/* IEs */
-	/* SSID */
-	template.ssid.header.id = WLAN_EID_SSID;
-	template.ssid.header.len = ssid_len;
-	if (ssid_len && ssid)
-		memcpy(template.ssid.ssid, ssid, ssid_len);
-	size += sizeof(struct wl12xx_ie_header) + ssid_len;
-	ptr += size;
-
-	/* Basic Rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_SUPP_RATES;
-	rates->header.len = wl1271_build_basic_rates(rates->rates, band);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	/* Extended rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
-	rates->header.len = wl1271_build_extended_rates(rates->rates, band);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
+	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
+				     ie, ie_len);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-					      &template, size);
+					      skb->data, skb->len);
 	else
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      &template, size);
+					      skb->data, skb->len);
+
+out:
+	dev_kfree_skb(skb);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 4297205..e936d3a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -41,15 +41,16 @@ int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
-int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
-		    u8 active_scan, u8 high_prio, u8 band,
-		    u8 probe_requests);
+int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+		    const u8 *ie, size_t ie_len, u8 active_scan,
+		    u8 high_prio, u8 band, u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len,
-			       u8 band);
+int wl1271_cmd_build_probe_req(struct wl1271 *wl,
+			       const u8 *ssid, size_t ssid_len,
+			       const u8 *ie, size_t ie_len, u8 band);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 5533519..4d35af9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -44,7 +44,9 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 			 * scanning as it checks that.
 			 */
 			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
+			/* FIXME: ie missing! */
 			wl1271_cmd_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
+						NULL, 0,
 						wl->scan.active,
 						wl->scan.high_prio,
 						WL1271_SCAN_BAND_5_GHZ,
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d21bfe2..fbc42ce 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1566,10 +1566,12 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	if (wl1271_11a_enabled())
-		ret = wl1271_cmd_scan(hw->priv, ssid, len, 1, 0,
+		ret = wl1271_cmd_scan(hw->priv, ssid, len,
+				      req->ie, req->ie_len, 1, 0,
 				      WL1271_SCAN_BAND_DUAL, 3);
 	else
-		ret = wl1271_cmd_scan(hw->priv, ssid, len, 1, 0,
+		ret = wl1271_cmd_scan(hw->priv, ssid, len,
+				      req->ie, req->ie_len, 1, 0,
 				      WL1271_SCAN_BAND_2_4_GHZ, 3);
 
 	wl1271_ps_elp_sleep(wl);
-- 
1.6.3.3

