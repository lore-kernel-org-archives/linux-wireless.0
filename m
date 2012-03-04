Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2CDUnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:11 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 083/101] iwlwifi: use writeb,writel,readl directly
Date: Sun,  4 Mar 2012 11:29:37 -0800
Message-Id: <1330889395-533-84-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214457_802854_8808DCD2)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

That change will save us some CPU cycles at run time. Having port-based
I/O seems to be not possible for PCIe devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ae08498..5afd06e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,6 +1,6 @@
 config IWLWIFI
 	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi) "
-	depends on PCI && MAC80211
+	depends on PCI && MAC80211 && HAS_IOMEM
 	select FW_LOADER
 	select NEW_LEDS
 	select LEDS_CLASS
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 2a781b5..ef7418d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1609,18 +1609,17 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
 static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
-	iowrite8(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+	writeb(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
 static void iwl_trans_pcie_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	iowrite32(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
+	writel(val, IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
 static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 {
-	u32 val = ioread32(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
-	return val;
+	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1638,7 +1637,7 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	}
 
 	pci_disable_msi(trans_pcie->pci_dev);
-	pci_iounmap(trans_pcie->pci_dev, trans_pcie->hw_base);
+	iounmap(trans_pcie->hw_base);
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
 
@@ -2269,9 +2268,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 		goto out_pci_disable_device;
 	}
 
-	trans_pcie->hw_base = pci_iomap(pdev, 0, 0);
+	trans_pcie->hw_base = pci_ioremap_bar(pdev, 0);
 	if (!trans_pcie->hw_base) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_iomap failed");
+		dev_printk(KERN_ERR, &pdev->dev, "pci_ioremap_bar failed");
 		err = -ENODEV;
 		goto out_pci_release_regions;
 	}
-- 
1.7.0.4

