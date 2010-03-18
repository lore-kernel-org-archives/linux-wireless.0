Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23797 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:23 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 04/21] wl1271: Fix SG configuration message structures
Date: Thu, 18 Mar 2010 12:26:29 +0200
Message-Id: <1268908006-16992-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The bluetooth coexistence (SG) configuration messages have changed and
were completely wrong. For instance, intending to enable the SG, it was
instead disabled.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |   17 +----
 drivers/net/wireless/wl12xx/wl1271_acx.h |  120 ++++++++++++++++--------------
 2 files changed, 66 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 60e2087..405ae1b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -547,7 +547,7 @@ int wl1271_acx_sg_enable(struct wl1271 *wl)
 		goto out;
 	}
 
-	pta->enable = SG_ENABLE;
+	pta->enable = ACX_SG_DISABLE;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
@@ -575,19 +575,8 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	param->per_threshold = cpu_to_le32(c->per_threshold);
-	param->max_scan_compensation_time =
-		cpu_to_le32(c->max_scan_compensation_time);
-	param->nfs_sample_interval = cpu_to_le16(c->nfs_sample_interval);
-	param->load_ratio = c->load_ratio;
-	param->auto_ps_mode = c->auto_ps_mode;
-	param->probe_req_compensation = c->probe_req_compensation;
-	param->scan_window_compensation = c->scan_window_compensation;
-	param->antenna_config = c->antenna_config;
-	param->beacon_miss_threshold = c->beacon_miss_threshold;
-	param->rate_adaptation_threshold =
-		cpu_to_le32(c->rate_adaptation_threshold);
-	param->rate_adaptation_snr = c->rate_adaptation_snr;
+	param->params[ACX_SG_BT_PER_THRESHOLD] = c->per_threshold;
+	param->param_idx = ACX_SG_BT_PER_THRESHOLD;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index aeccc98..88a05cb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -393,80 +393,86 @@ struct acx_conn_monit_params {
 } __attribute__ ((packed));
 
 enum {
-	SG_ENABLE = 0,
-	SG_DISABLE,
-	SG_SENSE_NO_ACTIVITY,
-	SG_SENSE_ACTIVE
+	ACX_SG_DISABLE = 0,
+	ACX_SG_PROTECTIVE,
+	ACX_SG_OPPORTUNISTIC
 };
 
 struct acx_bt_wlan_coex {
 	struct acx_header header;
 
-	/*
-	 * 0 -> PTA enabled
-	 * 1 -> PTA disabled
-	 * 2 -> sense no active mode, i.e.
-	 *      an interrupt is sent upon
-	 *      BT activity.
-	 * 3 -> PTA is switched on in response
-	 *      to the interrupt sending.
-	 */
 	u8 enable;
 	u8 pad[3];
 } __attribute__ ((packed));
 
-struct acx_dco_itrim_params {
+enum {
+	ACX_SG_BT_PER_THRESHOLD = 0,
+	ACX_SG_HV3_MAX_OVERRIDE,
+	ACX_SG_BT_NFS_SAMPLE_INTERVAL,
+	ACX_SG_BT_LOAD_RATIO,
+	ACX_SG_AUTO_PS_MODE,
+	ACX_SG_AUTO_SCAN_PROBE_REQ,
+	ACX_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
+	ACX_SG_ANTENNA_CONFIGURATION,
+	ACX_SG_BEACON_MISS_PERCENT,
+	ACX_SG_RATE_ADAPT_THRESH,
+	ACX_SG_RATE_ADAPT_SNR,
+	ACX_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR,
+	ACX_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR,
+	ACX_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR,
+	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR,
+	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR,
+	ACX_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR,
+	ACX_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR,
+	ACX_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR,
+	ACX_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR,
+	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR,
+	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR,
+	ACX_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR,
+	ACX_SG_RXT,
+	ACX_SG_TXT,
+	ACX_SG_ADAPTIVE_RXT_TXT,
+	ACX_SG_PS_POLL_TIMEOUT,
+	ACX_SG_UPSD_TIMEOUT,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR,
+	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR,
+	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_MIN_BR,
+	ACX_SG_WLAN_ACTIVE_BT_ACL_MAX_BR,
+	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_BR,
+	ACX_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
+	ACX_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP,
+	ACX_SG_PASSIVE_SCAN_A2DP_BT_TIME,
+	ACX_SG_PASSIVE_SCAN_A2DP_WLAN_TIME,
+	ACX_SG_HV3_MAX_SERVED,
+	ACX_SG_DHCP_TIME,
+	ACX_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
+	ACX_SG_TEMP_PARAM_1,
+	ACX_SG_TEMP_PARAM_2,
+	ACX_SG_TEMP_PARAM_3,
+	ACX_SG_TEMP_PARAM_4,
+	ACX_SG_TEMP_PARAM_5,
+	ACX_SG_PARAMS_MAX,
+	ACX_SG_PARAMS_ALL = 0xff
+};
+
+struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	u8 enable;
+	__le32 params[ACX_SG_PARAMS_MAX];
+	u8 param_idx;
 	u8 padding[3];
-	__le32 timeout;
 } __attribute__ ((packed));
 
