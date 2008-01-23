Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYAWSPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlwifi: cleanup usage of inline functions
Date: Wed, 23 Jan 2008 10:15:19 -0800
Message-Id: <1201112121-22340-5-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181531_742600_C11DC337)
In-Reply-To: <1201112121-22340-4-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-3-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Be consistent when using inline functions. If the function only used
once we move it to where it is used - no need for externs.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   14 --------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 -------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   14 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 ++++++
 6 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 76c4ed1..4fdeb53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2369,18 +2369,4 @@ struct pci_device_id iwl3945_hw_card_ids[] = {
 	{0}
 };
 
-/*
- * Clear the OWNER_MSK, to establish driver (instead of uCode running on
- * embedded controller) as EEPROM reader; each read is a series of pulses
- * to/from the EEPROM chip, not a single event, so even reads could conflict
- * if they weren't arbitrated by some ownership mechanism.  Here, the driver
- * simply claims ownership, which should be safe when this function is called
- * (i.e. before loading uCode!).
- */
-inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
-{
-	_iwl3945_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
-	return 0;
-}
-
 MODULE_DEVICE_TABLE(pci, iwl3945_hw_card_ids);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 20b925f..4b07db9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -671,7 +671,6 @@ extern int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel);
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
-extern int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv);
 extern __le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 04db34b..569347f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4961,11 +4961,4 @@ int iwl4965_eeprom_acquire_semaphore(struct iwl4965_priv *priv)
 	return rc;
 }
 
-inline void iwl4965_eeprom_release_semaphore(struct iwl4965_priv *priv)
-{
-	iwl4965_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-}
-
-
 MODULE_DEVICE_TABLE(pci, iwl4965_hw_card_ids);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 78bc148..9cb82be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -750,7 +750,6 @@ struct iwl4965_priv;
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
 extern int iwl4965_eeprom_acquire_semaphore(struct iwl4965_priv *priv);
-extern void iwl4965_eeprom_release_semaphore(struct iwl4965_priv *priv);
 
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 					  struct iwl4965_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5afc578..1e9e953 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1557,6 +1557,20 @@ static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
 	memcpy(mac, priv->eeprom.mac_address, 6);
 }
 
+/*
+ * Clear the OWNER_MSK, to establish driver (instead of uCode running on
+ * embedded controller) as EEPROM reader; each read is a series of pulses
+ * to/from the EEPROM chip, not a single event, so even reads could conflict
+ * if they weren't arbitrated by some ownership mechanism.  Here, the driver
+ * simply claims ownership, which should be safe when this function is called
+ * (i.e. before loading uCode!).
+ */
+static inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
+{
+	_iwl3945_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
+	return 0;
+}
+
 /**
  * iwl3945_eeprom_init - read EEPROM contents
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bb2d4f5..9f23c3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1639,6 +1639,12 @@ static void get_eeprom_mac(struct iwl4965_priv *priv, u8 *mac)
 	memcpy(mac, priv->eeprom.mac_address, 6);
 }
 
+static inline void iwl4965_eeprom_release_semaphore(struct iwl4965_priv *priv)
+{
+	iwl4965_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+}
+
 /**
  * iwl4965_eeprom_init - read EEPROM contents
  *
-- 
1.5.3.4

