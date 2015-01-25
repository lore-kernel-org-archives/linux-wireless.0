Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60840 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAYMla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 07:41:30 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so4781153wgg.7
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 04:41:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: implement host code support for PCIe Gen 2 devices
Date: Sun, 25 Jan 2015 13:41:19 +0100
Message-Id: <1422189679-12887-1-git-send-email-zajec5@gmail.com> (sfid-20150125_134133_461395_97631D41)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is stil incomplete, so we don't add PCI IDs of new devices yet.
Purpose of this patch is to allow testing & adjusting rest of the code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_pci.c        | 6 ++++--
 include/linux/bcma/bcma.h      | 1 +
 include/linux/bcma/bcma_regs.h | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index cd9161a..53c6a8a 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -13,10 +13,12 @@
 
 static void bcma_host_pci_switch_core(struct bcma_device *core)
 {
+	int win2 = core->bus->host_is_pcie2 ?
+		BCMA_PCIE2_BAR0_WIN2 : BCMA_PCI_BAR0_WIN2;
+
 	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN,
 			       core->addr);
-	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN2,
-			       core->wrap);
+	pci_write_config_dword(core->bus->host_pci, win2, core->wrap);
 	core->bus->mapped_core = core;
 	bcma_debug(core->bus, "Switched to core: 0x%X\n", core->id.id);
 }
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index eb1c6a4..994739d 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -318,6 +318,7 @@ struct bcma_bus {
 	const struct bcma_host_ops *ops;
 
 	enum bcma_hosttype hosttype;
+	bool host_is_pcie2; /* Used for BCMA_HOSTTYPE_PCI only */
 	union {
 		/* Pointer to the PCI bus (only for BCMA_HOSTTYPE_PCI) */
 		struct pci_dev *host_pci;
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index e64ae7b..ebd5c1f 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -64,6 +64,8 @@
 #define  BCMA_PCI_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
 #define  BCMA_PCI_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
 
+#define BCMA_PCIE2_BAR0_WIN2		0x70
+
 /* SiliconBackplane Address Map.
  * All regions may not exist on all chips.
  */
-- 
1.8.4.5

