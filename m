Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:32997 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbFGLPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 07:15:43 -0400
Received: by wgez8 with SMTP id z8so83532309wge.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 04:15:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: make calls to PCI hostmode functions config-safe
Date: Sun,  7 Jun 2015 13:15:30 +0200
Message-Id: <1433675731-16328-1-git-send-email-zajec5@gmail.com> (sfid-20150607_131932_482186_D60604C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma_driver_pci.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 5ba6918..9657f11 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -246,7 +246,18 @@ static inline void bcma_core_pci_power_save(struct bcma_bus *bus, bool up)
 }
 #endif
 
+#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
 extern int bcma_core_pci_plat_dev_init(struct pci_dev *dev);
+#else
+static inline int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev)
+{
+	return -ENOTSUPP;
+}
+static inline int bcma_core_pci_plat_dev_init(struct pci_dev *dev)
+{
+	return -ENOTSUPP;
+}
+#endif
 
 #endif /* LINUX_BCMA_DRIVER_PCI_H_ */
-- 
1.8.4.5

