Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40394 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0GHOur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:47 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 02/13] wl1271: Add TSF handling
Date: Thu,  8 Jul 2010 17:49:57 +0300
Message-Id: <1278600608-22411-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add functionality to pass the current TSF (mac time) to the mac80211. This is
needed for ad-hoc merging.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   12 ++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    6 ------
 4 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index e19e2f8..5cadb9d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1266,3 +1266,29 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
+{
+	struct wl1271_acx_fw_tsf_information *tsf_info;
+	int ret;
+
+	tsf_info = kzalloc(sizeof(*tsf_info), GFP_KERNEL);
+	if (!tsf_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_interrogate(wl, ACX_TSF_INFO,
+				     tsf_info, sizeof(*tsf_info));
+	if (ret < 0) {
+		wl1271_warning("acx tsf info interrogate failed");
+		goto out;
+	}
+
+	*mactime = le32_to_cpu(tsf_info->current_tsf_low) |
+		((u64) le32_to_cpu(tsf_info->current_tsf_high) << 32);
+
+out:
+	kfree(tsf_info);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 420e7e2..914b29b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -993,6 +993,17 @@ struct wl1271_acx_rssi_snr_avg_weights {
 	u8 snr_data;
 };
 
+struct wl1271_acx_fw_tsf_information {
+	struct acx_header header;
+
+	__le32 current_tsf_high;
+	__le32 current_tsf_low;
+	__le32 last_bttt_high;
+	__le32 last_tbtt_low;
+	u8 last_dtim_count;
+	u8 padding[3];
+} __attribute__ ((packed));
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1114,5 +1125,6 @@ int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
 int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 				s16 thold, u8 hyst);
 int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
+int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7a14da5..5970fde 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1966,6 +1966,32 @@ out:
 	return ret;
 }
 
+static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw)
+{
+
+	struct wl1271 *wl = hw->priv;
+	u64 mactime = ULLONG_MAX;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 get tsf");
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_tsf_info(wl, &mactime);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return mactime;
+}
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
@@ -2195,6 +2221,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.bss_info_changed = wl1271_op_bss_info_changed,
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
 	.conf_tx = wl1271_op_conf_tx,
+	.get_tsf = wl1271_op_get_tsf,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index b98fb64..e98f22b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -53,12 +53,6 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	status->band = wl->band;
 	status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
 
-	/*
-	 * FIXME: Add mactime handling.  For IBSS (ad-hoc) we need to get the
-	 * timestamp from the beacon (acx_tsf_info).  In BSS mode (infra) we
-	 * only need the mactime for monitor mode.  For now the mactime is
-	 * not valid, so RX_FLAG_TSFT should not be set
-	 */
 	status->signal = desc->rssi;
 
 	status->freq = ieee80211_channel_to_frequency(desc->channel);
-- 
1.6.3.3

