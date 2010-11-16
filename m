Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0KPQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:44 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/18] iwlagn: use SKU information in the EEPROM
Date: Tue, 16 Nov 2010 08:01:49 -0800
Message-Id: <1289923311-14920-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EEPROM contain the SKU information for the device, use it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    4 ----
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c       |    7 -------
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   18 ------------------
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |   12 +++++++++++-
 7 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e881b08..3100a72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -278,7 +278,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
@@ -295,7 +294,6 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
@@ -311,7 +309,6 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
@@ -328,7 +325,6 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2ec868d..6788ceb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2624,7 +2624,6 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b147580..3ee0f7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -527,7 +527,6 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
@@ -544,7 +543,6 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
@@ -561,7 +559,6 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
@@ -577,7 +574,6 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
@@ -594,7 +590,6 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
@@ -611,7 +606,6 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
@@ -629,7 +623,6 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9f835ac..0cc66fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -556,7 +556,6 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -575,7 +574,6 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -593,7 +591,6 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -611,7 +608,6 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -633,7 +629,6 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -654,7 +649,6 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -676,7 +670,6 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -697,7 +690,6 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -719,7 +711,6 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -743,7 +734,6 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
@@ -761,7 +751,6 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
@@ -778,7 +767,6 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
@@ -795,7 +783,6 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.ops = &iwl6050_ops,
@@ -813,7 +800,6 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
@@ -831,7 +817,6 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
@@ -848,7 +833,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
@@ -866,7 +850,6 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
@@ -887,7 +870,6 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index a650bab..8a4d3ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -248,6 +248,27 @@ err:
 
 }
 
+int iwl_eeprom_check_sku(struct iwl_priv *priv)
+{
+	u16 eeprom_sku;
+
+	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
+
+	priv->cfg->sku = ((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
+			EEPROM_SKU_CAP_BAND_POS);
+	if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
+		priv->cfg->sku |= IWL_SKU_N;
+
+	if (!priv->cfg->sku) {
+		IWL_ERR(priv, "Invalid device sku\n");
+		return -EINVAL;
+	}
+
+	IWL_INFO(priv, "Device SKU: 0X%x\n", priv->cfg->sku);
+
+	return 0;
+}
+
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
 {
 	const u8 *addr = priv->cfg->ops->lib->eeprom_ops.query_addr(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d976912..59af06d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4134,6 +4134,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto out_free_eeprom;
 
+	err = iwl_eeprom_check_sku(priv);
+	if (err)
+		goto out_free_eeprom;
+
 	/* extract MAC Address */
 	iwl_eeprom_get_mac(priv, priv->addresses[0].addr);
 	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index d9b5906..e87be1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -110,9 +110,18 @@ enum {
 };
 
 /* SKU Capabilities */
+/* 3945 only */
 #define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
 #define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
 
+/* 5000 and up */
+#define EEPROM_SKU_CAP_BAND_POS				(4)
+#define EEPROM_SKU_CAP_BAND_SELECTION	                \
+		(3 << EEPROM_SKU_CAP_BAND_POS)
+#define EEPROM_SKU_CAP_11N_ENABLE	                (1 << 6)
+#define EEPROM_SKU_CAP_AMT_ENABLE	                (1 << 7)
+#define EEPROM_SKU_CAP_IPAN_ENABLE	                (1 << 8)
+
 /* *regulatory* channel data format in eeprom, one for each channel.
  * There are separate entries for HT40 (40 MHz) vs. normal (20 MHz) channels. */
 struct iwl_eeprom_channel {
@@ -397,7 +406,7 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
 #define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
 #define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
+#define EEPROM_SKU_CAP                      (2*0x45)	/* 2  bytes */
 #define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 #define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 #define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
@@ -504,6 +513,7 @@ struct iwl_eeprom_ops {
 int iwl_eeprom_init(struct iwl_priv *priv);
 void iwl_eeprom_free(struct iwl_priv *priv);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
+int  iwl_eeprom_check_sku(struct iwl_priv *priv);
 const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
 int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
-- 
1.7.0.4

