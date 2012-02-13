Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab2BMKYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:07 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/24] iwlegacy: use writeb,writel,readl directly
Date: Mon, 13 Feb 2012 11:23:11 +0100
Message-Id: <1329128611-6815-5-git-send-email-sgruszka@redhat.com> (sfid-20120213_112423_280438_97C901BE)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That change will save us some CPU cycles at run time. Having
port-based I/O seems to be not possible for PCIe devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    6 +++---
 drivers/net/wireless/iwlegacy/4965-mac.c |    6 +++---
 drivers/net/wireless/iwlegacy/common.h   |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index aa8f5c0..63ec05b 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3655,7 +3655,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/***********************
 	 * 3. Read REV Register
 	 * ********************/
-	il->hw_base = pci_iomap(pdev, 0, 0);
+	il->hw_base = pci_ioremap_bar(pdev, 0);
 	if (!il->hw_base) {
 		err = -ENODEV;
 		goto out_pci_release_regions;
@@ -3780,7 +3780,7 @@ out_unset_hw_params:
 out_eeprom_free:
 	il_eeprom_free(il);
 out_iounmap:
-	pci_iounmap(pdev, il->hw_base);
+	iounmap(il->hw_base);
 out_pci_release_regions:
 	pci_release_regions(pdev);
 out_pci_disable_device:
@@ -3860,7 +3860,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 	free_irq(pdev->irq, il);
 	pci_disable_msi(pdev);
 
-	pci_iounmap(pdev, il->hw_base);
+	iounmap(il->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 90c9bfb..7bf78bf 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6224,7 +6224,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/***********************
 	 * 3. Read REV register
 	 ***********************/
-	il->hw_base = pci_iomap(pdev, 0, 0);
+	il->hw_base = pci_ioremap_bar(pdev, 0);
 	if (!il->hw_base) {
 		err = -ENODEV;
 		goto out_pci_release_regions;
@@ -6356,7 +6356,7 @@ out_disable_msi:
 out_free_eeprom:
 	il_eeprom_free(il);
 out_iounmap:
-	pci_iounmap(pdev, il->hw_base);
+	iounmap(il->hw_base);
 out_pci_release_regions:
 	pci_set_drvdata(pdev, NULL);
 	pci_release_regions(pdev);
@@ -6438,7 +6438,7 @@ il4965_pci_remove(struct pci_dev *pdev)
 
 	free_irq(il->pci_dev->irq, il);
 	pci_disable_msi(il->pci_dev);
-	pci_iounmap(pdev, il->hw_base);
+	iounmap(il->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index df9b5b4..fd2a4ee 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2114,20 +2114,20 @@ extern void il_write_targ_mem(struct il_priv *il, u32 addr, u32 val);
 static inline void
 _il_write8(struct il_priv *il, u32 ofs, u8 val)
 {
-	iowrite8(val, il->hw_base + ofs);
+	writeb(val, il->hw_base + ofs);
 }
 #define il_write8(il, ofs, val) _il_write8(il, ofs, val)
 
 static inline void
 _il_wr(struct il_priv *il, u32 ofs, u32 val)
 {
-	iowrite32(val, il->hw_base + ofs);
+	writel(val, il->hw_base + ofs);
 }
 
 static inline u32
 _il_rd(struct il_priv *il, u32 ofs)
 {
-	return ioread32(il->hw_base + ofs);
+	return readl(il->hw_base + ofs);
 }
 
 static inline void
-- 
1.7.1

