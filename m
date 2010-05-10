Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab0EJW20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/47] iwlwifi: move eeprom version printout to eeprom init
Date: Mon, 10 May 2010 15:27:51 -0700
Message-Id: <1273530498-11876-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It doesn't belong into firmware loading,
it should instead be printed after loading
the EEPROM.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7bcc8a3..70094bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1551,7 +1551,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver, build;
 	u32 inst_size, data_size, init_size, init_data_size, boot_size;
 	int err, hdr_size;
-	u16 eeprom_ver;
 	char buildstr[25];
 
 	if (!ucode_raw) {
@@ -1654,11 +1653,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		 IWL_UCODE_SERIAL(priv->ucode_ver),
 		 buildstr);
 
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	IWL_DEBUG_INFO(priv, "NVM Type: %s, version: 0x%x\n",
-		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-		       ? "OTP" : "EEPROM", eeprom_ver);
-
 	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
 	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index fd37152..a8dd2fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -589,9 +589,16 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
+
+	IWL_DEBUG_INFO(priv, "NVM Type: %s, version: 0x%x\n",
+		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+		       ? "OTP" : "EEPROM",
+		       iwl_eeprom_query16(priv, EEPROM_VERSION));
+
 	ret = 0;
 done:
 	priv->cfg->ops->lib->eeprom_ops.release_semaphore(priv);
+
 err:
 	if (ret)
 		iwl_eeprom_free(priv);
-- 
1.6.3.3

