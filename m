Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48838 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaFXTwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:42 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so1252372wiw.5
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:40 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/27] iwlwifi: mvm: fixes for 8000 NVM flow
Date: Tue, 24 Jun 2014 22:52:03 +0300
Message-Id: <1403639541-4621-9-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_863376_838E1FC1)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The nvm_file should be loaded by default for SDIO
procucts only. Change the configuration accordingly.
While at it, fix a typo in the device name.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 3 +--
 drivers/net/wireless/iwlwifi/iwl-config.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 0a1bb5f..51486cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -119,10 +119,9 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
-	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
 };
 
-const struct iwl_cfg iwl8260_n_cfg = {
+const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.name = "Intel(R) Dual Band Wireless-AC 8260",
 	.fw_name_pre = IWL8000_FW_PRE,
 	IWL_DEVICE_8000,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index b7047905..034c2fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -337,7 +337,7 @@ extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
-extern const struct iwl_cfg iwl8260_n_cfg;
+extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
1.8.3.2

