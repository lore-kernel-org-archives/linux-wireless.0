Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbXK2DKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:46 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/36] iwlwifi: clean up some unused definitions in iwl-4965.h and iwl-3945.h
Date: Thu, 29 Nov 2007 11:09:53 +0800
Message-Id: <1196305816-23023-14-git-send-email-yi.zhu@intel.com> (sfid-20071129_033546_043353_7413C166)
In-Reply-To: <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up some unused definitions in iwl-4965.h and iwl-3945.h

Move STA_FLG_ definitions to iwl-4965-commands.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h          |   21 -----------------
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    8 ++++++
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   26 ----------------------
 3 files changed, 8 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 607a1ed..2f3a8b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -191,14 +191,6 @@ struct iwl3945_scan_power_info {
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
 
-/* Channel unlock period is 15 seconds. If no beacon or probe response
- * has been received within 15 seconds on a locked channel then the channel
- * remains locked. */
-#define TX_UNLOCK_PERIOD 15
-
-/* CSA lock period is 15 seconds.  If a CSA has been received on a channel in
- * the last 15 seconds, the channel is locked */
-#define CSA_LOCK_PERIOD 15
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
@@ -560,19 +552,6 @@ struct iwl3945_driver_hw_info {
 	dma_addr_t shared_phys;
 };
 
-
-#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
-#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
-#define STA_FLG_MAX_AGG_SIZE_POS	(19)
-#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
-#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
-#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
-#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
-#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
-#define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
-#define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
-
-
 #define IWL_RX_HDR(x) ((struct iwl3945_rx_frame_hdr *)(\
 		       x->u.rx_frame.stats.payload + \
 		       x->u.rx_frame.stats.phy_count))
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 575a065..bd55709 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -515,6 +515,14 @@ struct iwl4965_qosparam_cmd {
 #define	IWL_INVALID_STATION 	255
 
 #define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
+#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
+#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
+#define STA_FLG_MAX_AGG_SIZE_POS	(19)
+#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
+#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
+#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
+#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
+#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
 
 #define STA_CONTROL_MODIFY_MSK		0x01
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 321767f..9438c63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -192,14 +192,6 @@ struct iwl4965_scan_power_info {
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
 
-/* Channel unlock period is 15 seconds. If no beacon or probe response
- * has been received within 15 seconds on a locked channel then the channel
- * remains locked. */
-#define TX_UNLOCK_PERIOD 15
-
-/* CSA lock period is 15 seconds.  If a CSA has been received on a channel in
- * the last 15 seconds, the channel is locked */
-#define CSA_LOCK_PERIOD 15
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
@@ -620,15 +612,6 @@ struct iwl4965_driver_hw_info {
 	dma_addr_t shared_phys;
 };
 
-
-#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
-#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
-#define STA_FLG_MAX_AGG_SIZE_POS	(19)
-#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
-#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
-#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
-#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
-#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
 #define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
 #define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
 
@@ -860,17 +843,8 @@ struct iwl4965_kw {
 #define NRG_NUM_PREV_STAT_L     20
 #define NUM_RX_CHAINS           (3)
 
-#define TX_POWER_IWL_ILLEGAL_VDET    -100000
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
-#define TX_POWER_IWL_CLOSED_LOOP_MIN_POWER 18
-#define TX_POWER_IWL_CLOSED_LOOP_MAX_POWER 34
-#define TX_POWER_IWL_VDET_SLOPE_BELOW_NOMINAL 17
-#define TX_POWER_IWL_VDET_SLOPE_ABOVE_NOMINAL 20
-#define TX_POWER_IWL_NOMINAL_POWER            26
-#define TX_POWER_IWL_CLOSED_LOOP_ITERATION_LIMIT 1
 #define TX_POWER_IWL_VOLTAGE_CODES_PER_03V       7
-#define TX_POWER_IWL_DEGREES_PER_VDET_CODE       11
-#define IWL_TX_POWER_MAX_NUM_PA_MEASUREMENTS 1
 #define IWL_TX_POWER_CCK_COMPENSATION_B_STEP (9)
 #define IWL_TX_POWER_CCK_COMPENSATION_C_STEP (5)
 
-- 
1.5.3.6
