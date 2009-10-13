Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36144 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbZJMJt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:57 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/22] wl1271: Implement beacon early termination support
Date: Tue, 13 Oct 2009 12:47:46 +0300
Message-Id: <1255427279-1224-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add support to enable beacon early termination in the firmware. Early
Beacon termination is a feature which allows the radio to be turned off
after TIM IE to save power.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   30 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   12 ++++++++++-
 drivers/net/wireless/wl12xx/wl1271_conf.h |   23 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++-
 drivers/net/wireless/wl12xx/wl1271_ps.c   |   10 +++++++++
 5 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 880c828..44a1237 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1062,3 +1062,33 @@ out:
 	return ret;
 
 }
+
+int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable)
+{
+	struct wl1271_acx_bet_enable *acx = NULL;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx bet enable");
+
+	if (enable && wl->conf.conn.bet_enable == CONF_BET_MODE_DISABLE)
+		goto out;
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = enable ? CONF_BET_MODE_ENABLE : CONF_BET_MODE_DISABLE;
+	acx->max_consecutive = wl->conf.conn.bet_max_consecutive;
+
+	ret = wl1271_cmd_configure(wl, ACX_BET_ENABLE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx bet enable failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 73ef2bd..29fd363 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -946,6 +946,15 @@ struct wl1271_acx_rx_config_opt {
 	u8 reserved;
 } __attribute__ ((packed));
 
+
+struct wl1271_acx_bet_enable {
+	struct acx_header header;
+
+	u8 enable;
+	u8 max_consecutive;
+	u8 padding[2];
+} __attribute__ ((packed));
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1043,7 +1052,7 @@ int wl1271_acx_aid(struct wl1271 *wl, u16 aid);
 int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask);
 int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
-			    enum acx_ctsprotect_type ctsprotect);
+			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
 int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates);
 int wl1271_acx_ac_cfg(struct wl1271 *wl);
@@ -1054,5 +1063,6 @@ int wl1271_acx_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
+int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 5333a27..00ffa66 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -603,6 +603,11 @@ enum conf_bcn_filt_mode {
 	CONF_BCN_FILT_MODE_ENABLED = 1
 };
 
+enum conf_bet_mode {
+	CONF_BET_MODE_DISABLE = 0,
+	CONF_BET_MODE_ENABLE = 1,
+};
+
 struct conf_conn_settings {
 	/*
 	 * Firmware wakeup conditions configuration. The host may set only
@@ -689,6 +694,24 @@ struct conf_conn_settings {
 	 * Configuration of signal average weights.
 	 */
 	struct conf_sig_weights sig_weights;
+
+	/*
+	 * Specifies if beacon early termination procedure is enabled or
+	 * disabled.
+	 *
+	 * Range: CONF_BET_MODE_*
+	 */
+	u8 bet_enable;
+
+	/*
+	 * Specifies the maximum number of consecutive beacons that may be
+	 * early terminated. After this number is reached at least one full
+	 * beacon must be correctly received in FW before beacon ET
+	 * resumes.
+	 *
+	 * Range 0 - 255
+	 */
+	u8 bet_max_consecutive;
 };
 
 #define CONF_SR_ERR_TBL_MAX_VALUES   14
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7f1093c..3d2e999 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -219,7 +219,9 @@ static struct conf_drv_settings default_conf = {
 			.rssi_pkt_avg_weight = 10,
 			.snr_bcn_avg_weight  = 10,
 			.snr_pkt_avg_weight  = 10
-		}
+		},
+		.bet_enable                  = CONF_BET_MODE_ENABLE,
+		.bet_max_consecutive         = 100
 	},
 	.init = {
 		.sr_err_tbl = {
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index bb8745d..507cd91 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -130,6 +130,11 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
+		/* enable beacon early termination */
+		ret = wl1271_acx_bet_enable(wl, true);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
@@ -147,6 +152,11 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
+		/* disable beacon early termination */
+		ret = wl1271_acx_bet_enable(wl, false);
+		if (ret < 0)
+			return ret;
+
 		/* disable beacon filtering */
 		ret = wl1271_acx_beacon_filter_opt(wl, false);
 		if (ret < 0)
-- 
1.5.6.5

