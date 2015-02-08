Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39828 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbbBHQMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 11:12:02 -0500
Received: by mail-we0-f181.google.com with SMTP id w62so4993472wes.12
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 08:12:00 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3 3/4] bcma: support bringing up bus hosted on PCIe Gen 2
Date: Sun,  8 Feb 2015 17:11:49 +0100
Message-Id: <1423411910-22399-3-git-send-email-zajec5@gmail.com> (sfid-20150208_171207_835942_67867103)
In-Reply-To: <1423411910-22399-1-git-send-email-zajec5@gmail.com>
References: <1423409504-16435-1-git-send-email-zajec5@gmail.com>
 <1423411910-22399-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Use pcie_set_readrq helper instead of pcie_capability_clear_and_set_word
V3: Fix pcie_set_readrq argument
    Print error if pcie_set_readrq fails
---
 drivers/bcma/bcma_private.h            |  3 +++
 drivers/bcma/driver_pcie2.c            | 28 ++++++++++++++++++++++++++--
 drivers/bcma/host_pci.c                |  2 +-
 include/linux/bcma/bcma_driver_pcie2.h |  2 ++
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 351f4af..3692912 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -104,6 +104,9 @@ u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
 void bcma_core_pci_up(struct bcma_drv_pci *pc);
 void bcma_core_pci_down(struct bcma_drv_pci *pc);
 
+/* driver_pcie2.c */
+void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2);
+
 extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
index e4be537..4568bc7 100644
--- a/drivers/bcma/driver_pcie2.c
+++ b/drivers/bcma/driver_pcie2.c
@@ -156,14 +156,23 @@ static void pciedev_reg_pm_clk_period(struct bcma_drv_pcie2 *pcie2)
 
 void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
 {
-	struct bcma_chipinfo *ci = &pcie2->core->bus->chipinfo;
+	struct bcma_bus *bus = pcie2->core->bus;
+	struct bcma_chipinfo *ci = &bus->chipinfo;
 	u32 tmp;
 
 	tmp = pcie2_read32(pcie2, BCMA_CORE_PCIE2_SPROM(54));
 	if ((tmp & 0xe) >> 1 == 2)
 		bcma_core_pcie2_cfg_write(pcie2, 0x4e0, 0x17);
 
-	/* TODO: Do we need pcie_reqsize? */
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM4360:
+	case BCMA_CHIP_ID_BCM4352:
+		pcie2->reqsize = 1024;
+		break;
+	default:
+		pcie2->reqsize = 128;
+		break;
+	}
 
 	if (ci->id == BCMA_CHIP_ID_BCM4360 && ci->rev > 3)
 		bcma_core_pcie2_war_delay_perst_enab(pcie2, true);
@@ -173,3 +182,18 @@ void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
 	pciedev_crwlpciegen2_180(pcie2);
 	pciedev_crwlpciegen2_182(pcie2);
 }
+
+/**************************************************
+ * Runtime ops.
+ **************************************************/
+
+void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2)
+{
+	struct bcma_bus *bus = pcie2->core->bus;
+	struct pci_dev *dev = bus->host_pci;
+	int err;
+
+	err = pcie_set_readrq(dev, pcie2->reqsize);
+	if (err)
+		bcma_err(bus, "Error setting PCI_EXP_DEVCTL_READRQ: %d\n", err);
+}
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 8dd37dc..5fb87a8 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -322,7 +322,7 @@ void bcma_host_pci_up(struct bcma_bus *bus)
 		return;
 
 	if (bus->host_is_pcie2)
-		pr_warn("Bringing up bus with PCIe Gen 2 host is unsupported yet\n");
+		bcma_core_pcie2_up(&bus->drv_pcie2);
 	else
 		bcma_core_pci_up(&bus->drv_pci[0]);
 }
diff --git a/include/linux/bcma/bcma_driver_pcie2.h b/include/linux/bcma/bcma_driver_pcie2.h
index 5988b05..d8c4329 100644
--- a/include/linux/bcma/bcma_driver_pcie2.h
+++ b/include/linux/bcma/bcma_driver_pcie2.h
@@ -143,6 +143,8 @@
 
 struct bcma_drv_pcie2 {
 	struct bcma_device *core;
+
+	u16 reqsize;
 };
 
 #define pcie2_read16(pcie2, offset)		bcma_read16((pcie2)->core, offset)
-- 
1.8.4.5

