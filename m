Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52193 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbAYNDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 08:03:04 -0500
Received: by mail-wi0-f176.google.com with SMTP id em10so5162030wid.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 05:03:02 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 1/2] bcma: add empty PCIe hostmode functions if support is disabled
Date: Sun, 25 Jan 2015 14:02:48 +0100
Message-Id: <1422190968-14422-1-git-send-email-zajec5@gmail.com> (sfid-20150125_140308_567489_7CAB2972)
In-Reply-To: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
References: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to drop some #ifdef magic (mess).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Return false in bcma_core_pci_is_in_hostmode
    Don't (accidentally) modify bcma_host_soc_register_driver
---
 drivers/bcma/bcma_private.h | 8 ++++++++
 drivers/bcma/driver_pci.c   | 2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3f314c9..ac6c5fc 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -107,6 +107,14 @@ extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
 bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc);
 void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
+#else
+static inline bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
+{
+	return false;
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

