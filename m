Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0HRQSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/16] iwlwifi: more generic name for rssi calc in iwlagn
Date: Wed, 18 Aug 2010 09:22:47 -0700
Message-Id: <1282148571-9258-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the define to more generic naming to match _agn devices
since the rssi calculation are common function for 5000 series and up

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   21 +++++++++-------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   33 ++++++++++++++------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 75b901b..8493976 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -235,13 +235,13 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 	/* data from PHY/DSP regarding signal strength, etc.,
 	 *   contents are always there, not configurable by host
 	 */
-	struct iwl5000_non_cfg_phy *ncphy =
-		(struct iwl5000_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
+	struct iwlagn_non_cfg_phy *ncphy =
+		(struct iwlagn_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
 	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
 	u8 agc;
 
-	val  = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_AGC_IDX]);
-	agc = (val & IWL50_OFDM_AGC_MSK) >> IWL50_OFDM_AGC_BIT_POS;
+	val  = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_AGC_IDX]);
+	agc = (val & IWLAGN_OFDM_AGC_MSK) >> IWLAGN_OFDM_AGC_BIT_POS;
 
 	/* Find max rssi among 3 possible receivers.
 	 * These values are measured by the digital signal processor (DSP).
@@ -249,11 +249,14 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 	 *   if the radio's automatic gain control (AGC) is working right.
 	 * AGC value (see below) will provide the "interesting" info.
 	 */
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_AB_IDX]);
-	rssi_a = (val & IWL50_OFDM_RSSI_A_MSK) >> IWL50_OFDM_RSSI_A_BIT_POS;
-	rssi_b = (val & IWL50_OFDM_RSSI_B_MSK) >> IWL50_OFDM_RSSI_B_BIT_POS;
-	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_C_IDX]);
-	rssi_c = (val & IWL50_OFDM_RSSI_C_MSK) >> IWL50_OFDM_RSSI_C_BIT_POS;
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_AB_IDX]);
+	rssi_a = (val & IWLAGN_OFDM_RSSI_INBAND_A_BITMSK) >>
+		IWLAGN_OFDM_RSSI_A_BIT_POS;
+	rssi_b = (val & IWLAGN_OFDM_RSSI_INBAND_B_BITMSK) >>
+		IWLAGN_OFDM_RSSI_B_BIT_POS;
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWLAGN_RX_RES_RSSI_C_IDX]);
+	rssi_c = (val & IWLAGN_OFDM_RSSI_INBAND_C_BITMSK) >>
+		IWLAGN_OFDM_RSSI_C_BIT_POS;
 
 	max_rssi = max_t(u32, rssi_a, rssi_b);
 	max_rssi = max_t(u32, max_rssi, rssi_c);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 13893a0..4083e44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1367,21 +1367,24 @@ struct iwl4965_rx_non_cfg_phy {
 } __packed;
 
 
-#define IWL50_RX_RES_PHY_CNT 8
-#define IWL50_RX_RES_AGC_IDX     1
-#define IWL50_RX_RES_RSSI_AB_IDX 2
-#define IWL50_RX_RES_RSSI_C_IDX  3
-#define IWL50_OFDM_AGC_MSK 0xfe00
-#define IWL50_OFDM_AGC_BIT_POS 9
-#define IWL50_OFDM_RSSI_A_MSK 0x00ff
-#define IWL50_OFDM_RSSI_A_BIT_POS 0
-#define IWL50_OFDM_RSSI_B_MSK 0xff0000
-#define IWL50_OFDM_RSSI_B_BIT_POS 16
-#define IWL50_OFDM_RSSI_C_MSK 0x00ff
-#define IWL50_OFDM_RSSI_C_BIT_POS 0
-
-struct iwl5000_non_cfg_phy {
-	__le32 non_cfg_phy[IWL50_RX_RES_PHY_CNT];  /* up to 8 phy entries */
+#define IWLAGN_RX_RES_PHY_CNT 8
+#define IWLAGN_RX_RES_AGC_IDX     1
+#define IWLAGN_RX_RES_RSSI_AB_IDX 2
+#define IWLAGN_RX_RES_RSSI_C_IDX  3
+#define IWLAGN_OFDM_AGC_MSK 0xfe00
+#define IWLAGN_OFDM_AGC_BIT_POS 9
+#define IWLAGN_OFDM_RSSI_INBAND_A_BITMSK 0x00ff
+#define IWLAGN_OFDM_RSSI_ALLBAND_A_BITMSK 0xff00
+#define IWLAGN_OFDM_RSSI_A_BIT_POS 0
+#define IWLAGN_OFDM_RSSI_INBAND_B_BITMSK 0xff0000
+#define IWLAGN_OFDM_RSSI_ALLBAND_B_BITMSK 0xff000000
+#define IWLAGN_OFDM_RSSI_B_BIT_POS 16
+#define IWLAGN_OFDM_RSSI_INBAND_C_BITMSK 0x00ff
+#define IWLAGN_OFDM_RSSI_ALLBAND_C_BITMSK 0xff00
+#define IWLAGN_OFDM_RSSI_C_BIT_POS 0
+
+struct iwlagn_non_cfg_phy {
+	__le32 non_cfg_phy[IWLAGN_RX_RES_PHY_CNT];  /* up to 8 phy entries */
 } __packed;
 
 
-- 
1.7.0.4

