Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52904 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab1ERKU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 06:20:26 -0400
Received: by ewy4 with SMTP id 4so390563ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 03:20:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: pci: implement enabling interrupts
Date: Wed, 18 May 2011 12:58:14 +0200
Message-Id: <1305716294-5753-1-git-send-email-zajec5@gmail.com> (sfid-20110518_122029_487823_AFBF822A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index e757e4e..879fe1d 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -161,3 +161,21 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
 	bcma_pcicore_serdes_workaround(pc);
 }
+
+int bcma_core_pci_irq_enable(struct bcma_drv_pci *pc, struct bcma_device *core)
+{
+	struct pci_dev *pdev = pc->core->bus->host_pci;
+	u32 coremask, tmp;
+	int err;
+
+	coremask = BIT(core->core_index);
+
+	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK, &tmp);
+	if (err)
+		goto out;
+	tmp |= coremask << 8;
+	err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
+
+out:
+	return err;
+}
-- 
1.7.3.4

