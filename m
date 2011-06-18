Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1FRQF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/25] iwlagn: add a method to get the HW ID description as a string to iwl_bus_ops
Date: Sat, 18 Jun 2011 08:34:18 -0700
Message-Id: <1308411271-26093-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180535_306740_F156FBE7)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |   10 ++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 360df33..cde7253 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -209,10 +209,10 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
+		char buf[32];
+		priv->bus.ops->get_hw_id(&priv->bus, buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
-			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
-			   priv->pci_dev->device,
-			   priv->pci_dev->subsystem_device);
+			"Please send your %s to maintainer.\n", buf);
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 797d4f3..1099944 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1198,6 +1198,7 @@ struct iwl_bus;
  * @apm_config: will be called during the config of the APM configuration
  * @set_drv_data: set the priv pointer to the bus layer
  * @get_dev: returns the device struct
+ * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
  * @wread32: read a dword at register at offset ofs
@@ -1207,6 +1208,7 @@ struct iwl_bus_ops {
 	void (*apm_config)(struct iwl_bus *bus);
 	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
 	struct device *(*get_dev)(const struct iwl_bus *bus);
+	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
 	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
 	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index d8c6ec8..adbc962 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -141,6 +141,15 @@ static struct device *iwl_pci_get_dev(const struct iwl_bus *bus)
 	return &(IWL_BUS_GET_PCI_DEV(bus)->dev);
 }
 
+static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
+			      int buf_len)
+{
+	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
+
+	snprintf(buf, buf_len, "PCI ID: 0x%04X:0x%04X", pci_dev->device,
+		 pci_dev->subsystem_device);
+}
+
 static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
 {
 	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
@@ -162,6 +171,7 @@ static struct iwl_bus_ops pci_ops = {
 	.apm_config = iwl_pci_apm_config,
 	.set_drv_data = iwl_pci_set_drv_data,
 	.get_dev = iwl_pci_get_dev,
+	.get_hw_id = iwl_pci_get_hw_id,
 	.write8 = iwl_pci_write8,
 	.write32 = iwl_pci_write32,
 	.read32 = iwl_pci_read32,
-- 
1.7.0.4

