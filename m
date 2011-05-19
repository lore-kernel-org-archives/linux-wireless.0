Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53226 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1ESLam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 07:30:42 -0400
Received: by eyx24 with SMTP id 24so727778eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 04:30:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: pci: implement interrupts control
Date: Thu, 19 May 2011 14:08:22 +0200
Message-Id: <1305806902-3926-1-git-send-email-zajec5@gmail.com> (sfid-20110519_133045_783956_44B72137)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index e757e4e..789d68b 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -161,3 +161,26 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
 	bcma_pcicore_serdes_workaround(pc);
 }
+
+int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
+			  bool enable)
+{
+	struct pci_dev *pdev = pc->core->bus->host_pci;
+	u32 coremask, tmp;
+	int err;
+
+	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK, &tmp);
+	if (err)
+		goto out;
+
+	coremask = BIT(core->core_index) << 8;
+	if (enable)
+		tmp |= coremask;
+	else
+		tmp &= ~coremask;
+
+	err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
+
+out:
+	return err;
+}
-- 
1.7.3.4

