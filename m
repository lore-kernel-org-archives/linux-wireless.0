Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:39564 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbbLBImf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 03:42:35 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id tB28gY0D024063
	for <linux-wireless@vger.kernel.org>; Wed, 2 Dec 2015 02:42:34 -0600
Received: from DLEE70.ent.ti.com (dlemailx.itg.ti.com [157.170.170.113])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id tB28gYll020455
	for <linux-wireless@vger.kernel.org>; Wed, 2 Dec 2015 02:42:34 -0600
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH V2] wlcore: split wl12xx/wl18xx sg parameters
Date: Wed, 2 Dec 2015 10:28:22 +0200
Message-ID: <1449044902-24617-1-git-send-email-guym@ti.com> (sfid-20151202_094239_236762_F11DFF34)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align to new wl18xx sg parameters.
This requires to split both wl12xx/wl18xx enumerators.

Signed-off-by: Guy Mishol <guym@ti.com>
Acked-by: Eliad Peller <eliad@wizery.com>
---
V2: Resubmitted again after modifying the commit massage

 drivers/net/wireless/ti/wl12xx/conf.h |  233 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/main.c |  116 ++++++++--------
 drivers/net/wireless/ti/wl18xx/conf.h |   90 +++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c |  138 +++++++++++---------
 drivers/net/wireless/ti/wlcore/acx.c  |    4 +-
 drivers/net/wireless/ti/wlcore/acx.h  |    2 +-
 drivers/net/wireless/ti/wlcore/conf.h |  237 +--------------------------------
 7 files changed, 463 insertions(+), 357 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/conf.h b/drivers/net/wireless/ti/wl12xx/conf.h
index 75e2989..a606ba9 100644
--- a/drivers/net/wireless/ti/wl12xx/conf.h
+++ b/drivers/net/wireless/ti/wl12xx/conf.h
@@ -47,4 +47,237 @@ struct wl12xx_priv_conf {
 	struct conf_memory_settings mem_wl127x;
 };
 
