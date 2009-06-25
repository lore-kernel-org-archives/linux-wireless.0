Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11404 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZFYK2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 06:28:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/4] iwmc3200wifi: simplify calibration map
Date: Thu, 25 Jun 2009 18:28:31 +0800
Message-Id: <1245925713-14908-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1245925713-14908-2-git-send-email-yi.zhu@intel.com>
References: <1245925713-14908-1-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch simplifies calibration map by combining the init_calib_map
and periodic_calib_map into one calib_map in struct iwm_conf. Now the
initial calibration map is stored in the lower 16 bits of calib_map
and the periodic calibration map is stored in the higher 16 bits.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/fw.c   |   19 +++++++++++--------
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    3 +--
 drivers/net/wireless/iwmc3200wifi/lmac.h |    4 ++++
 drivers/net/wireless/iwmc3200wifi/main.c |    6 +-----
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index ec1a15a..c58f614 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -275,6 +275,7 @@ static int iwm_load_lmac(struct iwm_priv *iwm, const char *img_name)
  */
 int iwm_load_fw(struct iwm_priv *iwm)
 {
+	unsigned long init_calib_map, periodic_calib_map;
 	int ret;
 
 	/* We first start downloading the UMAC */
@@ -315,23 +316,25 @@ int iwm_load_fw(struct iwm_priv *iwm)
 		return ret;
 	}
 
+	init_calib_map = iwm->conf.calib_map & IWM_CALIB_MAP_INIT_MSK;
+	periodic_calib_map = IWM_CALIB_MAP_PER_LMAC(iwm->conf.calib_map);
+
 #ifdef CONFIG_IWM_B0_HW_SUPPORT
 	if (iwm->conf.hw_b0) {
-		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->conf.init_calib_map);
-		clear_bit(PHY_CALIBRATE_RX_IQ_CMD,
-			  &iwm->conf.periodic_calib_map);
+		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &init_calib_map);
+		clear_bit(PHY_CALIBRATE_RX_IQ_CMD, &periodic_calib_map);
 	}
 #endif
 	/* Read RX IQ calibration result from EEPROM */
-	if (test_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->conf.init_calib_map)) {
+	if (test_bit(PHY_CALIBRATE_RX_IQ_CMD, &init_calib_map)) {
 		iwm_store_rxiq_calib_result(iwm);
 		set_bit(PHY_CALIBRATE_RX_IQ_CMD, &iwm->calib_done_map);
 	}
 
 	iwm_send_prio_table(iwm);
-	iwm_send_init_calib_cfg(iwm, iwm->conf.init_calib_map);
+	iwm_send_init_calib_cfg(iwm, init_calib_map);
 
-	while (iwm->calib_done_map != iwm->conf.init_calib_map) {
+	while (iwm->calib_done_map != init_calib_map) {
 		ret = iwm_notif_handle(iwm, CALIBRATION_RES_NOTIFICATION,
 				       IWM_SRC_LMAC, WAIT_NOTIF_TIMEOUT);
 		if (ret) {
@@ -340,7 +343,7 @@ int iwm_load_fw(struct iwm_priv *iwm)
 		}
 		IWM_DBG_FW(iwm, DBG, "Got calibration result. calib_done_map: "
 			   "0x%lx, requested calibrations: 0x%lx\n",
-			   iwm->calib_done_map, iwm->conf.init_calib_map);
+			   iwm->calib_done_map, init_calib_map);
 	}
 
 	/* Handle LMAC CALIBRATION_COMPLETE notification */
@@ -378,7 +381,7 @@ int iwm_load_fw(struct iwm_priv *iwm)
 
 	iwm_send_prio_table(iwm);
 	iwm_send_calib_results(iwm);
-	iwm_send_periodic_calib_cfg(iwm, iwm->conf.periodic_calib_map);
+	iwm_send_periodic_calib_cfg(iwm, periodic_calib_map);
 
 	return 0;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 4da57f7..1bad78f 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -65,8 +65,7 @@
 
 struct iwm_conf {
 	u32 sdio_ior_timeout;
-	unsigned long init_calib_map;
-	unsigned long periodic_calib_map;
+	unsigned long calib_map;
 	bool reset_on_fatal_err;
 	bool auto_connect;
 	bool wimax_not_present;
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
index db2e5ee..19213e1 100644
--- a/drivers/net/wireless/iwmc3200wifi/lmac.h
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -396,6 +396,10 @@ enum {
 	CALIBRATION_CMD_NUM,
 };
 
+#define IWM_CALIB_MAP_INIT_MSK		0xFFFF
+#define IWM_CALIB_MAP_PER_LMAC(m)	((m & 0xFF0000) >> 16)
+#define IWM_CALIB_MAP_PER_UMAC(m)	((m & 0xFF000000) >> 24)
+
 struct iwm_lmac_calib_hdr {
 	u8 opcode;
 	u8 first_grp;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 930056b..4fedb45 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -53,11 +53,7 @@
 static struct iwm_conf def_iwm_conf = {
 
 	.sdio_ior_timeout	= 5000,
-	.init_calib_map		= BIT(PHY_CALIBRATE_DC_CMD)	|
-				  BIT(PHY_CALIBRATE_LO_CMD)	|
-				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
-				  BIT(PHY_CALIBRATE_RX_IQ_CMD),
-	.periodic_calib_map	= BIT(PHY_CALIBRATE_DC_CMD)	|
+	.calib_map		= BIT(PHY_CALIBRATE_DC_CMD)	|
 				  BIT(PHY_CALIBRATE_LO_CMD)	|
 				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
 				  BIT(PHY_CALIBRATE_RX_IQ_CMD)	|
-- 
1.6.0.4

