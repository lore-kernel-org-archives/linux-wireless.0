Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761650AbXG0J3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 09/17] iwlwifi: EEPROM reading fix
Date: Fri, 27 Jul 2007 17:26:33 +0800
Message-Id: <11855284183313-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284161716-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes EEPROM access. 4965 requires aquiring of EEPROM
semaphore. In addition the timeout on EEPROM read must be longer 10.
This version fixes CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM definition.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    6 ++++++
 drivers/net/wireless/iwl-3945.h |    1 +
 drivers/net/wireless/iwl-4965.c |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwl-4965.h |    8 ++++++++
 drivers/net/wireless/iwl-base.c |   23 +++++++++++++++--------
 drivers/net/wireless/iwl-hw.h   |    2 +-
 6 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index af136c8..6c42f53 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -2295,4 +2295,10 @@ struct pci_device_id iwl_hw_card_ids[] = {
 	{0}
 };
 
+inline int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
+{
+	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_OWNER);
+	return 0;
+}
+
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
diff --git a/drivers/net/wireless/iwl-3945.h b/drivers/net/wireless/iwl-3945.h
index 4f43702..d134a4b 100644
--- a/drivers/net/wireless/iwl-3945.h
+++ b/drivers/net/wireless/iwl-3945.h
@@ -47,6 +47,7 @@ static inline u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
+extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
 extern int iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 5586b4c..a333204 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -4763,4 +4763,33 @@ struct pci_device_id iwl_hw_card_ids[] = {
 	{0}
 };
 
+int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
+{
+	u16 count;
+	int rc;
+
+	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+		rc = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+					EEPROM_SEM_TIMEOUT);
+		if (rc >= 0) {
+			IWL_DEBUG_IO("Aqcuired semaphore after %d tries.\n",
+				count+1);
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+inline void iwl_eeprom_release_semaphore(struct iwl_priv *priv)
+{
+	iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+}
+
+
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index 1f832e7..9e4a663 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -34,6 +34,8 @@ struct sta_ht_info;
  * In non IWL == 4965 builds, these must build to nothing in order to allow
  * the common code to not have several #if IWL == XXXX / #endif blocks
  */
+static inline void iwl_eeprom_release_semaphore(struct iwl_priv *priv) {}
+
 static inline void iwl4965_add_station(struct iwl_priv *priv, const u8 * addr,
 				       int is_ap) {}
 static inline void iwl4965_set_rxon_ht(struct iwl_priv *priv,
@@ -69,6 +71,9 @@ static inline void iwl4965_rf_kill_ct_config(struct iwl_priv *priv) {}
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
+extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
+extern void iwl_eeprom_release_semaphore(struct iwl_priv *priv);
+
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq,
 					  u16 byte_cnt);
@@ -355,5 +360,8 @@ struct iwl_chain_noise_data {
 #define RATE_MCS_SGI_POS 13
 #define RATE_MCS_SGI_MSK 0x2000
 
+#define	EEPROM_SEM_TIMEOUT 10
+#define EEPROM_SEM_RETRY_LIMIT 1000
+
 #endif				/* IWL == 4965 */
 #endif				/* __iwl_4965_h__ */
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 1adcdbe..92c21d1 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1549,35 +1549,42 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
 		return -ENOENT;
 	}
-#if IWL == 3945
-	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_OWNER);
-#endif
+
+	rc = iwl_eeprom_aqcuire_semaphore(priv);
+	if (rc < 0) {
+		IWL_ERROR("Failed to aqcuire EEPROM semaphore.\n");
+		return -ENOENT;
+	}
 
 	for (addr = 0, r = 0; addr < sz; addr += 2) {
 		_iwl_write32(priv, CSR_EEPROM_REG, addr << 1);
 		_iwl_clear_bit(priv, CSR_EEPROM_REG, 0x00000002);
 		rc = _iwl_grab_restricted_access(priv);
 		if (rc)
-			return rc;
+			goto done;
 
-		for (to = 0; to < 10; to++) {
+		for (to = 0; to < 50; to++) {
 			r = _iwl_read_restricted(priv, CSR_EEPROM_REG);
 			if (r & 1)
 				break;
-			udelay(5);
+			udelay(10);
 		}
 
 		_iwl_release_restricted_access(priv);
 
 		if (!(r & 1)) {
 			IWL_ERROR("Time out reading EEPROM[%d]", addr);
-			return -ETIMEDOUT;
+			rc = -ETIMEDOUT;
+			goto done;
 		}
 
 		e[addr / 2] = le16_to_cpu(r >> 16);
 	}
+	rc = 0;
 
-	return 0;
+done:
+	iwl_eeprom_release_semaphore(priv);
+	return rc;
 }
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 49ad71b..7512fc7 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -893,6 +893,7 @@ struct statistics {
 #define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
 #define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
 #define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM	    (0x00200000)
 
 #define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
 #define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
@@ -907,7 +908,6 @@ struct statistics {
 
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
 #define BIT_INT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-- 
1.5.2
