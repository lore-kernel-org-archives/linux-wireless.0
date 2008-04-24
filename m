Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbYDXAPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/16] iwlwifi: check eeprom version in pci probe time
Date: Wed, 23 Apr 2008 17:14:55 -0700
Message-Id: <1208996108-15326-4-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021605_484376_012C2129)
In-Reply-To: <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch move eeprom version checking into pci probe stage

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   32 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   11 ++++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    3 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 +++
 4 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d1ddbf3..a41a83a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -494,6 +494,31 @@ int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 	return 0;
 }
 
+/*
+ * EEPROM handlers
+ */
+
+static int iwl4965_eeprom_check_version(struct iwl_priv *priv)
+{
+	u16 eeprom_ver;
+	u16 calib_ver;
+
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+
+	calib_ver = iwl_eeprom_query16(priv, EEPROM_4965_CALIB_VERSION_OFFSET);
+
+	if (eeprom_ver < EEPROM_4965_EEPROM_VERSION ||
+	    calib_ver < EEPROM_4965_TX_POWER_VERSION)
+		goto err;
+
+	return 0;
+err:
+	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		  eeprom_ver, EEPROM_4965_EEPROM_VERSION,
+		  calib_ver, EEPROM_4965_TX_POWER_VERSION);
+	return -EINVAL;
+
+}
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
 	int ret;
@@ -763,12 +788,6 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (iwl_eeprom_query16(priv, EEPROM_4965_CALIB_VERSION_OFFSET) <
-		EEPROM_4965_TX_POWER_VERSION) {
-		IWL_ERROR("Older EEPROM detected!  Aborting.\n");
-		return -EINVAL;
-	}
-
 	pci_read_config_byte(priv->pci_dev, PCI_LINK_CTRL, &val_link);
 
 	/* disable L1 entry -- workaround for pre-B1 */
@@ -4354,6 +4373,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.check_version = iwl4965_eeprom_check_version,
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
 	.radio_kill_sw = iwl4965_radio_kill_sw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index efd48ca..8bec0e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -279,6 +279,11 @@ void iwl_eeprom_free(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_eeprom_free);
 
+int iwl_eeprom_check_version(struct iwl_priv *priv)
+{
+	return priv->cfg->ops->lib->eeprom_ops.check_version(priv);
+}
+EXPORT_SYMBOL(iwl_eeprom_check_version);
 
 const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
 {
@@ -423,12 +428,6 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		return 0;
 	}
 
-	if (iwl_eeprom_query16(priv, EEPROM_VERSION) < 0x2f) {
-		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
-			    iwl_eeprom_query16(priv, EEPROM_VERSION));
-		return -EINVAL;
-	}
-
 	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
 
 	priv->channel_count =
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index d576814..57fb89d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -134,6 +134,7 @@ struct iwl_eeprom_channel {
 /* 4965 Specific */
 /* 4965 driver does not work with txpower calibration version < 5 */
 #define EEPROM_4965_TX_POWER_VERSION    (5)
+#define EEPROM_4965_EEPROM_VERSION	(0x2f)
 #define EEPROM_4965_CALIB_VERSION_OFFSET       (2*0xB6) /* 2 bytes */
 #define EEPROM_4965_CALIB_TXPOWER_OFFSET       (2*0xE8) /* 48  bytes */
 #define EEPROM_4965_BOARD_REVISION             (2*0x4F) /* 2 bytes */
@@ -322,6 +323,7 @@ struct iwl_eeprom_ops {
 	int (*verify_signature) (struct iwl_priv *priv);
 	int (*acquire_semaphore) (struct iwl_priv *priv);
 	void (*release_semaphore) (struct iwl_priv *priv);
+	int (*check_version) (struct iwl_priv *priv);
 	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
 };
 
@@ -329,6 +331,7 @@ struct iwl_eeprom_ops {
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 int iwl_eeprom_init(struct iwl_priv *priv);
 void iwl_eeprom_free(struct iwl_priv *priv);
+int  iwl_eeprom_check_version(struct iwl_priv *priv);
 const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7957270..de9b932 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7480,6 +7480,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		IWL_ERROR("Unable to init EEPROM\n");
 		goto out_iounmap;
 	}
+	err = iwl_eeprom_check_version(priv);
+	if (err)
+		goto out_iounmap;
+
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
 	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
-- 
1.5.3.4