+enum wl12xx_sg_params {
+	/*
+	* Configure the min and max time BT gains the antenna
+	* in WLAN / BT master basic rate
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_BT_MASTER_MIN_BR = 0,
+	WL12XX_CONF_SG_ACL_BT_MASTER_MAX_BR,
+
+	/*
+	* Configure the min and max time BT gains the antenna
+	* in WLAN / BT slave basic rate
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_BT_SLAVE_MIN_BR,
+	WL12XX_CONF_SG_ACL_BT_SLAVE_MAX_BR,
+
+	/*
+	* Configure the min and max time BT gains the antenna
+	* in WLAN / BT master EDR
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_BT_MASTER_MIN_EDR,
+	WL12XX_CONF_SG_ACL_BT_MASTER_MAX_EDR,
+
+	/*
+	* Configure the min and max time BT gains the antenna
+	* in WLAN / BT slave EDR
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_BT_SLAVE_MIN_EDR,
+	WL12XX_CONF_SG_ACL_BT_SLAVE_MAX_EDR,
+
+	/*
+	* The maximum time WLAN can gain the antenna
+	* in WLAN PSM / BT master/slave BR
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_WLAN_PS_MASTER_BR,
+	WL12XX_CONF_SG_ACL_WLAN_PS_SLAVE_BR,
+
+	/*
+	* The maximum time WLAN can gain the antenna
+	* in WLAN PSM / BT master/slave EDR
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_ACL_WLAN_PS_MASTER_EDR,
+	WL12XX_CONF_SG_ACL_WLAN_PS_SLAVE_EDR,
+
+	/* TODO: explain these values */
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR,
+	WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR,
+
+	WL12XX_CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR,
+	WL12XX_CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR,
+	WL12XX_CONF_SG_ACL_PASSIVE_SCAN_BT_BR,
+	WL12XX_CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR,
+	WL12XX_CONF_SG_ACL_PASSIVE_SCAN_BT_EDR,
+	WL12XX_CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR,
+
+	/*
+	* Compensation percentage of probe requests when scan initiated
+	* during BT voice/ACL link.
+	*
+	* Range: 0 - 255 (%)
+	*/
+	WL12XX_CONF_SG_AUTO_SCAN_PROBE_REQ,
+
+	/*
+	* Compensation percentage of probe requests when active scan initiated
+	* during BT voice
+	*
+	* Range: 0 - 255 (%)
+	*/
+	WL12XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
+
+	/*
+	* Compensation percentage of WLAN active scan window if initiated
+	* during BT A2DP
+	*
+	* Range: 0 - 1000 (%)
+	*/
+	WL12XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
+
+	/*
+	* Compensation percentage of WLAN passive scan window if initiated
+	* during BT A2DP BR
+	*
+	* Range: 0 - 1000 (%)
+	*/
+	WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_A2DP_BR,
+
+	/*
+	* Compensation percentage of WLAN passive scan window if initiated
+	* during BT A2DP EDR
+	*
+	* Range: 0 - 1000 (%)
+	*/
+	WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_A2DP_EDR,
+
+	/*
+	* Compensation percentage of WLAN passive scan window if initiated
+	* during BT voice
+	*
+	* Range: 0 - 1000 (%)
+	*/
+	WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_HV3,
+
+	/* TODO: explain these values */
+	WL12XX_CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN,
+	WL12XX_CONF_SG_BCN_HV3_COLL_THR_IN_PASSIVE_SCAN,
+	WL12XX_CONF_SG_TX_RX_PROTECT_BW_IN_PASSIVE_SCAN,
+
+	/*
+	* Defines whether the SG will force WLAN host to enter/exit PSM
+	*
+	* Range: 1 - SG can force, 0 - host handles PSM
+	*/
+	WL12XX_CONF_SG_STA_FORCE_PS_IN_BT_SCO,
+
+	/*
+	* Defines antenna configuration (single/dual antenna)
+	*
+	* Range: 0 - single antenna, 1 - dual antenna
+	*/
+	WL12XX_CONF_SG_ANTENNA_CONFIGURATION,
+
+	/*
+	* The threshold (percent) of max consecutive beacon misses before
+	* increasing priority of beacon reception.
+	*
+	* Range: 0 - 100 (%)
+	*/
+	WL12XX_CONF_SG_BEACON_MISS_PERCENT,
+
+	/*
+	* Protection time of the DHCP procedure.
+	*
+	* Range: 0 - 100000 (ms)
+	*/
+	WL12XX_CONF_SG_DHCP_TIME,
+
+	/*
+	* RX guard time before the beginning of a new BT voice frame during
+	* which no new WLAN trigger frame is transmitted.
+	*
+	* Range: 0 - 100000 (us)
+	*/
+	WL12XX_CONF_SG_RXT,
+
+	/*
+	* TX guard time before the beginning of a new BT voice frame during
+	* which no new WLAN frame is transmitted.
+	*
+	* Range: 0 - 100000 (us)
+	*/
+	WL12XX_CONF_SG_TXT,
+
+	/*
+	* Enable adaptive RXT/TXT algorithm. If disabled, the host values
+	* will be utilized.
+	*
+	* Range: 0 - disable, 1 - enable
+	*/
+	WL12XX_CONF_SG_ADAPTIVE_RXT_TXT,
+
+	/* TODO: explain this value */
+	WL12XX_CONF_SG_GENERAL_USAGE_BIT_MAP,
+
+	/*
+	* Number of consecutive BT voice frames not interrupted by WLAN
+	*
+	* Range: 0 - 100
+	*/
+	WL12XX_CONF_SG_HV3_MAX_SERVED,
+
+	/*
+	* The used WLAN legacy service period during active BT ACL link
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_PS_POLL_TIMEOUT,
+
+	/*
+	* The used WLAN UPSD service period during active BT ACL link
+	*
+	* Range: 0 - 255 (ms)
+	*/
+	WL12XX_CONF_SG_UPSD_TIMEOUT,
+
+	WL12XX_CONF_SG_CONSECUTIVE_CTS_THRESHOLD,
+	WL12XX_CONF_SG_STA_RX_WINDOW_AFTER_DTIM,
+	WL12XX_CONF_SG_STA_CONNECTION_PROTECTION_TIME,
+
+	/* AP params */
+	WL12XX_CONF_AP_BEACON_MISS_TX,
+	WL12XX_CONF_AP_RX_WINDOW_AFTER_BEACON,
+	WL12XX_CONF_AP_BEACON_WINDOW_INTERVAL,
+	WL12XX_CONF_AP_CONNECTION_PROTECTION_TIME,
+	WL12XX_CONF_AP_BT_ACL_VAL_BT_SERVE_TIME,
+	WL12XX_CONF_AP_BT_ACL_VAL_WL_SERVE_TIME,
+
+	/* CTS Diluting params */
+	WL12XX_CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH,
+	WL12XX_CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER,
+
+	WL12XX_CONF_SG_TEMP_PARAM_1,
+	WL12XX_CONF_SG_TEMP_PARAM_2,
+	WL12XX_CONF_SG_TEMP_PARAM_3,
+	WL12XX_CONF_SG_TEMP_PARAM_4,
+	WL12XX_CONF_SG_TEMP_PARAM_5,
+	WL12XX_CONF_SG_TEMP_PARAM_6,
+	WL12XX_CONF_SG_TEMP_PARAM_7,
+	WL12XX_CONF_SG_TEMP_PARAM_8,
+	WL12XX_CONF_SG_TEMP_PARAM_9,
+	WL12XX_CONF_SG_TEMP_PARAM_10,
+
+	WL12XX_CONF_SG_PARAMS_MAX,
+	WL12XX_CONF_SG_PARAMS_ALL = 0xff
+};
+
 #endif /* __WL12XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index af0fe2e..a0d6ccc 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -39,6 +39,7 @@
 #include "scan.h"
 #include "event.h"
 #include "debugfs.h"
