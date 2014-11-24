Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58622 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaKXOfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:50 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so12771854wgh.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/75] iwlwifi: pcie: support 7265-D devices
Date: Mon, 24 Nov 2014 16:34:08 +0200
Message-Id: <1416839691-28533-32-git-send-email-egrumbach@gmail.com> (sfid-20141124_154059_827438_27066C47)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Identify 7265-D devices using the hardware revision (they have the
same PCI IDs as 7265) and change the configuration for them taking
the differences (currently only the firmware image) into account.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 34 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  3 +++
 drivers/net/wireless/iwlwifi/iwl-csr.h    | 35 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/pcie/drv.c   | 20 ++++++++++++++++++
 4 files changed, 75 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index b4e9bc7..84d2a42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -102,6 +102,9 @@
 #define IWL7265_FW_PRE "iwlwifi-7265-"
 #define IWL7265_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
 
+#define IWL7265D_FW_PRE "iwlwifi-7265D-"
+#define IWL7265D_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
+
 #define NVM_HW_SECTION_NUM_FAMILY_7000		0
 
 static const struct iwl_base_params iwl7000_base_params = {
@@ -267,7 +270,38 @@ const struct iwl_cfg iwl7265_n_cfg = {
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 };
 
+const struct iwl_cfg iwl7265d_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 7265",
+	.fw_name_pre = IWL7265D_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7265_ht_params,
+	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+};
+
+const struct iwl_cfg iwl7265d_2n_cfg = {
+	.name = "Intel(R) Dual Band Wireless N 7265",
+	.fw_name_pre = IWL7265D_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7265_ht_params,
+	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+};
+
+const struct iwl_cfg iwl7265d_n_cfg = {
+	.name = "Intel(R) Wireless N 7265",
+	.fw_name_pre = IWL7265D_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7265_ht_params,
+	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+};
+
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3165_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index c6ae4d4e..d43e90d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -364,6 +364,9 @@ extern const struct iwl_cfg iwl3165_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
+extern const struct iwl_cfg iwl7265d_2ac_cfg;
+extern const struct iwl_cfg iwl7265d_2n_cfg;
+extern const struct iwl_cfg iwl7265d_n_cfg;
 extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 9965717..aff63c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -309,23 +309,24 @@ enum {
 };
 
 
-#define CSR_HW_REV_TYPE_MSK            (0x000FFF0)
-#define CSR_HW_REV_TYPE_5300           (0x0000020)
-#define CSR_HW_REV_TYPE_5350           (0x0000030)
-#define CSR_HW_REV_TYPE_5100           (0x0000050)
-#define CSR_HW_REV_TYPE_5150           (0x0000040)
-#define CSR_HW_REV_TYPE_1000           (0x0000060)
-#define CSR_HW_REV_TYPE_6x00           (0x0000070)
-#define CSR_HW_REV_TYPE_6x50           (0x0000080)
-#define CSR_HW_REV_TYPE_6150           (0x0000084)
-#define CSR_HW_REV_TYPE_6x05	       (0x00000B0)
-#define CSR_HW_REV_TYPE_6x30	       CSR_HW_REV_TYPE_6x05
-#define CSR_HW_REV_TYPE_6x35	       CSR_HW_REV_TYPE_6x05
-#define CSR_HW_REV_TYPE_2x30	       (0x00000C0)
-#define CSR_HW_REV_TYPE_2x00	       (0x0000100)
-#define CSR_HW_REV_TYPE_105	       (0x0000110)
-#define CSR_HW_REV_TYPE_135	       (0x0000120)
-#define CSR_HW_REV_TYPE_NONE           (0x00001F0)
+#define CSR_HW_REV_TYPE_MSK		(0x000FFF0)
+#define CSR_HW_REV_TYPE_5300		(0x0000020)
+#define CSR_HW_REV_TYPE_5350		(0x0000030)
+#define CSR_HW_REV_TYPE_5100		(0x0000050)
+#define CSR_HW_REV_TYPE_5150		(0x0000040)
+#define CSR_HW_REV_TYPE_1000		(0x0000060)
+#define CSR_HW_REV_TYPE_6x00		(0x0000070)
+#define CSR_HW_REV_TYPE_6x50		(0x0000080)
+#define CSR_HW_REV_TYPE_6150		(0x0000084)
+#define CSR_HW_REV_TYPE_6x05		(0x00000B0)
+#define CSR_HW_REV_TYPE_6x30		CSR_HW_REV_TYPE_6x05
+#define CSR_HW_REV_TYPE_6x35		CSR_HW_REV_TYPE_6x05
+#define CSR_HW_REV_TYPE_2x30		(0x00000C0)
+#define CSR_HW_REV_TYPE_2x00		(0x0000100)
+#define CSR_HW_REV_TYPE_105		(0x0000110)
+#define CSR_HW_REV_TYPE_135		(0x0000120)
+#define CSR_HW_REV_TYPE_7265D		(0x0000210)
+#define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 6ced854..3ee8e38 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -499,6 +499,7 @@ static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev) {}
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	const struct iwl_cfg *cfg_7265d __maybe_unused = NULL;
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
 	int ret;
@@ -507,6 +508,25 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (IS_ERR(iwl_trans))
 		return PTR_ERR(iwl_trans);
 
+#if IS_ENABLED(CONFIG_IWLMVM)
+	/*
+	 * special-case 7265D, it has the same PCI IDs.
+	 *
+	 * Note that because we already pass the cfg to the transport above,
+	 * all the parameters that the transport uses must, until that is
+	 * changed, be identical to the ones in the 7265D configuration.
+	 */
+	if (cfg == &iwl7265_2ac_cfg)
+		cfg_7265d = &iwl7265d_2ac_cfg;
+	else if (cfg == &iwl7265_2n_cfg)
+		cfg_7265d = &iwl7265d_2n_cfg;
+	else if (cfg == &iwl7265_n_cfg)
+		cfg_7265d = &iwl7265d_n_cfg;
+	if (cfg_7265d &&
+	    (iwl_trans->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_7265D)
+		cfg = cfg_7265d;
+#endif
+
 	pci_set_drvdata(pdev, iwl_trans);
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-- 
1.9.1

