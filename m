Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1HNKRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:42 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 20/40] wl12xx: update BT coex configuration params
Date: Sun, 14 Aug 2011 13:17:19 +0300
Message-Id: <1313317059-16567-21-git-send-email-eliad@wizery.com> (sfid-20110814_121747_451436_4788D6C6)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BT coex params api have been changed.
Update it, and init coex for both sta and ap.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: fix comments, don't disable fm coex

 drivers/net/wireless/wl12xx/acx.c  |   40 +----
 drivers/net/wireless/wl12xx/acx.h  |   16 +--
 drivers/net/wireless/wl12xx/conf.h |  318 ++++++++++++------------------------
 drivers/net/wireless/wl12xx/init.c |    5 +-
 drivers/net/wireless/wl12xx/main.c |  165 +++++++------------
 5 files changed, 177 insertions(+), 367 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index a784ba6..d783fce 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -525,59 +525,29 @@ int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable)
 
 out:
 	kfree(pta);
 	return ret;
 }
 
-int wl1271_acx_sta_sg_cfg(struct wl1271 *wl)
+int wl12xx_acx_sg_cfg(struct wl1271 *wl)
 {
-	struct acx_sta_bt_wlan_coex_param *param;
+	struct acx_bt_wlan_coex_param *param;
 	struct conf_sg_settings *c = &wl->conf.sg;
 	int i, ret;
 
-	wl1271_debug(DEBUG_ACX, "acx sg sta cfg");
+	wl1271_debug(DEBUG_ACX, "acx sg cfg");
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	/* BT-WLAN coext parameters */
-	for (i = 0; i < CONF_SG_STA_PARAMS_MAX; i++)
-		param->params[i] = cpu_to_le32(c->sta_params[i]);
-	param->param_idx = CONF_SG_PARAMS_ALL;
-
-	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
-	if (ret < 0) {
-		wl1271_warning("failed to set sg config: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(param);
-	return ret;
-}
-
-int wl1271_acx_ap_sg_cfg(struct wl1271 *wl)
-{
-	struct acx_ap_bt_wlan_coex_param *param;
-	struct conf_sg_settings *c = &wl->conf.sg;
-	int i, ret;
-
-	wl1271_debug(DEBUG_ACX, "acx sg ap cfg");
-
-	param = kzalloc(sizeof(*param), GFP_KERNEL);
-	if (!param) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* BT-WLAN coext parameters */
-	for (i = 0; i < CONF_SG_AP_PARAMS_MAX; i++)
-		param->params[i] = cpu_to_le32(c->ap_params[i]);
+	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
+		param->params[i] = cpu_to_le32(c->params[i]);
 	param->param_idx = CONF_SG_PARAMS_ALL;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
 		wl1271_warning("failed to set sg config: %d", ret);
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 6909bc5..5b3fabd 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -299,29 +299,20 @@ struct acx_bt_wlan_coex {
 	struct acx_header header;
 
 	u8 enable;
 	u8 pad[3];
 } __packed;
 
-struct acx_sta_bt_wlan_coex_param {
+struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	__le32 params[CONF_SG_STA_PARAMS_MAX];
+	__le32 params[CONF_SG_PARAMS_MAX];
 	u8 param_idx;
 	u8 padding[3];
 } __packed;
 
-struct acx_ap_bt_wlan_coex_param {
-	struct acx_header header;
-
-	__le32 params[CONF_SG_AP_PARAMS_MAX];
-	u8 param_idx;
-	u8 padding[3];
-} __packed;
-
-
 struct acx_dco_itrim_params {
 	struct acx_header header;
 
 	u8 enable;
 	u8 padding[3];
 	__le32 timeout;
@@ -1266,14 +1257,13 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold);
 int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
 int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable);
 int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_sta_sg_cfg(struct wl1271 *wl);
-int wl1271_acx_ap_sg_cfg(struct wl1271 *wl);
+int wl12xx_acx_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
 int wl1271_acx_bcn_dtim_options(struct wl1271 *wl);
 int wl1271_acx_aid(struct wl1271 *wl, u16 aid);
 int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask);
 int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 30ee7d3..a7c1478 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -96,46 +96,81 @@ enum {
 	CONF_SG_PROTECTIVE,
 	CONF_SG_OPPORTUNISTIC
 };
 
 enum {
 	/*
-	 * PER threshold in PPM of the BT voice
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN / BT master basic rate
 	 *
-	 * Range: 0 - 10000000
+	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_BT_PER_THRESHOLD = 0,
+	CONF_SG_ACL_BT_MASTER_MIN_BR = 0,
+	CONF_SG_ACL_BT_MASTER_MAX_BR,
 
 	/*
-	 * Number of consequent RX_ACTIVE activities to override BT voice
-	 * frames to ensure WLAN connection
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN / BT slave basic rate
 	 *
-	 * Range: 0 - 100
+	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_HV3_MAX_OVERRIDE,
+	CONF_SG_ACL_BT_SLAVE_MIN_BR,
+	CONF_SG_ACL_BT_SLAVE_MAX_BR,
 
 	/*
-	 * Defines the PER threshold of the BT voice
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN / BT master EDR
 	 *
-	 * Range: 0 - 65000
+	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_BT_NFS_SAMPLE_INTERVAL,
+	CONF_SG_ACL_BT_MASTER_MIN_EDR,
+	CONF_SG_ACL_BT_MASTER_MAX_EDR,
 
 	/*
-	 * Defines the load ratio of BT
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN / BT slave EDR
 	 *
-	 * Range: 0 - 100 (%)
+	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_BT_LOAD_RATIO,
+	CONF_SG_ACL_BT_SLAVE_MIN_EDR,
+	CONF_SG_ACL_BT_SLAVE_MAX_EDR,
 
 	/*
-	 * Defines whether the SG will force WLAN host to enter/exit PSM
+	 * The maximum time WLAN can gain the antenna
+	 * in WLAN PSM / BT master/slave BR
 	 *
-	 * Range: 1 - SG can force, 0 - host handles PSM
+	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_AUTO_PS_MODE,
+	CONF_SG_ACL_WLAN_PS_MASTER_BR,
+	CONF_SG_ACL_WLAN_PS_SLAVE_BR,
+
+	/*
+	 * The maximum time WLAN can gain the antenna
+	 * in WLAN PSM / BT master/slave EDR
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_ACL_WLAN_PS_MASTER_EDR,
+	CONF_SG_ACL_WLAN_PS_SLAVE_EDR,
+
+	/* TODO: explain these values */
+	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR,
+	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR,
+	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR,
+	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR,
+	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR,
+	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR,
+	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR,
+	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR,
+
+	CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR,
+	CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR,
+	CONF_SG_ACL_PASSIVE_SCAN_BT_BR,
+	CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR,
+	CONF_SG_ACL_PASSIVE_SCAN_BT_EDR,
+	CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR,
 
 	/*
 	 * Compensation percentage of probe requests when scan initiated
 	 * during BT voice/ACL link.
 	 *
 	 * Range: 0 - 255 (%)
@@ -148,108 +183,76 @@ enum {
 	 *
 	 * Range: 0 - 255 (%)
 	 */
 	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
 
 	/*
-	 * Defines antenna configuration (single/dual antenna)
-	 *
-	 * Range: 0 - single antenna, 1 - dual antenna
-	 */
-	CONF_SG_ANTENNA_CONFIGURATION,
-
-	/*
-	 * The threshold (percent) of max consequtive beacon misses before
-	 * increasing priority of beacon reception.
-	 *
-	 * Range: 0 - 100 (%)
-	 */
-	CONF_SG_BEACON_MISS_PERCENT,
-
-	/*
-	 * The rate threshold below which receiving a data frame from the AP
-	 * will increase the priority of the data frame above BT traffic.
-	 *
-	 * Range: 0,2, 5(=5.5), 6, 9, 11, 12, 18, 24, 36, 48, 54
-	 */
-	CONF_SG_RATE_ADAPT_THRESH,
-
-	/*
-	 * Not used currently.
+	 * Compensation percentage of WLAN active scan window if initiated
+	 * during BT A2DP
 	 *
-	 * Range: 0
+	 * Range: 0 - 1000 (%)
 	 */
-	CONF_SG_RATE_ADAPT_SNR,
+	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN PSM / BT master basic rate
+	 * Compensation percentage of WLAN passive scan window if initiated
+	 * during BT A2DP BR
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 1000 (%)
 	 */
-	CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR,
-	CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR,
+	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR,
 
 	/*
-	 * The time after it expires no new WLAN trigger frame is trasmitted
-	 * in WLAN PSM / BT master basic rate
+	 * Compensation percentage of WLAN passive scan window if initiated
+	 * during BT A2DP EDR
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 1000 (%)
 	 */
-	CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR,
+	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN PSM / BT slave basic rate
+	 * Compensation percentage of WLAN passive scan window if initiated
+	 * during BT voice
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 1000 (%)
 	 */
-	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR,
-	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR,
+	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
 
-	/*
-	 * The time after it expires no new WLAN trigger frame is trasmitted
-	 * in WLAN PSM / BT slave basic rate
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR,
+	/* TODO: explain these values */
+	CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN,
+	CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN,
+	CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN PSM / BT master EDR
+	 * Defines whether the SG will force WLAN host to enter/exit PSM
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 1 - SG can force, 0 - host handles PSM
 	 */
-	CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR,
-	CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR,
+	CONF_SG_STA_FORCE_PS_IN_BT_SCO,
 
 	/*
-	 * The time after it expires no new WLAN trigger frame is trasmitted
-	 * in WLAN PSM / BT master EDR
+	 * Defines antenna configuration (single/dual antenna)
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - single antenna, 1 - dual antenna
 	 */
-	CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR,
+	CONF_SG_ANTENNA_CONFIGURATION,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN PSM / BT slave EDR
+	 * The threshold (percent) of max consecutive beacon misses before
+	 * increasing priority of beacon reception.
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 100 (%)
 	 */
-	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR,
-	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR,
+	CONF_SG_BEACON_MISS_PERCENT,
 
 	/*
-	 * The time after it expires no new WLAN trigger frame is trasmitted
-	 * in WLAN PSM / BT slave EDR
+	 * Protection time of the DHCP procedure.
 	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 100000 (ms)
 	 */
-	CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR,
+	CONF_SG_DHCP_TIME,
 
 	/*
 	 * RX guard time before the beginning of a new BT voice frame during
 	 * which no new WLAN trigger frame is transmitted.
 	 *
 	 * Range: 0 - 100000 (us)
@@ -270,172 +273,65 @@ enum {
 	 * will be utilized.
 	 *
 	 * Range: 0 - disable, 1 - enable
 	 */
 	CONF_SG_ADAPTIVE_RXT_TXT,
 
-	/*
-	 * The used WLAN legacy service period during active BT ACL link
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_PS_POLL_TIMEOUT,
-
-	/*
-	 * The used WLAN UPSD service period during active BT ACL link
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_UPSD_TIMEOUT,
-
-	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN Active / BT master EDR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR,
-	CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR,
-
-	/*
-	 * The maximum time WLAN can gain the antenna for
-	 * in WLAN Active / BT master EDR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR,
+	/* TODO: explain this value */
+	CONF_SG_GENERAL_USAGE_BIT_MAP,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN Active / BT slave EDR
+	 * Number of consecutive BT voice frames not interrupted by WLAN
 	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR,
-	CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR,
-
-	/*
-	 * The maximum time WLAN can gain the antenna for
-	 * in WLAN Active / BT slave EDR
-	 *
-	 * Range: 0 - 255 (ms)
+	 * Range: 0 - 100
 	 */
-	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR,
+	CONF_SG_HV3_MAX_SERVED,
 
 	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN Active / BT basic rate
+	 * The used WLAN legacy service period during active BT ACL link
 	 *
 	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR,
-	CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR,
+	CONF_SG_PS_POLL_TIMEOUT,
 
 	/*
-	 * The maximum time WLAN can gain the antenna for
-	 * in WLAN Active / BT basic rate
+	 * The used WLAN UPSD service period during active BT ACL link
 	 *
 	 * Range: 0 - 255 (ms)
 	 */
-	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR,
-
-	/*
-	 * Compensation percentage of WLAN passive scan window if initiated
-	 * during BT voice
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
-
-	/*
-	 * Compensation percentage of WLAN passive scan window if initiated
-	 * during BT A2DP
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP,
+	CONF_SG_UPSD_TIMEOUT,
 
-	/*
-	 * Fixed time ensured for BT traffic to gain the antenna during WLAN
-	 * passive scan.
-	 *
-	 * Range: 0 - 1000 ms
-	 */
-	CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME,
+	CONF_SG_CONSECUTIVE_CTS_THRESHOLD,
+	CONF_SG_STA_RX_WINDOW_AFTER_DTIM,
+	CONF_SG_STA_CONNECTION_PROTECTION_TIME,
 
-	/*
-	 * Fixed time ensured for WLAN traffic to gain the antenna during WLAN
-	 * passive scan.
-	 *
-	 * Range: 0 - 1000 ms
-	 */
-	CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME,
+	/* AP params */
+	CONF_AP_BEACON_MISS_TX,
+	CONF_AP_RX_WINDOW_AFTER_BEACON,
+	CONF_AP_BEACON_WINDOW_INTERVAL,
+	CONF_AP_CONNECTION_PROTECTION_TIME,
+	CONF_AP_BT_ACL_VAL_BT_SERVE_TIME,
+	CONF_AP_BT_ACL_VAL_WL_SERVE_TIME,
 
-	/*
-	 * Number of consequent BT voice frames not interrupted by WLAN
-	 *
-	 * Range: 0 - 100
-	 */
-	CONF_SG_HV3_MAX_SERVED,
-
-	/*
-	 * Protection time of the DHCP procedure.
-	 *
-	 * Range: 0 - 100000 (ms)
-	 */
-	CONF_SG_DHCP_TIME,
-
-	/*
-	 * Compensation percentage of WLAN active scan window if initiated
-	 * during BT A2DP
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
 	CONF_SG_TEMP_PARAM_1,
 	CONF_SG_TEMP_PARAM_2,
 	CONF_SG_TEMP_PARAM_3,
 	CONF_SG_TEMP_PARAM_4,
 	CONF_SG_TEMP_PARAM_5,
-
-	/*
-	 * AP beacon miss
-	 *
-	 * Range: 0 - 255
-	 */
-	CONF_SG_AP_BEACON_MISS_TX,
-
-	/*
-	 * AP RX window length
-	 *
-	 * Range: 0 - 50
-	 */
-	CONF_SG_RX_WINDOW_LENGTH,
-
-	/*
-	 * AP connection protection time
-	 *
-	 * Range: 0 - 5000
-	 */
-	CONF_SG_AP_CONNECTION_PROTECTION_TIME,
-
 	CONF_SG_TEMP_PARAM_6,
 	CONF_SG_TEMP_PARAM_7,
 	CONF_SG_TEMP_PARAM_8,
 	CONF_SG_TEMP_PARAM_9,
 	CONF_SG_TEMP_PARAM_10,
 
-	CONF_SG_STA_PARAMS_MAX = CONF_SG_TEMP_PARAM_5 + 1,
-	CONF_SG_AP_PARAMS_MAX = CONF_SG_TEMP_PARAM_10 + 1,
-
+	CONF_SG_PARAMS_MAX,
 	CONF_SG_PARAMS_ALL = 0xff
 };
 
 struct conf_sg_settings {
-	u32 sta_params[CONF_SG_STA_PARAMS_MAX];
-	u32 ap_params[CONF_SG_AP_PARAMS_MAX];
+	u32 params[CONF_SG_PARAMS_MAX];
 	u8 state;
 };
 
 enum conf_rx_queue_type {
 	CONF_RX_QUEUE_TYPE_LOW_PRIORITY,  /* All except the high priority */
 	CONF_RX_QUEUE_TYPE_HIGH_PRIORITY, /* Management and voice packets */
@@ -910,13 +806,13 @@ struct conf_conn_settings {
 	 * Configure Beacon filter pass-thru rules.
 	 */
 	u8 bcn_filt_ie_count;
 	struct conf_bcn_filt_rule bcn_filt_ie[CONF_MAX_BCN_FILT_IE_COUNT];
 
 	/*
-	 * The number of consequtive beacons to lose, before the firmware
+	 * The number of consecutive beacons to lose, before the firmware
 	 * becomes out of synch.
 	 *
 	 * Range: u32
 	 */
 	u32 synch_fail_thold;
 
@@ -948,13 +844,13 @@ struct conf_conn_settings {
 	 *
 	 * Range: 1 - enable, 0 - disable
 	 */
 	u8 rx_broadcast_in_ps;
 
 	/*
-	 * Consequtive PS Poll failures before sending event to driver
+	 * Consecutive PS Poll failures before sending event to driver
 	 *
 	 * Range: u8
 	 */
 	u8 ps_poll_threshold;
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 1bc246f..47d87aa 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -274,16 +274,13 @@ static int wl1271_init_beacon_filter(struct wl1271 *wl)
 }
 
 int wl1271_init_pta(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		ret = wl1271_acx_ap_sg_cfg(wl);
-	else
-		ret = wl1271_acx_sta_sg_cfg(wl);
+	ret = wl12xx_acx_sg_cfg(wl);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_acx_sg_enable(wl, wl->sg_enabled);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 57b10e9..1774a66 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -49,116 +49,73 @@
 #include "scan.h"
 
 #define WL1271_BOOT_RETRIES 3
 
 static struct conf_drv_settings default_conf = {
 	.sg = {
-		.sta_params = {
-			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
-			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
-			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
-			[CONF_SG_BT_LOAD_RATIO]                     = 200,
-			[CONF_SG_AUTO_PS_MODE]                      = 1,
-			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
-			[CONF_SG_ANTENNA_CONFIGURATION]             = 0,
-			[CONF_SG_BEACON_MISS_PERCENT]               = 60,
-			[CONF_SG_RATE_ADAPT_THRESH]                 = 12,
-			[CONF_SG_RATE_ADAPT_SNR]                    = 0,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR]      = 10,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR]      = 30,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR]      = 8,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR]       = 20,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR]       = 50,
-			/* Note: with UPSD, this should be 4 */
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR]       = 8,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR]     = 7,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR]     = 25,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR]     = 20,
-			/* Note: with UPDS, this should be 15 */
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR]      = 8,
-			/* Note: with UPDS, this should be 50 */
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR]      = 40,
-			/* Note: with UPDS, this should be 10 */
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR]      = 20,
-			[CONF_SG_RXT]                               = 1200,
-			[CONF_SG_TXT]                               = 1000,
-			[CONF_SG_ADAPTIVE_RXT_TXT]                  = 1,
-			[CONF_SG_PS_POLL_TIMEOUT]                   = 10,
-			[CONF_SG_UPSD_TIMEOUT]                      = 10,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR] = 7,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR] = 15,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR] = 15,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR]  = 8,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR]  = 20,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR]  = 15,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR]         = 20,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR]         = 50,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR]         = 10,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3]  = 200,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP] = 800,
-			[CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME]         = 75,
-			[CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME]       = 15,
-			[CONF_SG_HV3_MAX_SERVED]                    = 6,
-			[CONF_SG_DHCP_TIME]                         = 5000,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP]  = 100,
-		},
-		.ap_params = {
-			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
-			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
-			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
-			[CONF_SG_BT_LOAD_RATIO]                     = 50,
-			[CONF_SG_AUTO_PS_MODE]                      = 1,
-			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
-			[CONF_SG_ANTENNA_CONFIGURATION]             = 0,
-			[CONF_SG_BEACON_MISS_PERCENT]               = 60,
-			[CONF_SG_RATE_ADAPT_THRESH]                 = 64,
-			[CONF_SG_RATE_ADAPT_SNR]                    = 1,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR]      = 10,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR]      = 25,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR]      = 25,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR]       = 20,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR]       = 25,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR]       = 25,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR]     = 7,
-			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR]     = 25,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR]     = 25,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR]      = 8,
-			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR]      = 25,
-			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR]      = 25,
-			[CONF_SG_RXT]                               = 1200,
-			[CONF_SG_TXT]                               = 1000,
-			[CONF_SG_ADAPTIVE_RXT_TXT]                  = 1,
-			[CONF_SG_PS_POLL_TIMEOUT]                   = 10,
-			[CONF_SG_UPSD_TIMEOUT]                      = 10,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR] = 7,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR] = 15,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR] = 15,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR]  = 8,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR]  = 20,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR]  = 15,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR]         = 20,
-			[CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR]         = 50,
-			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR]         = 10,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3]  = 200,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP] = 800,
-			[CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME]         = 75,
-			[CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME]       = 15,
-			[CONF_SG_HV3_MAX_SERVED]                    = 6,
-			[CONF_SG_DHCP_TIME]                         = 5000,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP]  = 100,
-			[CONF_SG_TEMP_PARAM_1]                      = 0,
-			[CONF_SG_TEMP_PARAM_2]                      = 0,
-			[CONF_SG_TEMP_PARAM_3]                      = 0,
-			[CONF_SG_TEMP_PARAM_4]                      = 0,
-			[CONF_SG_TEMP_PARAM_5]                      = 0,
-			[CONF_SG_AP_BEACON_MISS_TX]                 = 3,
-			[CONF_SG_RX_WINDOW_LENGTH]                  = 6,
-			[CONF_SG_AP_CONNECTION_PROTECTION_TIME]     = 50,
-			[CONF_SG_TEMP_PARAM_6]                      = 1,
+		.params = {
+			[CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
+			[CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
+			[CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
+			[CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
+			[CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
+			[CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
+			[CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
+			[CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
+			[CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
+			[CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
+			[CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
+			[CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
+			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
+			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
+			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
+			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
+			[CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
+			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
+			[CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
+			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
+			/* active scan params */
+			[CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
+			/* passive scan params */
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR] = 800,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR] = 200,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
+			/* passive scan in dual antenna params */
+			[CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
+			[CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN] = 0,
+			[CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN] = 0,
+			/* general params */
+			[CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
+			[CONF_SG_ANTENNA_CONFIGURATION] = 0,
+			[CONF_SG_BEACON_MISS_PERCENT] = 60,
+			[CONF_SG_DHCP_TIME] = 5000,
+			[CONF_SG_RXT] = 1200,
+			[CONF_SG_TXT] = 1000,
+			[CONF_SG_ADAPTIVE_RXT_TXT] = 1,
+			[CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
+			[CONF_SG_HV3_MAX_SERVED] = 6,
+			[CONF_SG_PS_POLL_TIMEOUT] = 10,
+			[CONF_SG_UPSD_TIMEOUT] = 10,
+			[CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
+			[CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
+			[CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
+			/* AP params */
+			[CONF_AP_BEACON_MISS_TX] = 3,
+			[CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
+			[CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
+			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
+			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
+			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
 		},
 		.state = CONF_SG_PROTECTIVE,
 	},
 	.rx = {
 		.rx_msdu_life_time           = 512000,
 		.packet_detection_threshold  = 0,
-- 
1.7.6.401.g6a319

