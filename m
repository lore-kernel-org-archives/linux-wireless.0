Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYKSXb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: 4965 define firmware file name once
Date: Wed, 19 Nov 2008 15:32:25 -0800
Message-Id: <1227137548-28718-5-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003215_519514_602454DD)
In-Reply-To: <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

Apply same idiom as in 5000 introduced by
'iwlwifi: define firmware file name once'

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9007ff2..b96f553 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -53,6 +53,7 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
  *   is not compatible with earlier drivers.
  * This number will also appear in << 8 position of 1st dword of uCode file */
 #define IWL4965_UCODE_API "-2"
+#define IWL4965_MODULE_FIRMWARE "iwlwifi-4965" IWL4965_UCODE_API ".ucode"
 
 
 /* module parameters */
@@ -2322,7 +2323,7 @@ static struct iwl_ops iwl4965_ops = {
 
 struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
-	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
+	.fw_name = IWL4965_MODULE_FIRMWARE,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
@@ -2332,7 +2333,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 };
 
 /* Module firmware */
-MODULE_FIRMWARE("iwlwifi-4965" IWL4965_UCODE_API ".ucode");
+MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE);
 
 module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-- 
1.5.4.3

