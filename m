Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22348 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1LSWnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/6] iwlwifi: deliver hw version in both string and u32 format
Date: Mon, 19 Dec 2011 13:43:10 -0800
Message-Id: <1324330993-24476-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234351_166913_6C0E64AD)
In-Reply-To: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add function to get hw version in both strind and u32 format

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h      |   16 ++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c      |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    2 +-
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 08b9759..940d503 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -122,7 +122,8 @@ struct iwl_bus;
  * struct iwl_bus_ops - bus specific operations
  * @get_pm_support: must returns true if the bus can go to sleep
  * @apm_config: will be called during the config of the APM
- * @get_hw_id: prints the hw_id in the provided buffer
+ * @get_hw_id_string: prints the hw_id in the provided buffer
+ * @get_hw_id: get hw_id in u32
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
  * @wread32: read a dword at register at offset ofs
@@ -130,7 +131,8 @@ struct iwl_bus;
 struct iwl_bus_ops {
 	bool (*get_pm_support)(struct iwl_bus *bus);
 	void (*apm_config)(struct iwl_bus *bus);
-	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
+	void (*get_hw_id_string)(struct iwl_bus *bus, char buf[], int buf_len);
+	u32 (*get_hw_id)(struct iwl_bus *bus);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
 	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
 	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
@@ -172,9 +174,15 @@ static inline void bus_apm_config(struct iwl_bus *bus)
 	bus->ops->apm_config(bus);
 }
 
-static inline void bus_get_hw_id(struct iwl_bus *bus, char buf[], int buf_len)
+static inline void bus_get_hw_id_string(struct iwl_bus *bus, char buf[],
+		int buf_len)
 {
-	bus->ops->get_hw_id(bus, buf, buf_len);
+	bus->ops->get_hw_id_string(bus, buf, buf_len);
+}
+
+static inline u32 bus_get_hw_id(struct iwl_bus *bus)
+{
+	return bus->ops->get_hw_id(bus);
 }
 
 static inline void bus_write8(struct iwl_bus *bus, u32 ofs, u8 val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e513a80..7bcfa78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -204,7 +204,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     cfg(priv)->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		char buf[32];
-		bus_get_hw_id(bus(priv), buf, sizeof(buf));
+		bus_get_hw_id_string(bus(priv), buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n", buf);
 		cfg(priv)->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 850ec8e..fb30ea7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -135,7 +135,7 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	}
 }
 
-static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
+static void iwl_pci_get_hw_id_string(struct iwl_bus *bus, char buf[],
 			      int buf_len)
 {
 	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
@@ -144,6 +144,13 @@ static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
 		 pci_dev->subsystem_device);
 }
 
+static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
+{
+	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
+
+	return (pci_dev->device << 16) + pci_dev->subsystem_device;
+}
+
 static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
 {
 	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
@@ -163,6 +170,7 @@ static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
 static const struct iwl_bus_ops bus_ops_pci = {
 	.get_pm_support = iwl_pci_is_pm_supported,
 	.apm_config = iwl_pci_apm_config,
+	.get_hw_id_string = iwl_pci_get_hw_id_string,
 	.get_hw_id = iwl_pci_get_hw_id,
 	.write8 = iwl_pci_write8,
 	.write32 = iwl_pci_write32,
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index db8a0d6..05d3016 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -534,7 +534,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
-		bus_get_hw_id(bus(priv), buf, sizeof(buf));
+		bus_get_hw_id_string(bus(priv), buf, sizeof(buf));
 		ptr = buf;
 		strsep(&ptr, ":");
 		sscanf(strsep(&ptr, ":"), "%x", &num);
-- 
1.7.0.4

