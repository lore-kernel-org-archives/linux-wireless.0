Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37162 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbAYKL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 05:11:26 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so4456699wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 02:11:24 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: add empty PCIe hostmode functions if support is disabled
Date: Sun, 25 Jan 2015 11:11:13 +0100
Message-Id: <1422180674-9592-1-git-send-email-zajec5@gmail.com> (sfid-20150125_111150_297762_9F672146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to drop some #ifdef magic (mess).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h | 10 +++++++++-
 drivers/bcma/driver_pci.c   |  2 --
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3f314c9..3242655 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -92,7 +92,7 @@ extern void __exit bcma_host_soc_unregister_driver(void);
 #else
 static inline int __init bcma_host_soc_register_driver(void)
 {
-	return 0;
+	return false;
 }
 static inline void __exit bcma_host_soc_unregister_driver(void)
 {
@@ -107,6 +107,14 @@ extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
 void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
+#else
+static inline bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
+{
+	return 0;
+}
+static inline void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
+{
+}
 #endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
 #ifdef CONFIG_BCMA_DRIVER_GPIO
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 50329d1..b85a505 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -226,11 +226,9 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
 	if (pc->setup_done)
 		return;
 
-#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 	pc->hostmode = bcma_core_pci_is_in_hostmode(pc);
 	if (pc->hostmode)
 		bcma_core_pci_hostmode_init(pc);
-#endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
 	if (!pc->hostmode)
 		bcma_core_pci_clientmode_init(pc);
-- 
1.8.4.5

