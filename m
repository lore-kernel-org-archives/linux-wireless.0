Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49150 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbaKXOg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:56 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5842866wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 74/75] iwlwifi: sdio: new SDIO card id for 4165 series
Date: Mon, 24 Nov 2014 16:34:50 +0200
Message-Id: <1416839691-28533-74-git-send-email-egrumbach@gmail.com> (sfid-20141124_153707_814817_F10FB855)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new SDIO card id intended for the new 4165 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 436efad..d0357b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -159,4 +159,19 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
 };
 
+const struct iwl_cfg iwl4265_2ac_sdio_cfg = {
+	.name = "Intel(R) Dual Band Wireless-AC 4265",
+	.fw_name_pre = IWL8000_FW_PRE,
+	IWL_DEVICE_8000,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
+	.bt_shared_single_ant = true,
+	.disable_dummy_notification = true,
+	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
+	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
+};
+
 MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index d43e90d..e63cafa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -370,6 +370,7 @@ extern const struct iwl_cfg iwl7265d_n_cfg;
 extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
+extern const struct iwl_cfg iwl4265_2ac_sdio_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
1.9.1

