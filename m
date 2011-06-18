Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1FRQF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/25] iwlagn: move PCI power related functions to the PCI layer
Date: Sat, 18 Jun 2011 08:34:17 -0700
Message-Id: <1308411271-26093-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180553_744620_4EE8BBEE)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Continue to popule the PCI layer and the iwl_bus_ops with the power related
stuff.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h |    7 ----
 drivers/net/wireless/iwlwifi/iwl-core.c   |   24 +-------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |   14 --------
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    5 +++
 drivers/net/wireless/iwlwifi/iwl-pci.c    |   52 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-power.c  |   10 ++---
 drivers/net/wireless/iwlwifi/iwl-power.h  |    2 +-
 7 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 7bd19f4..0e5b842 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -81,13 +81,6 @@
 /* RSSI to dBm */
 #define IWLAGN_RSSI_OFFSET	44
 
-/* PCI registers */
-#define PCI_CFG_RETRY_TIMEOUT	0x041
-
-/* PCI register values */
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-
 #define IWLAGN_DEFAULT_TX_RETRY  15
 
 /* Limit range of txpower output target to be between these values */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4268a3f..360df33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -997,8 +997,6 @@ void iwl_apm_stop(struct iwl_priv *priv)
 int iwl_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
-	u16 lctl;
-
 	IWL_DEBUG_INFO(priv, "Init card's basic functions\n");
 
 	/*
@@ -1027,27 +1025,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
-	/*
-	 * HW bug W/A for instability in PCIe bus L0->L0S->L1 transition.
-	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
-	 * If so (likely), disable L0S, so device moves directly L0->L1;
-	 *    costs negligible amount of power savings.
-	 * If not (unlikely), enable L0S, so there is at least some
-	 *    power savings, even without L1.
-	 */
-	lctl = iwl_pcie_link_ctl(priv);
-	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
-				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
-		/* L1-ASPM enabled; disable(!) L0S  */
-		iwl_set_bit(priv, CSR_GIO_REG,
-				CSR_GIO_REG_VAL_L0S_ENABLED);
-		IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
-	} else {
-		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(priv, CSR_GIO_REG,
-				CSR_GIO_REG_VAL_L0S_ENABLED);
-		IWL_DEBUG_POWER(priv, "L1 Disabled; Enabling L0S\n");
-	}
+	priv->bus.ops->apm_config(&priv->bus);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (priv->cfg->base_params->pll_cfg_val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 84032bb..a09361d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -470,20 +470,6 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
-
-/*****************************************************
- * PCI						     *
- *****************************************************/
-
-static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
-{
-	int pos;
-	u16 pci_lnk_ctl;
-	pos = pci_find_capability(priv->pci_dev, PCI_CAP_ID_EXP);
-	pci_read_config_word(priv->pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
-	return pci_lnk_ctl;
-}
-
 void iwl_bg_watchdog(unsigned long data);
 u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 700e9f9..797d4f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1193,6 +1193,9 @@ struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
+
+ * @get_pm_support: must returns true if the bus can go to sleep
+ * @apm_config: will be called during the config of the APM configuration
  * @set_drv_data: set the priv pointer to the bus layer
  * @get_dev: returns the device struct
  * @write8: write a byte to register at offset ofs
@@ -1200,6 +1203,8 @@ struct iwl_bus;
  * @wread32: read a dword at register at offset ofs
  */
 struct iwl_bus_ops {
+	bool (*get_pm_support)(struct iwl_bus *bus);
+	void (*apm_config)(struct iwl_bus *bus);
 	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
 	struct device *(*get_dev)(const struct iwl_bus *bus);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 43de98e..d8c6ec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -66,6 +66,12 @@
 #include "iwl-pci.h"
 #include "iwl-agn.h"
 #include "iwl-core.h"
+#include "iwl-io.h"
+
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
+#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
 
 struct iwl_pci_bus {
 	/* basic pci-network driver stuff */
@@ -81,6 +87,50 @@ struct iwl_pci_bus {
 #define IWL_BUS_GET_PCI_DEV(_iwl_bus) \
 			((IWL_BUS_GET_PCI_BUS(_iwl_bus))->pci_dev)
 
+static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
+{
+	int pos;
+	u16 pci_lnk_ctl;
+	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
+
+	pos = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
+	return pci_lnk_ctl;
+}
+
+static bool iwl_pci_is_pm_supported(struct iwl_bus *bus)
+{
+	u16 lctl = iwl_pciexp_link_ctrl(bus);
+
+	return !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
+}
+
+static void iwl_pci_apm_config(struct iwl_bus *bus)
+{
+	/*
+	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
+	 * Check if BIOS (or OS) enabled L1-ASPM on this device.
+	 * If so (likely), disable L0S, so device moves directly L0->L1;
+	 *    costs negligible amount of power savings.
+	 * If not (unlikely), enable L0S, so there is at least some
+	 *    power savings, even without L1.
+	 */
+	u16 lctl = iwl_pciexp_link_ctrl(bus);
+
+	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
+				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+		/* L1-ASPM enabled; disable(!) L0S */
+		iwl_set_bit(bus->priv, CSR_GIO_REG,
+				CSR_GIO_REG_VAL_L0S_ENABLED);
+		IWL_DEBUG_POWER(bus->priv, "L1 Enabled; Disabling L0S\n");
+	} else {
+		/* L1-ASPM disabled; enable(!) L0S */
+		iwl_clear_bit(bus->priv, CSR_GIO_REG,
+				CSR_GIO_REG_VAL_L0S_ENABLED);
+		IWL_DEBUG_POWER(bus->priv, "L1 Disabled; Enabling L0S\n");
+	}
+}
+
 static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_priv)
 {
 	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_priv);
@@ -108,6 +158,8 @@ static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
 }
 
 static struct iwl_bus_ops pci_ops = {
+	.get_pm_support = iwl_pci_is_pm_supported,
+	.apm_config = iwl_pci_apm_config,
 	.set_drv_data = iwl_pci_set_drv_data,
 	.get_dev = iwl_pci_get_dev,
 	.write8 = iwl_pci_write8,
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index a69b551..970c514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -245,7 +245,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 		}
 	}
 
-	if (priv->power_data.pci_pm)
+	if (priv->power_data.bus_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 	else
 		cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
@@ -260,7 +260,7 @@ static void iwl_power_sleep_cam_cmd(struct iwl_priv *priv,
 {
 	memset(cmd, 0, sizeof(*cmd));
 
-	if (priv->power_data.pci_pm)
+	if (priv->power_data.bus_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
 	IWL_DEBUG_POWER(priv, "Sleep command for CAM\n");
@@ -296,7 +296,7 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	cmd->flags = IWL_POWER_DRIVER_ALLOW_SLEEP_MSK |
 		     IWL_POWER_FAST_PD; /* no use seeing frames for others */
 
-	if (priv->power_data.pci_pm)
+	if (priv->power_data.bus_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
 	if (priv->cfg->base_params->shadow_reg_enable)
@@ -425,9 +425,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	u16 lctl = iwl_pcie_link_ctl(priv);
-
-	priv->power_data.pci_pm = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
+	priv->power_data.bus_pm = priv->bus.ops->get_pm_support(&priv->bus);
 
 	priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 59635d7..5f7b720 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -43,7 +43,7 @@ struct iwl_power_mgr {
 	struct iwl_powertable_cmd sleep_cmd;
 	struct iwl_powertable_cmd sleep_cmd_next;
 	int debug_sleep_level_override;
-	bool pci_pm;
+	bool bus_pm;
 };
 
 int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
-- 
1.7.0.4

