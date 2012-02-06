Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab2BFQJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:09:36 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 4/4] iwlwifi: use writeb,writel,readl directly
Date: Mon,  6 Feb 2012 17:09:24 +0100
Message-Id: <1328544564-8696-4-git-send-email-sgruszka@redhat.com> (sfid-20120206_170941_132106_94CD45EB)
In-Reply-To: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That will save us some CPU cycles at run time.

Obviously I do not think port-based IO is possible, but I added
check for that during probe just in case.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 03702a2..32b326d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -153,18 +153,17 @@ static u32 iwl_pci_get_hw_id(struct iwl_bus *bus)
 
 static void iwl_pci_write8(struct iwl_bus *bus, u32 ofs, u8 val)
 {
-	iowrite8(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
+	writeb(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
 }
 
 static void iwl_pci_write32(struct iwl_bus *bus, u32 ofs, u32 val)
 {
-	iowrite32(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
+	writel(val, IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
 }
 
 static u32 iwl_pci_read32(struct iwl_bus *bus, u32 ofs)
 {
-	u32 val = ioread32(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
-	return val;
+	return readl(IWL_BUS_GET_PCI_BUS(bus)->hw_base + ofs);
 }
 
 static const struct iwl_bus_ops bus_ops_pci = {
@@ -417,6 +416,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_disable_device;
 	}
 
+	if (pci_resource_flags(pdev, 0) & IORESOURCE_IO) {
+		dev_printk(KERN_ERR, bus->dev, "not supported I/O method");
+		goto out_pci_disable_device;
+	}
+
 	pci_bus->hw_base = pci_iomap(pdev, 0, 0);
 	if (!pci_bus->hw_base) {
 		dev_printk(KERN_ERR, bus->dev, "pci_iomap failed");
-- 
1.7.1

