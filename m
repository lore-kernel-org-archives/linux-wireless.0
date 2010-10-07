Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab0JGXIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/22] iwlwifi: remove apm_ops.stop
Date: Thu,  7 Oct 2010 16:07:55 -0700
Message-Id: <1286492881-15743-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since all devices share the same operation here,
there's no need to call it indirectly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 10 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5bdfe9d..db54091 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -194,7 +194,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl1000_nic_config,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 824c942..b06a7bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2704,7 +2704,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.dump_nic_error_log = iwl3945_dump_nic_error_log,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl3945_nic_config,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cda4a31..28ba563 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2266,7 +2266,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.set_channel_switch = iwl4965_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl4965_nic_config,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c90a16c..fd9fbc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -368,7 +368,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 	},
 	.eeprom_ops = {
@@ -437,7 +436,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 02103a7..a45929e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -308,7 +308,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
 	},
 	.eeprom_ops = {
@@ -380,7 +379,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
 	},
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 75472a3..b1af79e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2983,7 +2983,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
@@ -4597,7 +4597,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	 * paths to avoid running iwl_down() at all before leaving driver.
 	 * This (inexpensive) call *makes sure* device is reset.
 	 */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 
 	iwl_tt_exit(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5cd16a7..b3efbe0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2599,7 +2599,7 @@ int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	 * it will not call apm_ops.stop() to stop the DMA operation.
 	 * Calling apm_ops.stop here to make sure we stop the DMA.
 	 */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ae77279..c01262c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -117,7 +117,6 @@ struct iwl_hcmd_utils_ops {
 
 struct iwl_apm_ops {
 	int (*init)(struct iwl_priv *priv);
-	void (*stop)(struct iwl_priv *priv);
 	void (*config)(struct iwl_priv *priv);
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index bd51b06..66eccb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -603,7 +603,7 @@ err:
 	if (ret)
 		iwl_eeprom_free(priv);
 	/* Reset chip to save power until we load uCode during "up". */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 alloc_err:
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c06b218..980c609 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2637,7 +2637,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	udelay(5);
 
 	/* Stop the device, and put it in low power state */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
@@ -4212,7 +4212,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	 * paths to avoid running iwl_down() at all before leaving driver.
 	 * This (inexpensive) call *makes sure* device is reset.
 	 */
-	priv->cfg->ops->lib->apm_ops.stop(priv);
+	iwl_apm_stop(priv);
 
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
-- 
1.7.0.4

