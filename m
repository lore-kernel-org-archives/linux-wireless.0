Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYLQI7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:41 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/8] iwlwifi: cleanup iwl-dev.h
Date: Wed, 17 Dec 2008 16:52:27 +0800
Message-Id: <1229503954-30347-2-git-send-email-yi.zhu@intel.com> (sfid-20081217_095949_075677_5784A9A8)
In-Reply-To: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

The patch removes unused definition and moves code to proper places.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    6 -----
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    9 ++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   29 ++------------------------
 4 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ec6084c..85d9a51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -405,12 +405,6 @@ struct iwl3945_rx_queue {
 
 #define SCAN_INTERVAL 100
 
-#define MAX_A_CHANNELS  252
-#define MIN_A_CHANNELS  7
-
-#define MAX_B_CHANNELS  14
-#define MIN_B_CHANNELS  1
-
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
 #define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
 #define STATUS_INT_ENABLED	2
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 7956e08..f836ecc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -70,6 +70,15 @@
  * INIT calibrations framework
  *****************************************************************************/
 
+struct statistics_general_data {
+	u32 beacon_silence_rssi_a;
+	u32 beacon_silence_rssi_b;
+	u32 beacon_silence_rssi_c;
+	u32 beacon_energy_a;
+	u32 beacon_energy_b;
+	u32 beacon_energy_c;
+};
+
 int iwl_send_calib_results(struct iwl_priv *priv)
 {
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 60e79d9..52966ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2418,6 +2418,8 @@ struct statistics_rx_ht_phy {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
+#define INTERFERENCE_DATA_AVAILABLE      __constant_cpu_to_le32(1)
+
 struct statistics_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
 	__le32 bogus_ack;	/* ACK received when not expecting ACK */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index eaf0c9c..0468fcc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -323,14 +323,6 @@ struct iwl_rx_queue {
 
 #define IWL_SUPPORTED_RATES_IE_LEN         8
 
-#define SCAN_INTERVAL 100
-
-#define MAX_A_CHANNELS  252
-#define MIN_A_CHANNELS  7
-
-#define MAX_B_CHANNELS  14
-#define MIN_B_CHANNELS  1
-
 #define MAX_TID_COUNT        9
 
 #define IWL_INVALID_RATE     0xFF
@@ -496,8 +488,6 @@ struct iwl_sensitivity_ranges {
 };
 
 
-#define IWL_FAT_CHANNEL_52 BIT(IEEE80211_BAND_5GHZ)
-
 #define KELVIN_TO_CELSIUS(x) ((x)-273)
 #define CELSIUS_TO_KELVIN(x) ((x)+273)
 
@@ -546,9 +536,6 @@ struct iwl_hw_params {
 	const struct iwl_sensitivity_ranges *sens;
 };
 
-#define HT_SHORT_GI_20MHZ	(1 << 0)
-#define HT_SHORT_GI_40MHZ	(1 << 1)
-
 
 /******************************************************************************
  *
@@ -590,15 +577,15 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 }
 
 
-struct iwl_priv;
-
-
 struct iwl_dma_ptr {
 	dma_addr_t dma;
 	void *addr;
 	size_t size;
 };
 
+#define HT_SHORT_GI_20MHZ	(1 << 0)
+#define HT_SHORT_GI_40MHZ	(1 << 1)
+
 #define IWL_CHANNEL_WIDTH_20MHZ   0
 #define IWL_CHANNEL_WIDTH_40MHZ   1
 
@@ -613,7 +600,6 @@ struct iwl_dma_ptr {
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
 
 /* Sensitivity and chain noise calibration */
-#define INTERFERENCE_DATA_AVAILABLE	__constant_cpu_to_le32(1)
 #define INITIALIZATION_VALUE		0xFFFF
 #define CAL_NUM_OF_BEACONS		20
 #define MAXIMUM_ALLOWED_PATHLOSS	15
@@ -666,15 +652,6 @@ enum iwl4965_calib_enabled_state {
 	IWL_CALIB_ENABLED = 1,
 };
 
-struct statistics_general_data {
-	u32 beacon_silence_rssi_a;
-	u32 beacon_silence_rssi_b;
-	u32 beacon_silence_rssi_c;
-	u32 beacon_energy_a;
-	u32 beacon_energy_b;
-	u32 beacon_energy_c;
-};
-
 
 /*
  * enum iwl_calib
-- 
1.5.3.6

