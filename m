Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZIANMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:54 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 7/9] iwmc3200wifi: New initial LMAC calibration
Date: Tue,  1 Sep 2009 15:14:04 +0200
Message-Id: <e8d5aebbcfa2f5d4430bbee3850bd11e34808088.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <0b1215c4ea3f375a932030fe94fd97e47df4b4eb.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
 <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
 <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
 <0b1215c4ea3f375a932030fe94fd97e47df4b4eb.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LMAC calibration API got broken mostly by having a configuration bitmap
being different than the result one.
This patch tries to address that issue by correctly running calibrations with
the newest firmwares, and keeping a backward compatibility fallback path for
older firmwares, where the configuration and result bitmaps were identical.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/fw.c   |   56 +++++++++++++++++++++---------
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    1 +
 drivers/net/wireless/iwmc3200wifi/lmac.h |   15 ++++++++
 drivers/net/wireless/iwmc3200wifi/main.c |    7 +++-
 4 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index 0f32cab..6b0bcad 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -261,6 +261,33 @@ static int iwm_load_lmac(struct iwm_priv *iwm, const char *img_name)
 			cpu_to_le32(UMAC_RST_CTRL_FLG_LARC_CLK_EN), 0);
 }
 
+static int iwm_init_calib(struct iwm_priv *iwm, unsigned long cfg_bitmap,
+			  unsigned long expected_bitmap, u8 rx_iq_cmd)
+{
+	/* Read RX IQ calibration result from EEPROM */
+	if (test_bit(rx_iq_cmd, &cfg_bitmap)) {
+		iwm_store_rxiq_calib_result(iwm);
+		set_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->calib_done_map);
+	}
+
+	iwm_send_prio_table(iwm);
+	iwm_send_init_calib_cfg(iwm, cfg_bitmap);
+
+	while (iwm->calib_done_map != expected_bitmap) {
+		if (iwm_notif_handle(iwm, CALIBRATION_RES_NOTIFICATION,
+				     IWM_SRC_LMAC, WAIT_NOTIF_TIMEOUT)) {
+			IWM_DBG_FW(iwm, DBG, "Initial calibration timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		IWM_DBG_FW(iwm, DBG, "Got calibration result. calib_done_map: "
+			   "0x%lx, expected calibrations: 0x%lx\n",
+			   iwm->calib_done_map, expected_bitmap);
+	}
+
+	return 0;
+}
+
 /*
  * We currently have to load 3 FWs:
  * 1) The UMAC (Upper MAC).
@@ -276,6 +303,7 @@ static int iwm_load_lmac(struct iwm_priv *iwm, const char *img_name)
 int iwm_load_fw(struct iwm_priv *iwm)
 {
 	unsigned long init_calib_map, periodic_calib_map;
+	unsigned long expected_calib_map;
 	int ret;
 
 	/* We first start downloading the UMAC */
@@ -317,27 +345,21 @@ int iwm_load_fw(struct iwm_priv *iwm)
 	}
 
 	init_calib_map = iwm->conf.calib_map & IWM_CALIB_MAP_INIT_MSK;
+	expected_calib_map = iwm->conf.expected_calib_map &
+		IWM_CALIB_MAP_INIT_MSK;
 	periodic_calib_map = IWM_CALIB_MAP_PER_LMAC(iwm->conf.calib_map);
 
-	/* Read RX IQ calibration result from EEPROM */
-	if (test_bit(PHY_CALIBRATE_RX_IQ_CMD, &init_calib_map)) {
-		iwm_store_rxiq_calib_result(iwm);
-		set_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->calib_done_map);
-	}
-
-	iwm_send_prio_table(iwm);
-	iwm_send_init_calib_cfg(iwm, init_calib_map);
-
-	while (iwm->calib_done_map != init_calib_map) {
-		ret = iwm_notif_handle(iwm, CALIBRATION_RES_NOTIFICATION,
-				       IWM_SRC_LMAC, WAIT_NOTIF_TIMEOUT);
-		if (ret) {
-			IWM_ERR(iwm, "Wait for calibration result timeout\n");
+	ret = iwm_init_calib(iwm, init_calib_map, expected_calib_map,
+			     CALIB_CFG_RX_IQ_IDX);
+	if (ret < 0) {
+		/* Let's try the old way */
+		ret = iwm_init_calib(iwm, expected_calib_map,
+				     expected_calib_map,
+				     PHY_CALIBRATE_RX_IQ_CMD);
+		if (ret < 0) {
+			IWM_ERR(iwm, "Calibration result timeout\n");
 			goto out;
 		}
-		IWM_DBG_FW(iwm, DBG, "Got calibration result. calib_done_map: "
-			   "0x%lx, requested calibrations: 0x%lx\n",
-			   iwm->calib_done_map, init_calib_map);
 	}
 
 	/* Handle LMAC CALIBRATION_COMPLETE notification */
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index da49df6..74964ee 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -64,6 +64,7 @@
 struct iwm_conf {
 	u32 sdio_ior_timeout;
 	unsigned long calib_map;
+	unsigned long expected_calib_map;
 	bool reset_on_fatal_err;
 	bool auto_connect;
 	bool wimax_not_present;
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
index 19213e1..6c1a14c 100644
--- a/drivers/net/wireless/iwmc3200wifi/lmac.h
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -396,9 +396,24 @@ enum {
 	CALIBRATION_CMD_NUM,
 };
 
+enum {
+	CALIB_CFG_RX_BB_IDX       = 0,
+	CALIB_CFG_DC_IDX          = 1,
+	CALIB_CFG_LO_IDX          = 2,
+	CALIB_CFG_TX_IQ_IDX       = 3,
+	CALIB_CFG_RX_IQ_IDX       = 4,
+	CALIB_CFG_NOISE_IDX       = 5,
+	CALIB_CFG_CRYSTAL_IDX     = 6,
+	CALIB_CFG_TEMPERATURE_IDX = 7,
+	CALIB_CFG_PAPD_IDX        = 8,
+	CALIB_CFG_LAST_IDX        = CALIB_CFG_PAPD_IDX,
+	CALIB_CFG_MODULE_NUM,
+};
+
 #define IWM_CALIB_MAP_INIT_MSK		0xFFFF
 #define IWM_CALIB_MAP_PER_LMAC(m)	((m & 0xFF0000) >> 16)
 #define IWM_CALIB_MAP_PER_UMAC(m)	((m & 0xFF000000) >> 24)
+#define IWM_CALIB_OPCODE_TO_INDEX(op)   (op - PHY_CALIBRATE_OPCODES_NUM)
 
 struct iwm_lmac_calib_hdr {
 	u8 opcode;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 6cf2f0c..fc7fce4 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -53,7 +53,12 @@
 static struct iwm_conf def_iwm_conf = {
 
 	.sdio_ior_timeout	= 5000,
-	.calib_map		= BIT(PHY_CALIBRATE_DC_CMD)	|
+	.calib_map		= BIT(CALIB_CFG_DC_IDX)	|
+				  BIT(CALIB_CFG_LO_IDX)	|
+				  BIT(CALIB_CFG_TX_IQ_IDX)	|
+				  BIT(CALIB_CFG_RX_IQ_IDX)	|
+				  BIT(SHILOH_PHY_CALIBRATE_BASE_BAND_CMD),
+	.expected_calib_map	= BIT(PHY_CALIBRATE_DC_CMD)	|
 				  BIT(PHY_CALIBRATE_LO_CMD)	|
 				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
 				  BIT(PHY_CALIBRATE_RX_IQ_CMD)	|
-- 
1.6.3.3

