Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab2BQUXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/26] iwlwifi: create iwl_nic structure
Date: Fri, 17 Feb 2012 11:13:35 -0800
Message-Id: <1329506034-1394-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212446_479848_EB4B7F28)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Create iwl_nic structure and link it together.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c    |   18 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    3 ++
 drivers/net/wireless/iwlwifi/iwl-ucode.h  |   37 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-wifi.h   |   30 +++++++++++++++++++++++
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 3e2fce4..5190670 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -70,6 +70,7 @@
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "iwl-cfg.h"
+#include "iwl-wifi.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
@@ -282,13 +283,23 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bus->shrd->bus = bus;
 
+	/* temporarily create this here */
+	bus->shrd->nic = kzalloc(sizeof(*bus->shrd->nic), GFP_KERNEL);
+	if (!bus->shrd->nic) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "Couldn't allocate iwl_nic");
+		err = -ENOMEM;
+		goto out_free_bus;
+	}
+	/* and initialize it as well, temporarily */
+	bus->shrd->nic->shrd = bus->shrd;
 	pci_set_drvdata(pdev, bus);
 
 #ifdef CONFIG_IWLWIFI_IDI
 	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_free_bus;
+		goto out_free_nic;
 	}
 
 	err = iwl_probe(bus, &trans_ops_idi, cfg);
@@ -296,7 +307,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	trans(bus) = iwl_trans_pcie_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_free_bus;
+		goto out_free_nic;
 	}
 
 	err = iwl_probe(bus, &trans_ops_pcie, cfg);
@@ -309,6 +320,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_free_trans:
 	iwl_trans_free(trans(bus));
 	pci_set_drvdata(pdev, NULL);
+out_free_nic:
+	kfree(bus->shrd->nic);
 out_free_bus:
 	kfree(bus->shrd);
 	kfree(bus);
@@ -325,6 +338,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	kfree(bus->shrd->nic);
 	kfree(bus->shrd);
 	kfree(bus);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 42bf43b..8c6fc6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -358,6 +358,7 @@ struct iwl_cfg {
  * @cfg: see struct iwl_cfg
  * @priv: pointer to the upper layer data
  * @trans: pointer to the transport layer data
+ * @nic: pointer to the nic data
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
  * @sta_lock: protects the station table.
@@ -388,6 +389,7 @@ struct iwl_shared {
 	struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
+	struct iwl_nic *nic;
 	struct iwl_hw_params hw_params;
 
 	spinlock_t lock;
@@ -418,6 +420,7 @@ struct iwl_shared {
 #define priv(_m)	((_m)->shrd->priv)
 #define cfg(_m)		((_m)->shrd->cfg)
 #define bus(_m)		((_m)->shrd->bus)
+#define nic(_m)		((_m)->shrd->nic)
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
index eccf925..18c77e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -63,6 +63,10 @@
 #ifndef __iwl_ucode_h__
 #define __iwl_ucode_h__
 
+#include "iwl-trans.h"
+
+#include <linux/netdevice.h>
+
 /* v1/v2 uCode file layout */
 struct iwl_ucode_header {
 	__le32 ver;	/* major/minor/API/serial */
@@ -171,6 +175,39 @@ struct iwl_tlv_ucode_header {
 	u8 data[0];
 };
 
+struct iwl_ucode_capabilities {
+	u32 max_probe_length;
+	u32 standard_phy_calibration_size;
+	u32 flags;
+};
+
+/**
+ * struct iwl_fw - variables associated with the firmware
+ *
+ * @ucode_ver: ucode version from the ucode file
+ * @fw_version: firmware version string
+ * @ucode_rt: run time ucode image
+ * @ucode_init: init ucode image
+ * @ucode_wowlan: wake on wireless ucode image (optional)
+ * @ucode_capa: capabilities parsed from the ucode file.
+ * @enhance_sensitivity_table: device can do enhanced sensitivity.
+ */
+struct iwl_fw {
+
+	/* ucode image and variables */
+	u32 ucode_ver;                  /* version of ucode, copy of
+					   iwl_ucode.ver */
+	char fw_version[ETHTOOL_BUSINFO_LEN];
+
+	/* ucode images */
+	struct fw_img ucode_rt;
+	struct fw_img ucode_init;
+	struct fw_img ucode_wowlan;
+
+	struct iwl_ucode_capabilities ucode_capa;
+	bool enhance_sensitivity_table;
+};
+
 struct iwl_priv;
 
 int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first);
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index 7e6eb20..a34708d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -64,6 +64,36 @@
 #define __iwl_wifi_h__
 
 #include "iwl-shared.h"
+#include "iwl-ucode.h"
+
+/**
+ * struct iwl_nic - nic common data
+ * @fw: the iwl_fw structure
+ * @shrd: pointer to common shared structure
+ * @fw_index: firmware revision to try loading
+ * @firmware_name: composite filename of ucode file to load
+ * @init_evtlog_ptr: event log offset for init ucode.
+ * @init_evtlog_size: event log size for init ucode.
+ * @init_errlog_ptr: error log offfset for init ucode.
+ * @inst_evtlog_ptr: event log offset for runtime ucode.
+ * @inst_evtlog_size: event log size for runtime ucode.
+ * @inst_errlog_ptr: error log offfset for runtime ucode.
+ * @request_firmware_complete: the firmware has been obtained from user space
+ */
+struct iwl_nic {
+	struct iwl_fw fw;
+
+	struct iwl_shared *shrd;
+
+	int fw_index;                   /* firmware we're trying to load */
+	char firmware_name[25];         /* name of firmware file to load */
+
+	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+
+	struct completion request_firmware_complete;
+};
+
 
 int iwl_send_bt_env(struct iwl_trans *trans, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_trans *trans);
-- 
1.7.0.4

