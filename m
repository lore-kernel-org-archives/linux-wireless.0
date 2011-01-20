Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17829 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1ATQT1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 11:19:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6.38] iwlwifi: don't read sku information from EEPROM for 4965
Date: Thu, 20 Jan 2011 08:08:04 -0800
Message-Id: <1295539684-19682-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For all the new devices, the sku information should read from EEPROM
but for legacy devices such as 4965, appearly the EEPROM does not
contain the necessary information. so skip the read from EEPROM
and go back to use software configuration.

Reported-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3f1e5f1..91a9f52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2624,6 +2624,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 14ceb4d..27b5a3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -152,11 +152,14 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 
-	priv->cfg->sku = ((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
+	if (!priv->cfg->sku) {
+		/* not using sku overwrite */
+		priv->cfg->sku =
+			((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
 			EEPROM_SKU_CAP_BAND_POS);
-	if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
-		priv->cfg->sku |= IWL_SKU_N;
-
+		if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
+			priv->cfg->sku |= IWL_SKU_N;
+	}
 	if (!priv->cfg->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
-- 
1.7.0.4