+#include "conf.h"
 
 static char *fref_param;
 static char *tcxo_param;
@@ -46,69 +47,69 @@ static char *tcxo_param;
 static struct wlcore_conf wl12xx_conf = {
 	.sg = {
 		.params = {
-			[CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
-			[CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
-			[CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
+			[WL12XX_CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
+			[WL12XX_CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
+			[WL12XX_CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
+			[WL12XX_CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
+			[WL12XX_CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
+			[WL12XX_CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
+			[WL12XX_CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
+			[WL12XX_CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
+			[WL12XX_CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
+			[WL12XX_CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
+			[WL12XX_CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
+			[WL12XX_CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
+			[WL12XX_CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
+			[WL12XX_CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
+			[WL12XX_CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
+			[WL12XX_CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
+			[WL12XX_CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
+			[WL12XX_CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
+			[WL12XX_CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
 			/* active scan params */
-			[CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
+			[WL12XX_CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
+			[WL12XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
+			[WL12XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
 			/* passive scan params */
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR] = 800,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR] = 200,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
+			[WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_A2DP_BR] = 800,
+			[WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_A2DP_EDR] = 200,
+			[WL12XX_CONF_SG_PASSIVE_SCAN_DUR_FACTOR_HV3] = 200,
 			/* passive scan in dual antenna params */
-			[CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN] = 0,
+			[WL12XX_CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
+			[WL12XX_CONF_SG_BCN_HV3_COLL_THR_IN_PASSIVE_SCAN] = 0,
+			[WL12XX_CONF_SG_TX_RX_PROTECT_BW_IN_PASSIVE_SCAN] = 0,
 			/* general params */
-			[CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
-			[CONF_SG_ANTENNA_CONFIGURATION] = 0,
-			[CONF_SG_BEACON_MISS_PERCENT] = 60,
-			[CONF_SG_DHCP_TIME] = 5000,
-			[CONF_SG_RXT] = 1200,
-			[CONF_SG_TXT] = 1000,
-			[CONF_SG_ADAPTIVE_RXT_TXT] = 1,
-			[CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
-			[CONF_SG_HV3_MAX_SERVED] = 6,
-			[CONF_SG_PS_POLL_TIMEOUT] = 10,
-			[CONF_SG_UPSD_TIMEOUT] = 10,
-			[CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
-			[CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
-			[CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
+			[WL12XX_CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
+			[WL12XX_CONF_SG_ANTENNA_CONFIGURATION] = 0,
+			[WL12XX_CONF_SG_BEACON_MISS_PERCENT] = 60,
+			[WL12XX_CONF_SG_DHCP_TIME] = 5000,
+			[WL12XX_CONF_SG_RXT] = 1200,
+			[WL12XX_CONF_SG_TXT] = 1000,
+			[WL12XX_CONF_SG_ADAPTIVE_RXT_TXT] = 1,
+			[WL12XX_CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
+			[WL12XX_CONF_SG_HV3_MAX_SERVED] = 6,
+			[WL12XX_CONF_SG_PS_POLL_TIMEOUT] = 10,
+			[WL12XX_CONF_SG_UPSD_TIMEOUT] = 10,
+			[WL12XX_CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
+			[WL12XX_CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
+			[WL12XX_CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
 			/* AP params */
-			[CONF_AP_BEACON_MISS_TX] = 3,
-			[CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
-			[CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
-			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
-			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
-			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
+			[WL12XX_CONF_AP_BEACON_MISS_TX] = 3,
+			[WL12XX_CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
+			[WL12XX_CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
+			[WL12XX_CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
+			[WL12XX_CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
+			[WL12XX_CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
 			/* CTS Diluting params */
-			[CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
-			[CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
+			[WL12XX_CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
+			[WL12XX_CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
 		},
 		.state = CONF_SG_PROTECTIVE,
 	},
@@ -1809,6 +1810,7 @@ static int wl12xx_setup(struct wl1271 *wl)
 
 	BUILD_BUG_ON(WL12XX_MAX_LINKS > WLCORE_MAX_LINKS);
 	BUILD_BUG_ON(WL12XX_MAX_AP_STATIONS > WL12XX_MAX_LINKS);
+	BUILD_BUG_ON(WL12XX_CONF_SG_PARAMS_MAX > WLCORE_CONF_SG_PARAMS_MAX);
 
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index 71f1ec4..7aa880f 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -139,4 +139,94 @@ struct wl18xx_priv_conf {
 	struct conf_ap_sleep_settings ap_sleep;
 } __packed;
 
+enum wl18xx_sg_params {
+	WL18XX_CONF_SG_PARAM_0 = 0,
+
+	/* Configuration Parameters */
+	WL18XX_CONF_SG_ANTENNA_CONFIGURATION,
+	WL18XX_CONF_SG_ZIGBEE_COEX,
+	WL18XX_CONF_SG_TIME_SYNC,
+
+	WL18XX_CONF_SG_PARAM_4,
+	WL18XX_CONF_SG_PARAM_5,
+	WL18XX_CONF_SG_PARAM_6,
+	WL18XX_CONF_SG_PARAM_7,
+	WL18XX_CONF_SG_PARAM_8,
+	WL18XX_CONF_SG_PARAM_9,
+	WL18XX_CONF_SG_PARAM_10,
+	WL18XX_CONF_SG_PARAM_11,
+	WL18XX_CONF_SG_PARAM_12,
+	WL18XX_CONF_SG_PARAM_13,
+	WL18XX_CONF_SG_PARAM_14,
+	WL18XX_CONF_SG_PARAM_15,
+	WL18XX_CONF_SG_PARAM_16,
+	WL18XX_CONF_SG_PARAM_17,
+	WL18XX_CONF_SG_PARAM_18,
+	WL18XX_CONF_SG_PARAM_19,
+	WL18XX_CONF_SG_PARAM_20,
+	WL18XX_CONF_SG_PARAM_21,
+	WL18XX_CONF_SG_PARAM_22,
+	WL18XX_CONF_SG_PARAM_23,
+	WL18XX_CONF_SG_PARAM_24,
+	WL18XX_CONF_SG_PARAM_25,
+
+	/* Active Scan Parameters */
+	WL18XX_CONF_SG_AUTO_SCAN_PROBE_REQ,
+	WL18XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
+
+	WL18XX_CONF_SG_PARAM_28,
+
+	/* Passive Scan Parameters */
+	WL18XX_CONF_SG_PARAM_29,
+	WL18XX_CONF_SG_PARAM_30,
+	WL18XX_CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
+
+	/* Passive Scan in Dual Antenna Parameters */
+	WL18XX_CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN,
+	WL18XX_CONF_SG_BEACON_HV3_COLL_TH_IN_PASSIVE_SCAN,
+	WL18XX_CONF_SG_TX_RX_PROTECT_BW_IN_PASSIVE_SCAN,
+
+	/* General Parameters */
+	WL18XX_CONF_SG_STA_FORCE_PS_IN_BT_SCO,
+	WL18XX_CONF_SG_PARAM_36,
+	WL18XX_CONF_SG_BEACON_MISS_PERCENT,
+	WL18XX_CONF_SG_PARAM_38,
+	WL18XX_CONF_SG_RXT,
+	WL18XX_CONF_SG_UNUSED,
+	WL18XX_CONF_SG_ADAPTIVE_RXT_TXT,
+	WL18XX_CONF_SG_GENERAL_USAGE_BIT_MAP,
+	WL18XX_CONF_SG_HV3_MAX_SERVED,
+	WL18XX_CONF_SG_PARAM_44,
+	WL18XX_CONF_SG_PARAM_45,
+	WL18XX_CONF_SG_CONSECUTIVE_CTS_THRESHOLD,
+	WL18XX_CONF_SG_GEMINI_PARAM_47,
+	WL18XX_CONF_SG_STA_CONNECTION_PROTECTION_TIME,
+
+	/* AP Parameters */
+	WL18XX_CONF_SG_AP_BEACON_MISS_TX,
+	WL18XX_CONF_SG_PARAM_50,
+	WL18XX_CONF_SG_AP_BEACON_WINDOW_INTERVAL,
+	WL18XX_CONF_SG_AP_CONNECTION_PROTECTION_TIME,
+	WL18XX_CONF_SG_PARAM_53,
+	WL18XX_CONF_SG_PARAM_54,
+
+	/* CTS Diluting Parameters */
+	WL18XX_CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH,
+	WL18XX_CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER,
+
+	WL18XX_CONF_SG_TEMP_PARAM_1,
+	WL18XX_CONF_SG_TEMP_PARAM_2,
+	WL18XX_CONF_SG_TEMP_PARAM_3,
+	WL18XX_CONF_SG_TEMP_PARAM_4,
+	WL18XX_CONF_SG_TEMP_PARAM_5,
+	WL18XX_CONF_SG_TEMP_PARAM_6,
+	WL18XX_CONF_SG_TEMP_PARAM_7,
+	WL18XX_CONF_SG_TEMP_PARAM_8,
+	WL18XX_CONF_SG_TEMP_PARAM_9,
+	WL18XX_CONF_SG_TEMP_PARAM_10,
+
+	WL18XX_CONF_SG_PARAMS_MAX,
+	WL18XX_CONF_SG_PARAMS_ALL = 0xff
+};
+
 #endif /* __WL18XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 50cce42..7869c3c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -177,69 +177,80 @@ enum wl18xx_hw_rates {
 static struct wlcore_conf wl18xx_conf = {
 	.sg = {
 		.params = {
-			[CONF_SG_ACL_BT_MASTER_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_SLAVE_MIN_BR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_BR] = 180,
-			[CONF_SG_ACL_BT_MASTER_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_MASTER_MAX_EDR] = 80,
-			[CONF_SG_ACL_BT_SLAVE_MIN_EDR] = 10,
-			[CONF_SG_ACL_BT_SLAVE_MAX_EDR] = 80,
-			[CONF_SG_ACL_WLAN_PS_MASTER_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_BR] = 8,
-			[CONF_SG_ACL_WLAN_PS_MASTER_EDR] = 20,
-			[CONF_SG_ACL_WLAN_PS_SLAVE_EDR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR] = 20,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR] = 16,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR] = 35,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR] = 32,
-			[CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR] = 50,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR] = 28,
-			[CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR] = 50,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR] = 10,
-			[CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR] = 20,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_BR] = 75,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR] = 15,
-			[CONF_SG_ACL_PASSIVE_SCAN_BT_EDR] = 27,
-			[CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR] = 17,
-			/* active scan params */
-			[CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
-			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP] = 100,
-			/* passive scan params */
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR] = 800,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR] = 200,
-			[CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
-			/* passive scan in dual antenna params */
-			[CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN] = 0,
-			[CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN] = 0,
-			/* general params */
-			[CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
-			[CONF_SG_ANTENNA_CONFIGURATION] = 0,
-			[CONF_SG_BEACON_MISS_PERCENT] = 60,
-			[CONF_SG_DHCP_TIME] = 5000,
-			[CONF_SG_RXT] = 1200,
-			[CONF_SG_TXT] = 1000,
-			[CONF_SG_ADAPTIVE_RXT_TXT] = 1,
-			[CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
-			[CONF_SG_HV3_MAX_SERVED] = 6,
-			[CONF_SG_PS_POLL_TIMEOUT] = 10,
-			[CONF_SG_UPSD_TIMEOUT] = 10,
-			[CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
-			[CONF_SG_STA_RX_WINDOW_AFTER_DTIM] = 5,
-			[CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 30,
-			/* AP params */
-			[CONF_AP_BEACON_MISS_TX] = 3,
-			[CONF_AP_RX_WINDOW_AFTER_BEACON] = 10,
-			[CONF_AP_BEACON_WINDOW_INTERVAL] = 2,
-			[CONF_AP_CONNECTION_PROTECTION_TIME] = 0,
-			[CONF_AP_BT_ACL_VAL_BT_SERVE_TIME] = 25,
-			[CONF_AP_BT_ACL_VAL_WL_SERVE_TIME] = 25,
-			/* CTS Diluting params */
-			[CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
-			[CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
+			[WL18XX_CONF_SG_PARAM_0] = 0,
+			/* Configuartion Parameters */
+			[WL18XX_CONF_SG_ANTENNA_CONFIGURATION] = 0,
+			[WL18XX_CONF_SG_ZIGBEE_COEX] = 0,
+			[WL18XX_CONF_SG_TIME_SYNC] = 0,
+			[WL18XX_CONF_SG_PARAM_4] = 0,
+			[WL18XX_CONF_SG_PARAM_5] = 0,
+			[WL18XX_CONF_SG_PARAM_6] = 0,
+			[WL18XX_CONF_SG_PARAM_7] = 0,
+			[WL18XX_CONF_SG_PARAM_8] = 0,
+			[WL18XX_CONF_SG_PARAM_9] = 0,
+			[WL18XX_CONF_SG_PARAM_10] = 0,
+			[WL18XX_CONF_SG_PARAM_11] = 0,
+			[WL18XX_CONF_SG_PARAM_12] = 0,
+			[WL18XX_CONF_SG_PARAM_13] = 0,
+			[WL18XX_CONF_SG_PARAM_14] = 0,
+			[WL18XX_CONF_SG_PARAM_15] = 0,
+			[WL18XX_CONF_SG_PARAM_16] = 0,
+			[WL18XX_CONF_SG_PARAM_17] = 0,
+			[WL18XX_CONF_SG_PARAM_18] = 0,
+			[WL18XX_CONF_SG_PARAM_19] = 0,
+			[WL18XX_CONF_SG_PARAM_20] = 0,
+			[WL18XX_CONF_SG_PARAM_21] = 0,
+			[WL18XX_CONF_SG_PARAM_22] = 0,
+			[WL18XX_CONF_SG_PARAM_23] = 0,
+			[WL18XX_CONF_SG_PARAM_24] = 0,
+			[WL18XX_CONF_SG_PARAM_25] = 0,
+			/* Active Scan Parameters */
+			[WL18XX_CONF_SG_AUTO_SCAN_PROBE_REQ] = 170,
+			[WL18XX_CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3] = 50,
+			[WL18XX_CONF_SG_PARAM_28] = 0,
+			/* Passive Scan Parameters */
+			[WL18XX_CONF_SG_PARAM_29] = 0,
+			[WL18XX_CONF_SG_PARAM_30] = 0,
+			[WL18XX_CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3] = 200,
+			/* Passive Scan in Dual Antenna Parameters */
+			[WL18XX_CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN] = 0,
+			[WL18XX_CONF_SG_BEACON_HV3_COLL_TH_IN_PASSIVE_SCAN] = 0,
+			[WL18XX_CONF_SG_TX_RX_PROTECT_BW_IN_PASSIVE_SCAN] = 0,
+			/* General Parameters */
+			[WL18XX_CONF_SG_STA_FORCE_PS_IN_BT_SCO] = 1,
+			[WL18XX_CONF_SG_PARAM_36] = 0,
+			[WL18XX_CONF_SG_BEACON_MISS_PERCENT] = 60,
+			[WL18XX_CONF_SG_PARAM_38] = 0,
+			[WL18XX_CONF_SG_RXT] = 1200,
+			[WL18XX_CONF_SG_UNUSED] = 0,
+			[WL18XX_CONF_SG_ADAPTIVE_RXT_TXT] = 1,
+			[WL18XX_CONF_SG_GENERAL_USAGE_BIT_MAP] = 3,
+			[WL18XX_CONF_SG_HV3_MAX_SERVED] = 6,
+			[WL18XX_CONF_SG_PARAM_44] = 0,
+			[WL18XX_CONF_SG_PARAM_45] = 0,
+			[WL18XX_CONF_SG_CONSECUTIVE_CTS_THRESHOLD] = 2,
+			[WL18XX_CONF_SG_GEMINI_PARAM_47] = 0,
+			[WL18XX_CONF_SG_STA_CONNECTION_PROTECTION_TIME] = 0,
+			/* AP Parameters */
+			[WL18XX_CONF_SG_AP_BEACON_MISS_TX] = 3,
+			[WL18XX_CONF_SG_PARAM_50] = 0,
+			[WL18XX_CONF_SG_AP_BEACON_WINDOW_INTERVAL] = 2,
+			[WL18XX_CONF_SG_AP_CONNECTION_PROTECTION_TIME] = 30,
+			[WL18XX_CONF_SG_PARAM_53] = 0,
+			[WL18XX_CONF_SG_PARAM_54] = 0,
+			/* CTS Diluting Parameters */
+			[WL18XX_CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH] = 0,
+			[WL18XX_CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_1] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_2] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_3] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_4] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_5] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_6] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_7] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_8] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_9] = 0,
+			[WL18XX_CONF_SG_TEMP_PARAM_10] = 0,
 		},
 		.state = CONF_SG_PROTECTIVE,
 	},
@@ -1895,6 +1906,7 @@ static int wl18xx_setup(struct wl1271 *wl)
 
 	BUILD_BUG_ON(WL18XX_MAX_LINKS > WLCORE_MAX_LINKS);
 	BUILD_BUG_ON(WL18XX_MAX_AP_STATIONS > WL18XX_MAX_LINKS);
+	BUILD_BUG_ON(WL18XX_CONF_SG_PARAMS_MAX > WLCORE_CONF_SG_PARAMS_MAX);
 
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index f28fa3b..26cc23f 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -534,9 +534,9 @@ int wl12xx_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
+	for (i = 0; i < WLCORE_CONF_SG_PARAMS_MAX; i++)
 		param->params[i] = cpu_to_le32(c->params[i]);
-	param->param_idx = CONF_SG_PARAMS_ALL;
+	param->param_idx = WLCORE_CONF_SG_PARAMS_ALL;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 954d57e..0d61fae 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -300,7 +300,7 @@ struct acx_bt_wlan_coex {
 struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	__le32 params[CONF_SG_PARAMS_MAX];
+	__le32 params[WLCORE_CONF_SG_PARAMS_MAX];
 	u8 param_idx;
 	u8 padding[3];
 } __packed;
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 52a9d1b..44d898f 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -110,242 +110,11 @@ enum {
 	CONF_SG_OPPORTUNISTIC
 };
 
-enum {
-	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN / BT master basic rate
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_BT_MASTER_MIN_BR = 0,
-	CONF_SG_ACL_BT_MASTER_MAX_BR,
-
-	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN / BT slave basic rate
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_BT_SLAVE_MIN_BR,
-	CONF_SG_ACL_BT_SLAVE_MAX_BR,
-
-	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN / BT master EDR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_BT_MASTER_MIN_EDR,
-	CONF_SG_ACL_BT_MASTER_MAX_EDR,
-
-	/*
-	 * Configure the min and max time BT gains the antenna
-	 * in WLAN / BT slave EDR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_BT_SLAVE_MIN_EDR,
-	CONF_SG_ACL_BT_SLAVE_MAX_EDR,
-
-	/*
-	 * The maximum time WLAN can gain the antenna
-	 * in WLAN PSM / BT master/slave BR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_WLAN_PS_MASTER_BR,
-	CONF_SG_ACL_WLAN_PS_SLAVE_BR,
-
-	/*
-	 * The maximum time WLAN can gain the antenna
-	 * in WLAN PSM / BT master/slave EDR
-	 *
-	 * Range: 0 - 255 (ms)
-	 */
-	CONF_SG_ACL_WLAN_PS_MASTER_EDR,
-	CONF_SG_ACL_WLAN_PS_SLAVE_EDR,
-
-	/* TODO: explain these values */
-	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_BR,
-	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_BR,
-	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_BR,
-	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_BR,
-	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MIN_EDR,
-	CONF_SG_ACL_WLAN_ACTIVE_MASTER_MAX_EDR,
-	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MIN_EDR,
-	CONF_SG_ACL_WLAN_ACTIVE_SLAVE_MAX_EDR,
-
-	CONF_SG_ACL_ACTIVE_SCAN_WLAN_BR,
-	CONF_SG_ACL_ACTIVE_SCAN_WLAN_EDR,
-	CONF_SG_ACL_PASSIVE_SCAN_BT_BR,
-	CONF_SG_ACL_PASSIVE_SCAN_WLAN_BR,
-	CONF_SG_ACL_PASSIVE_SCAN_BT_EDR,
-	CONF_SG_ACL_PASSIVE_SCAN_WLAN_EDR,
-
-	/*
-	 * Compensation percentage of probe requests when scan initiated
-	 * during BT voice/ACL link.
-	 *
-	 * Range: 0 - 255 (%)
-	 */
-	CONF_SG_AUTO_SCAN_PROBE_REQ,
-
-	/*
-	 * Compensation percentage of probe requests when active scan initiated
-	 * during BT voice
-	 *
-	 * Range: 0 - 255 (%)
-	 */
-	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3,
-
-	/*
-	 * Compensation percentage of WLAN active scan window if initiated
-	 * during BT A2DP
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_A2DP,
-
-	/*
-	 * Compensation percentage of WLAN passive scan window if initiated
-	 * during BT A2DP BR
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_BR,
-
-	/*
-	 * Compensation percentage of WLAN passive scan window if initiated
-	 * during BT A2DP EDR
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_A2DP_EDR,
-
-	/*
-	 * Compensation percentage of WLAN passive scan window if initiated
-	 * during BT voice
-	 *
-	 * Range: 0 - 1000 (%)
-	 */
-	CONF_SG_PASSIVE_SCAN_DURATION_FACTOR_HV3,
-
-	/* TODO: explain these values */
-	CONF_SG_CONSECUTIVE_HV3_IN_PASSIVE_SCAN,
-	CONF_SG_BCN_HV3_COLLISION_THRESH_IN_PASSIVE_SCAN,
-	CONF_SG_TX_RX_PROTECTION_BWIDTH_IN_PASSIVE_SCAN,
-
-	/*
-	 * Defines whether the SG will force WLAN host to enter/exit PSM
-	 *
-	 * Range: 1 - SG can force, 0 - host handles PSM
-	 */
-	CONF_SG_STA_FORCE_PS_IN_BT_SCO,
-
-	/*
-	 * Defines antenna configuration (single/dual antenna)
-	 *
-	 * Range: 0 - single antenna, 1 - dual antenna
-	 */
-	CONF_SG_ANTENNA_CONFIGURATION,
-
-	/*
-	 * The threshold (percent) of max consecutive beacon misses before
-	 * increasing priority of beacon reception.
-	 *
-	 * Range: 0 - 100 (%)
-	 */
-	CONF_SG_BEACON_MISS_PERCENT,
-
-	/*
-	 * Protection time of the DHCP procedure.
-	 *
-	 * Range: 0 - 100000 (ms)
-	 */
-	CONF_SG_DHCP_TIME,
-
-	/*
-	 * RX guard time before the beginning of a new BT voice frame during
-	 * which no new WLAN trigger frame is transmitted.
-	 *
-	 * Range: 0 - 100000 (us)
-	 */
-	CONF_SG_RXT,
-
-	/*
-	 * TX guard time before the beginning of a new BT voice frame during
-	 * which no new WLAN frame is transmitted.
-	 *
-	 * Range: 0 - 100000 (us)
-	 */
-
-	CONF_SG_TXT,
-
-	/*
-	 * Enable adaptive RXT/TXT algorithm. If disabled, the host values
-	 * will be utilized.
-	 *
-	 * Range: 0 - disable, 1 - enable
-	 */
-	CONF_SG_ADAPTIVE_RXT_TXT,
-
-	/* TODO: explain this value */
-	CONF_SG_GENERAL_USAGE_BIT_MAP,
-
-	/*
-	 * Number of consecutive BT voice frames not interrupted by WLAN
-	 *
-	 * Range: 0 - 100
-	 */
-	CONF_SG_HV3_MAX_SERVED,
-
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
-	CONF_SG_CONSECUTIVE_CTS_THRESHOLD,
-	CONF_SG_STA_RX_WINDOW_AFTER_DTIM,
-	CONF_SG_STA_CONNECTION_PROTECTION_TIME,
-
-	/* AP params */
-	CONF_AP_BEACON_MISS_TX,
-	CONF_AP_RX_WINDOW_AFTER_BEACON,
-	CONF_AP_BEACON_WINDOW_INTERVAL,
-	CONF_AP_CONNECTION_PROTECTION_TIME,
-	CONF_AP_BT_ACL_VAL_BT_SERVE_TIME,
-	CONF_AP_BT_ACL_VAL_WL_SERVE_TIME,
-
-	/* CTS Diluting params */
-	CONF_SG_CTS_DILUTED_BAD_RX_PACKETS_TH,
-	CONF_SG_CTS_CHOP_IN_DUAL_ANT_SCO_MASTER,
-
-	CONF_SG_TEMP_PARAM_1,
-	CONF_SG_TEMP_PARAM_2,
-	CONF_SG_TEMP_PARAM_3,
-	CONF_SG_TEMP_PARAM_4,
-	CONF_SG_TEMP_PARAM_5,
-	CONF_SG_TEMP_PARAM_6,
-	CONF_SG_TEMP_PARAM_7,
-	CONF_SG_TEMP_PARAM_8,
-	CONF_SG_TEMP_PARAM_9,
-	CONF_SG_TEMP_PARAM_10,
-
-	CONF_SG_PARAMS_MAX,
-	CONF_SG_PARAMS_ALL = 0xff
-};
+#define WLCORE_CONF_SG_PARAMS_MAX 67
+#define WLCORE_CONF_SG_PARAMS_ALL 0xff
 
 struct conf_sg_settings {
-	u32 params[CONF_SG_PARAMS_MAX];
+	u32 params[WLCORE_CONF_SG_PARAMS_MAX];
 	u8 state;
 } __packed;
 
-- 
1.7.0.4

