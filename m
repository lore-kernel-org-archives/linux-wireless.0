Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3CDOA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/11] iwlwifi: mvm: update the rssi calculation
Date: Mon,  4 Mar 2013 15:00:50 +0100
Message-Id: <1362405651-26456-10-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150129_506947_2CBF2C62)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Make the rssi more accurate by taking in count per-chain AGC
values. Without this, the RSSI reports inaccurate values.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 18 ++++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/rx.c     | 37 +++++++++++++++++++------------
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 23eebda..2adb61f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -762,18 +762,20 @@ struct iwl_phy_context_cmd {
 #define IWL_RX_INFO_PHY_CNT 8
 #define IWL_RX_INFO_AGC_IDX 1
 #define IWL_RX_INFO_RSSI_AB_IDX 2
-#define IWL_RX_INFO_RSSI_C_IDX 3
-#define IWL_OFDM_AGC_DB_MSK 0xfe00
-#define IWL_OFDM_AGC_DB_POS 9
+#define IWL_OFDM_AGC_A_MSK 0x0000007f
+#define IWL_OFDM_AGC_A_POS 0
+#define IWL_OFDM_AGC_B_MSK 0x00003f80
+#define IWL_OFDM_AGC_B_POS 7
+#define IWL_OFDM_AGC_CODE_MSK 0x3fe00000
+#define IWL_OFDM_AGC_CODE_POS 20
 #define IWL_OFDM_RSSI_INBAND_A_MSK 0x00ff
-#define IWL_OFDM_RSSI_ALLBAND_A_MSK 0xff00
 #define IWL_OFDM_RSSI_A_POS 0
+#define IWL_OFDM_RSSI_ALLBAND_A_MSK 0xff00
+#define IWL_OFDM_RSSI_ALLBAND_A_POS 8
 #define IWL_OFDM_RSSI_INBAND_B_MSK 0xff0000
-#define IWL_OFDM_RSSI_ALLBAND_B_MSK 0xff000000
 #define IWL_OFDM_RSSI_B_POS 16
-#define IWL_OFDM_RSSI_INBAND_C_MSK 0x00ff
-#define IWL_OFDM_RSSI_ALLBAND_C_MSK 0xff00
-#define IWL_OFDM_RSSI_C_POS 0
+#define IWL_OFDM_RSSI_ALLBAND_B_MSK 0xff000000
+#define IWL_OFDM_RSSI_ALLBAND_B_POS 24
 
 /**
  * struct iwl_rx_phy_info - phy info
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 537711b..bdae700 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -80,7 +80,8 @@
 
 #define IWL_INVALID_MAC80211_QUEUE	0xff
 #define IWL_MVM_MAX_ADDRESSES		2
-#define IWL_RSSI_OFFSET 44
+/* RSSI offset for WkP */
+#define IWL_RSSI_OFFSET 50
 
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 3f40ab0..b0b190d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -131,33 +131,42 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 			     struct iwl_rx_phy_info *phy_info)
 {
-	u32 rssi_a, rssi_b, rssi_c, max_rssi, agc_db;
+	int rssi_a, rssi_b, rssi_a_dbm, rssi_b_dbm, max_rssi_dbm;
+	int rssi_all_band_a, rssi_all_band_b;
+	u32 agc_a, agc_b, max_agc;
 	u32 val;
 
-	/* Find max rssi among 3 possible receivers.
+	/* Find max rssi among 2 possible receivers.
 	 * These values are measured by the Digital Signal Processor (DSP).
 	 * They should stay fairly constant even as the signal strength varies,
 	 * if the radio's Automatic Gain Control (AGC) is working right.
 	 * AGC value (see below) will provide the "interesting" info.
 	 */
+	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_AGC_IDX]);
+	agc_a = (val & IWL_OFDM_AGC_A_MSK) >> IWL_OFDM_AGC_A_POS;
+	agc_b = (val & IWL_OFDM_AGC_B_MSK) >> IWL_OFDM_AGC_B_POS;
+	max_agc = max_t(u32, agc_a, agc_b);
+
 	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_RSSI_AB_IDX]);
 	rssi_a = (val & IWL_OFDM_RSSI_INBAND_A_MSK) >> IWL_OFDM_RSSI_A_POS;
 	rssi_b = (val & IWL_OFDM_RSSI_INBAND_B_MSK) >> IWL_OFDM_RSSI_B_POS;
-	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_RSSI_C_IDX]);
-	rssi_c = (val & IWL_OFDM_RSSI_INBAND_C_MSK) >> IWL_OFDM_RSSI_C_POS;
-
-	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_AGC_IDX]);
-	agc_db = (val & IWL_OFDM_AGC_DB_MSK) >> IWL_OFDM_AGC_DB_POS;
+	rssi_all_band_a = (val & IWL_OFDM_RSSI_ALLBAND_A_MSK) >>
+				IWL_OFDM_RSSI_ALLBAND_A_POS;
+	rssi_all_band_b = (val & IWL_OFDM_RSSI_ALLBAND_B_MSK) >>
+				IWL_OFDM_RSSI_ALLBAND_B_POS;
 
-	max_rssi = max_t(u32, rssi_a, rssi_b);
-	max_rssi = max_t(u32, max_rssi, rssi_c);
+	/*
+	 * dBm = rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal.
+	 */
+	rssi_a_dbm = rssi_a - IWL_RSSI_OFFSET - agc_a;
+	rssi_b_dbm = rssi_b - IWL_RSSI_OFFSET - agc_b;
+	max_rssi_dbm = max_t(int, rssi_a_dbm, rssi_b_dbm);
 
-	IWL_DEBUG_STATS(mvm, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
-			rssi_a, rssi_b, rssi_c, max_rssi, agc_db);
+	IWL_DEBUG_STATS(mvm, "Rssi In A %d B %d Max %d AGCA %d AGCB %d\n",
+			rssi_a_dbm, rssi_b_dbm, max_rssi_dbm, agc_a, agc_b);
 
-	/* dBm = max_rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc_db - IWL_RSSI_OFFSET;
+	return max_rssi_dbm;
 }
 
 /*
-- 
1.8.0