-#define PTA_ANTENNA_TYPE_DEF		  (0)
-#define PTA_BT_HP_MAXTIME_DEF		  (2000)
-#define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
-#define PTA_SENSE_DISABLE_TIMER_DEF	  (1350)
-#define PTA_PROTECTIVE_RX_TIME_DEF	  (1500)
-#define PTA_PROTECTIVE_TX_TIME_DEF	  (1500)
-#define PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF (3000)
-#define PTA_SIGNALING_TYPE_DEF		  (1)
-#define PTA_AFH_LEVERAGE_ON_DEF		  (0)
-#define PTA_NUMBER_QUIET_CYCLE_DEF	  (0)
-#define PTA_MAX_NUM_CTS_DEF		  (3)
-#define PTA_NUMBER_OF_WLAN_PACKETS_DEF	  (2)
-#define PTA_NUMBER_OF_BT_PACKETS_DEF	  (2)
-#define PTA_PROTECTIVE_RX_TIME_FAST_DEF	  (1500)
-#define PTA_PROTECTIVE_TX_TIME_FAST_DEF	  (3000)
-#define PTA_CYCLE_TIME_FAST_DEF		  (8700)
-#define PTA_RX_FOR_AVALANCHE_DEF	  (5)
-#define PTA_ELP_HP_DEF			  (0)
-#define PTA_ANTI_STARVE_PERIOD_DEF	  (500)
-#define PTA_ANTI_STARVE_NUM_CYCLE_DEF	  (4)
-#define PTA_ALLOW_PA_SD_DEF		  (1)
-#define PTA_TIME_BEFORE_BEACON_DEF	  (6300)
-#define PTA_HPDM_MAX_TIME_DEF		  (1600)
-#define PTA_TIME_OUT_NEXT_WLAN_DEF	  (2550)
-#define PTA_AUTO_MODE_NO_CTS_DEF	  (0)
-#define PTA_BT_HP_RESPECTED_DEF		  (3)
-#define PTA_WLAN_RX_MIN_RATE_DEF	  (24)
-#define PTA_ACK_MODE_DEF		  (1)
-
-struct acx_bt_wlan_coex_param {
+struct acx_dco_itrim_params {
 	struct acx_header header;
 
-	__le32 per_threshold;
-	__le32 max_scan_compensation_time;
-	__le16 nfs_sample_interval;
-	u8 load_ratio;
-	u8 auto_ps_mode;
-	u8 probe_req_compensation;
-	u8 scan_window_compensation;
-	u8 antenna_config;
-	u8 beacon_miss_threshold;
-	__le32 rate_adaptation_threshold;
-	s8 rate_adaptation_snr;
+	u8 enable;
 	u8 padding[3];
+	__le32 timeout;
 } __attribute__ ((packed));
 
 struct acx_energy_detection {
-- 
1.6.3.3

