Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52671 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0HESon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 14:44:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: disable aspm by default
Date: Thu,  5 Aug 2010 14:42:03 -0400
Message-Id: <1281033723-8217-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some iwlwifi devices inexplicably disconnect themselves from the PCI-E
bus causing the predictable failures.  This seems to disappear if ASPM
is disabled.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 35337b1..49a7a98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
@@ -3968,6 +3969,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/**************************
 	 * 2. Initializing PCI bus
 	 **************************/
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_ieee80211_free_hw;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d24eb47..bc08242 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
@@ -3963,6 +3964,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/***************************
 	 * 2. Initializing PCI bus
 	 * *************************/
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				PCIE_LINK_STATE_CLKPM);
+
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_ieee80211_free_hw;
-- 
1.7.2

