Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2BWKQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:16:20 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/6] iwlwifi: use writeb,writel,readl directly
Date: Thu, 23 Feb 2012 11:16:06 +0100
Message-Id: <1329992168-19990-4-git-send-email-sgruszka@redhat.com> (sfid-20120223_111624_443292_569282C6)
In-Reply-To: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That change will save us some CPU cycles at run time. Having port-based
I/O seems to be not possible for PCIe devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/Kconfig          |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ae08498..404ac69 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,6 +6,7 @@ config IWLWIFI
 	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
+	select HAS_IOMEM
 	---help---
 	  Select to build the driver supporting the:
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index f5cb5d3..b6909b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1583,18 +1583,17 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
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
@@ -1613,7 +1612,7 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	}
 
 	pci_disable_msi(trans_pcie->pci_dev);
-	pci_iounmap(trans_pcie->pci_dev, trans_pcie->hw_base);
+	iounmap(trans_pcie->hw_base);
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
 
@@ -2294,9 +2293,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
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
1.7.1

