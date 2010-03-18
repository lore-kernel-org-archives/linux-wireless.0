Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62588 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0CRK1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:54 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 05/21] wl1271: Add proper WLAN-BT co-ex configuration, and enable co-ex.
Date: Thu, 18 Mar 2010 12:26:30 +0200
Message-Id: <1268908006-16992-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add configuration values for the varous WLAN-BT co-ex configuration parameters,
and finally enable WLAN-BT co-ex. Based on preliminary measurements, it
appears the co-ex feature is not increasing WLAN power consumption, if BT
is not activated.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    9 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   62 +------
 drivers/net/wireless/wl12xx/wl1271_conf.h |  330 +++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   62 +++++-
 5 files changed, 328 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 405ae1b..e7c22d3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -547,7 +547,7 @@ int wl1271_acx_sg_enable(struct wl1271 *wl)
 		goto out;
 	}
 
-	pta->enable = ACX_SG_DISABLE;
+	pta->enable = wl->conf.sg.state;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
@@ -564,7 +564,7 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 {
 	struct acx_bt_wlan_coex_param *param;
 	struct conf_sg_settings *c = &wl->conf.sg;
-	int ret;
+	int i, ret;
 
 	wl1271_debug(DEBUG_ACX, "acx sg cfg");
 
@@ -575,8 +575,9 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	param->params[ACX_SG_BT_PER_THRESHOLD] = c->per_threshold;
-	param->param_idx = ACX_SG_BT_PER_THRESHOLD;
+	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
+		param->params[i] = c->params[i];
+	param->param_idx = CONF_SG_PARAMS_ALL;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 88a05cb..dee3c06 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -392,12 +392,6 @@ struct acx_conn_monit_params {
        __le32 bss_lose_timeout; /* number of TU's from synch fail */
 } __attribute__ ((packed));
 
-enum {
-	ACX_SG_DISABLE = 0,
-	ACX_SG_PROTECTIVE,
-	ACX_SG_OPPORTUNISTIC
-};
-
 struct acx_bt_wlan_coex {
 	struct acx_header header;
 
@@ -405,64 +399,10 @@ struct acx_bt_wlan_coex {
 	u8 pad[3];
 } __attribute__ ((packed));
 
-enum {
-	ACX_SG_BT_PER_THRESHOLD = 0,
-	ACX_SG_HV3_MAX_OVERRIDE,
-	ACX_SG_BT_NFS_SAMPLE_INTERVAL,
-	ACX_SG_BT_LOAD_RATIO,
-	ACX_SG_AUTO_PS_MODE,
-	ACX_SG_AUTO_SCAN_PROBE_REQ,
-	ACX_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
-	ACX_SG_ANTENNA_CONFIGURATION,
-	ACX_SG_BEACON_MISS_PERCENT,
-	ACX_SG_RATE_ADAPT_THRESH,
-	ACX_SG_RATE_ADAPT_SNR,
-	ACX_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR,
-	ACX_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR,
-	ACX_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR,
-	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR,
-	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR,
-	ACX_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR,
-	ACX_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR,
-	ACX_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR,
-	ACX_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR,
-	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR,
-	ACX_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR,
-	ACX_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR,
-	ACX_SG_RXT,
-	ACX_SG_TXT,
-	ACX_SG_ADAPTIVE_RXT_TXT,
-	ACX_SG_PS_POLL_TIMEOUT,
-	ACX_SG_UPSD_TIMEOUT,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR,
-	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR,
-	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_MIN_BR,
-	ACX_SG_WLAN_ACTIVE_BT_ACL_MAX_BR,
-	ACX_SG_WLAN_ACTIVE_MAX_BT_ACL_BR,
-	ACX_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
-	ACX_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP,
-	ACX_SG_PASSIVE_SCAN_A2DP_BT_TIME,
-	ACX_SG_PASSIVE_SCAN_A2DP_WLAN_TIME,
-	ACX_SG_HV3_MAX_SERVED,
-	ACX_SG_DHCP_TIME,
-	ACX_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
-	ACX_SG_TEMP_PARAM_1,
-	ACX_SG_TEMP_PARAM_2,
-	ACX_SG_TEMP_PARAM_3,
-	ACX_SG_TEMP_PARAM_4,
-	ACX_SG_TEMP_PARAM_5,
-	ACX_SG_PARAMS_MAX,
-	ACX_SG_PARAMS_ALL = 0xff
-};
-
 struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	__le32 params[ACX_SG_PARAMS_MAX];
+	__le32 params[CONF_SG_PARAMS_MAX];
 	u8 param_idx;
 	u8 padding[3];
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 6f9e75c..7fcfe06 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -65,110 +65,318 @@ enum {
 	CONF_HW_RATE_INDEX_MAX     = CONF_HW_RATE_INDEX_54MBPS,
 };
 
-struct conf_sg_settings {
+enum {
+	CONF_SG_DISABLE = 0,
+	CONF_SG_PROTECTIVE,
+	CONF_SG_OPPORTUNISTIC
+};
+
+enum {
 	/*
-	 * Defines the PER threshold in PPM of the BT voice of which reaching
-	 * this value will trigger raising the priority of the BT voice by
-	 * the BT IP until next NFS sample interval time as defined in
-	 * nfs_sample_interval.
+	 * PER threshold in PPM of the BT voice
 	 *
-	 * Unit: PER value in PPM (parts per million)
-	 * #Error_packets / #Total_packets
+	 * Range: 0 - 10000000
+	 */
+	CONF_SG_BT_PER_THRESHOLD = 0,
 
-	 * Range: u32
+	/*
+	 * Number of consequent RX_ACTIVE activities to override BT voice
+	 * frames to ensure WLAN connection
+	 *
+	 * Range: 0 - 100
+	 */
+	CONF_SG_HV3_MAX_OVERRIDE,
+
+	/*
+	 * Defines the PER threshold of the BT voice
+	 *
+	 * Range: 0 - 65000
+	 */
+	CONF_SG_BT_NFS_SAMPLE_INTERVAL,
+
+	/*
+	 * Defines the load ratio of BT
+	 *
+	 * Range: 0 - 100 (%)
+	 */
+	CONF_SG_BT_LOAD_RATIO,
+
+	/*
+	 * Defines whether the SG will force WLAN host to enter/exit PSM
+	 *
+	 * Range: 1 - SG can force, 0 - host handles PSM
+	 */
+	CONF_SG_AUTO_PS_MODE,
+
+	/*
+	 * Compensation percentage of probe requests when scan initiated
+	 * during BT voice/ACL link.
+	 *
+	 * Range: 0 - 255 (%)
+	 */
+	CONF_SG_AUTO_SCAN_PROBE_REQ,
+
+	/*
+	 * Compensation percentage of probe requests when active scan initiated
+	 * during BT voice
+	 *
+	 * Range: 0 - 255 (%)
+	 */
+	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
+
+	/*
+	 * Defines antenna configuration (single/dual antenna)
+	 *
+	 * Range: 0 - single antenna, 1 - dual antenna
+	 */
+	CONF_SG_ANTENNA_CONFIGURATION,
+
+	/*
+	 * The threshold (percent) of max consequtive beacon misses before
+	 * increasing priority of beacon reception.
+	 *
+	 * Range: 0 - 100 (%)
+	 */
+	CONF_SG_BEACON_MISS_PERCENT,
+
+	/*
+	 * The rate threshold below which receiving a data frame from the AP
+	 * will increase the priority of the data frame above BT traffic.
+	 *
+	 * Range: 0,2, 5(=5.5), 6, 9, 11, 12, 18, 24, 36, 48, 54
+	 */
+	CONF_SG_RATE_ADAPT_THRESH,
+
+	/*
+	 * Not used currently.
+	 *
+	 * Range: 0
+	 */
+	CONF_SG_RATE_ADAPT_SNR,
+
+	/*
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN PSM / BT master basic rate
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR,
+	CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR,
+
+	/*
+	 * The time after it expires no new WLAN trigger frame is trasmitted
+	 * in WLAN PSM / BT master basic rate
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR,
+
+	/*
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN PSM / BT slave basic rate
+	 *
+	 * Range: 0 - 255 (ms)
 	 */
-	u32 per_threshold;
+	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR,
+	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR,
 
 	/*
-	 * This value is an absolute time in micro-seconds to limit the
-	 * maximum scan duration compensation while in SG
+	 * The time after it expires no new WLAN trigger frame is trasmitted
+	 * in WLAN PSM / BT slave basic rate
+	 *
+	 * Range: 0 - 255 (ms)
 	 */
-	u32 max_scan_compensation_time;
+	CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR,
 
-	/* Defines the PER threshold of the BT voice of which reaching this
-	 * value will trigger raising the priority of the BT voice until next
-	 * NFS sample interval time as defined in sample_interval.
+	/*
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN PSM / BT master EDR
 	 *
-	 * Unit: msec
-	 * Range: 1-65000
+	 * Range: 0 - 255 (ms)
 	 */
-	u16 nfs_sample_interval;
+	CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR,
+	CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR,
 
 	/*
-	 * Defines the load ratio for the BT.
-	 * The WLAN ratio is: 100 - load_ratio
+	 * The time after it expires no new WLAN trigger frame is trasmitted
+	 * in WLAN PSM / BT master EDR
 	 *
-	 * Unit: Percent
-	 * Range: 0-100
+	 * Range: 0 - 255 (ms)
 	 */
-	u8 load_ratio;
+	CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR,
 
 	/*
-	 * true - Co-ex is allowed to enter/exit P.S automatically and
-	 *        transparently to the host
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN PSM / BT slave EDR
 	 *
-	 * false - Co-ex is disallowed to enter/exit P.S and will trigger an
-	 *         event to the host to notify for the need to enter/exit P.S
-	 *         due to BT change state
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR,
+	CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR,
+
+	/*
+	 * The time after it expires no new WLAN trigger frame is trasmitted
+	 * in WLAN PSM / BT slave EDR
 	 *
+	 * Range: 0 - 255 (ms)
 	 */
-	u8 auto_ps_mode;
+	CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR,
 
 	/*
-	 * This parameter defines the compensation percentage of num of probe
-	 * requests in case scan is initiated during BT voice/BT ACL
-	 * guaranteed link.
+	 * RX guard time before the beginning of a new BT voice frame during
+	 * which no new WLAN trigger frame is transmitted.
 	 *
-	 * Unit: Percent
-	 * Range: 0-255 (0 - No compensation)
+	 * Range: 0 - 100000 (us)
 	 */
-	u8 probe_req_compensation;
+	CONF_SG_RXT,
 
 	/*
-	 * This parameter defines the compensation percentage of scan window
-	 * size in case scan is initiated during BT voice/BT ACL Guaranteed
-	 * link.
+	 * TX guard time before the beginning of a new BT voice frame during
+	 * which no new WLAN frame is transmitted.
 	 *
-	 * Unit: Percent
-	 * Range: 0-255 (0 - No compensation)
+	 * Range: 0 - 100000 (us)
 	 */
-	u8 scan_window_compensation;
+
+	CONF_SG_TXT,
 
 	/*
-	 * Defines the antenna configuration.
+	 * Enable adaptive RXT/TXT algorithm. If disabled, the host values
+	 * will be utilized.
 	 *
-	 * Range: 0 - Single Antenna; 1 - Dual Antenna
+	 * Range: 0 - disable, 1 - enable
 	 */
-	u8 antenna_config;
+	CONF_SG_ADAPTIVE_RXT_TXT,
 
 	/*
-	 * The percent out of the Max consecutive beacon miss roaming trigger
-	 * which is the threshold for raising the priority of beacon
-	 * reception.
+	 * The used WLAN legacy service period during active BT ACL link
 	 *
-	 * Range: 1-100
-	 * N = MaxConsecutiveBeaconMiss
-	 * P = coexMaxConsecutiveBeaconMissPrecent
-	 * Threshold = MIN( N-1, round(N * P / 100))
+	 * Range: 0 - 255 (ms)
 	 */
-	u8 beacon_miss_threshold;
+	CONF_SG_PS_POLL_TIMEOUT,
 
 	/*
-	 * The RX rate threshold below which rate adaptation is assumed to be
-	 * occurring at the AP which will raise priority for ACTIVE_RX and RX
-	 * SP.
+	 * The used WLAN UPSD service period during active BT ACL link
 	 *
-	 * Range: HW_BIT_RATE_*
+	 * Range: 0 - 255 (ms)
 	 */
-	u32 rate_adaptation_threshold;
+	CONF_SG_UPSD_TIMEOUT,
 
 	/*
-	 * The SNR above which the RX rate threshold indicating AP rate
-	 * adaptation is valid
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN Active / BT master EDR
 	 *
-	 * Range: -128 - 127
+	 * Range: 0 - 255 (ms)
 	 */
-	s8 rate_adaptation_snr;
+	CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR,
+	CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR,
+
+	/*
+	 * The maximum time WLAN can gain the antenna for
+	 * in WLAN Active / BT master EDR
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR,
+
+	/*
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN Active / BT slave EDR
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR,
+	CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR,
+
+	/*
+	 * The maximum time WLAN can gain the antenna for
+	 * in WLAN Active / BT slave EDR
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR,
+
+	/*
+	 * Configure the min and max time BT gains the antenna
+	 * in WLAN Active / BT basic rate
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR,
+	CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR,
+
+	/*
+	 * The maximum time WLAN can gain the antenna for
+	 * in WLAN Active / BT basic rate
+	 *
+	 * Range: 0 - 255 (ms)
+	 */
+	CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR,
+
+	/*
+	 * Compensation percentage of WLAN passive scan window if initiated
+	 * during BT voice
+	 *
+	 * Range: 0 - 1000 (%)
+	 */
+	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
+
+	/*
+	 * Compensation percentage of WLAN passive scan window if initiated
+	 * during BT A2DP
+	 *
+	 * Range: 0 - 1000 (%)
+	 */
+	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP,
+
+	/*
+	 * Fixed time ensured for BT traffic to gain the antenna during WLAN
+	 * passive scan.
+	 *
+	 * Range: 0 - 1000 ms
+	 */
+	CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME,
+
+	/*
+	 * Fixed time ensured for WLAN traffic to gain the antenna during WLAN
+	 * passive scan.
+	 *
+	 * Range: 0 - 1000 ms
+	 */
+	CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME,
+
+	/*
+	 * Number of consequent BT voice frames not interrupted by WLAN
+	 *
+	 * Range: 0 - 100
+	 */
+	CONF_SG_HV3_MAX_SERVED,
+
+	/*
+	 * Protection time of the DHCP procedure.
+	 *
+	 * Range: 0 - 100000 (ms)
+	 */
+	CONF_SG_DHCP_TIME,
+
+	/*
+	 * Compensation percentage of WLAN active scan window if initiated
+	 * during BT A2DP
+	 *
+	 * Range: 0 - 1000 (%)
+	 */
+	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
+	CONF_SG_TEMP_PARAM_1,
+	CONF_SG_TEMP_PARAM_2,
+	CONF_SG_TEMP_PARAM_3,
+	CONF_SG_TEMP_PARAM_4,
+	CONF_SG_TEMP_PARAM_5,
+	CONF_SG_PARAMS_MAX,
+	CONF_SG_PARAMS_ALL = 0xff
+};
+
+struct conf_sg_settings {
+	__le32 params[CONF_SG_PARAMS_MAX];
+	u8 state;
 };
 
 enum conf_rx_queue_type {
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 86c30a8..d68445c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -160,11 +160,11 @@ int wl1271_init_pta(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl1271_acx_sg_enable(wl);
+	ret = wl1271_acx_sg_cfg(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_sg_cfg(wl);
+	ret = wl1271_acx_sg_enable(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b3abb45..6501d6e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -48,17 +48,57 @@
 
 static struct conf_drv_settings default_conf = {
 	.sg = {
-		.per_threshold               = 7500,
-		.max_scan_compensation_time  = 120000,
-		.nfs_sample_interval         = 400,
-		.load_ratio                  = 50,
-		.auto_ps_mode                = 0,
-		.probe_req_compensation      = 170,
-		.scan_window_compensation    = 50,
-		.antenna_config              = 0,
-		.beacon_miss_threshold       = 60,
-		.rate_adaptation_threshold   = CONF_HW_BIT_RATE_12MBPS,
-		.rate_adaptation_snr         = 0
+		.params = {
+			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
+			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
+			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
+			[CONF_SG_BT_LOAD_RATIO]                     = 50,
+			[CONF_SG_AUTO_PS_MODE]                      = 0,
+			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
+			[CONF_SG_ANTENNA_CONFIGURATION]             = 0,
+			[CONF_SG_BEACON_MISS_PERCENT]               = 60,
+			[CONF_SG_RATE_ADAPT_THRESH]                 = 12,
+			[CONF_SG_RATE_ADAPT_SNR]                    = 0,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_BR]      = 10,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_BR]      = 30,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_BR]      = 8,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_BR]       = 20,
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_BR]       = 50,
+			/* Note: with UPSD, this should be 4 */
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_BR]       = 8,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MIN_EDR]     = 7,
+			[CONF_SG_WLAN_PS_BT_ACL_MASTER_MAX_EDR]     = 25,
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_MASTER_EDR]     = 20,
+			/* Note: with UPDS, this should be 15 */
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MIN_EDR]      = 8,
+			/* Note: with UPDS, this should be 50 */
+			[CONF_SG_WLAN_PS_BT_ACL_SLAVE_MAX_EDR]      = 40,
+			/* Note: with UPDS, this should be 10 */
+			[CONF_SG_WLAN_PS_MAX_BT_ACL_SLAVE_EDR]      = 20,
+			[CONF_SG_RXT]                               = 1200,
+			[CONF_SG_TXT]                               = 1000,
+			[CONF_SG_ADAPTIVE_RXT_TXT]                  = 1,
+			[CONF_SG_PS_POLL_TIMEOUT]                   = 10,
+			[CONF_SG_UPSD_TIMEOUT]                      = 10,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MIN_EDR] = 7,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MASTER_MAX_EDR] = 15,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_MASTER_EDR] = 15,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MIN_EDR]  = 8,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_SLAVE_MAX_EDR]  = 20,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_SLAVE_EDR]  = 15,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MIN_BR]         = 20,
+			[CONF_SG_WLAN_ACTIVE_BT_ACL_MAX_BR]         = 50,
+			[CONF_SG_WLAN_ACTIVE_MAX_BT_ACL_BR]         = 10,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3]  = 200,
+			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP] = 800,
+			[CONF_SG_PASSIVE_SCAN_A2DP_BT_TIME]         = 75,
+			[CONF_SG_PASSIVE_SCAN_A2DP_WLAN_TIME]       = 15,
+			[CONF_SG_HV3_MAX_SERVED]                    = 6,
+			[CONF_SG_DHCP_TIME]                         = 5000,
+			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP]  = 100,
+		},
+		.state = CONF_SG_PROTECTIVE,
 	},
 	.rx = {
 		.rx_msdu_life_time           = 512000,
-- 
1.6.3.3

