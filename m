Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbXJYJW3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/30] iwlwifi: rename iwl_eeprom_aqcuire_semaphore to _acquire_
Date: Thu, 25 Oct 2007 17:15:23 +0800
Message-Id: <11933037541699-git-send-email-yi.zhu@intel.com> (sfid-20071025_102236_260654_9CCA445B)
In-Reply-To: <11933037512140-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

Correct the spelling of aqcuire.

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a38f196..cc0a385 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2282,7 +2282,7 @@ struct pci_device_id iwl_hw_card_ids[] = {
 	{0}
 };
 
-inline int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
+inline int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
 {
 	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 813902e..2bc5e9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -30,7 +30,7 @@
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
-extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
+extern int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv);
 extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index efb1162..6a0e688 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4687,7 +4687,7 @@ struct pci_device_id iwl_hw_card_ids[] = {
 	{0}
 };
 
-int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
+int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
 {
 	u16 count;
 	int rc;
@@ -4700,7 +4700,7 @@ int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
 					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 					EEPROM_SEM_TIMEOUT);
 		if (rc >= 0) {
-			IWL_DEBUG_IO("Aqcuired semaphore after %d tries.\n",
+			IWL_DEBUG_IO("Acquired semaphore after %d tries.\n",
 				count+1);
 			return rc;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 4c70081..b31a7e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -32,7 +32,7 @@ struct sta_ht_info;
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
-extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
+extern int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv);
 extern void iwl_eeprom_release_semaphore(struct iwl_priv *priv);
 
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d0918f3..370c0f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1551,9 +1551,9 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		return -ENOENT;
 	}
 
-	rc = iwl_eeprom_aqcuire_semaphore(priv);
+	rc = iwl_eeprom_acquire_semaphore(priv);
 	if (rc < 0) {
-		IWL_ERROR("Failed to aqcuire EEPROM semaphore.\n");
+		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
 		return -ENOENT;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 850ba1f..1258ccd 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1600,9 +1600,9 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		return -ENOENT;
 	}
 
-	rc = iwl_eeprom_aqcuire_semaphore(priv);
+	rc = iwl_eeprom_acquire_semaphore(priv);
 	if (rc < 0) {
-		IWL_ERROR("Failed to aqcuire EEPROM semaphore.\n");
+		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
 		return -ENOENT;
 	}
 
-- 
1.5.2
