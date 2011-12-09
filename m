Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50367 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1LIVPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 16:15:41 -0500
Received: by eaak14 with SMTP id k14so1926659eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 13:15:40 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Greg KH <gregkh@suse.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	stable@kernel.org
Subject: [PATCH] bcma: support for suspend and resume
Date: Fri,  9 Dec 2011 22:16:07 +0100
Message-Id: <1323465367-5130-1-git-send-email-zajec5@gmail.com> (sfid-20111209_221544_985226_70B2DEC8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma used to lock up machine without enabling PCI or initializing CC.

Cc: stable@kernel.org
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
DC input port stopped working in my notebook. I had to open it and fix.
Guess what has appeared to my eyes... WiFI card in the mini PCIe slot!
For all the years I believed WiFi is integrated with the motherboard!

Taking a chance, I've put BCM43224 and decided to resolve suspend and
resume issue. I've reproduced lock ups and tracked them :)

It fixes lockups, so I believe it has to be Cc to stable.
---
 drivers/bcma/bcma_private.h |    3 +++
 drivers/bcma/host_pci.c     |   37 +++++++++++++++++++++++++++++++++++++
 drivers/bcma/main.c         |   16 ++++++++++++++++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 30a3085..fda56bd 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -18,6 +18,9 @@ void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
 				   struct bcma_device *core_cc,
 				   struct bcma_device *core_mips);
+#ifdef CONFIG_PM
+int bcma_bus_resume(struct bcma_bus *bus);
+#endif
 
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 1b51d8b..990f5a8 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -224,6 +224,41 @@ static void bcma_host_pci_remove(struct pci_dev *dev)
 	pci_set_drvdata(dev, NULL);
 }
 
+#ifdef CONFIG_PM
+static int bcma_host_pci_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	/* Host specific */
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	return 0;
+}
+
+static int bcma_host_pci_resume(struct pci_dev *dev)
+{
+	struct bcma_bus *bus = pci_get_drvdata(dev);
+	int err;
+
+	/* Host specific */
+	pci_set_power_state(dev, 0);
+	err = pci_enable_device(dev);
+	if (err)
+		return err;
+	pci_restore_state(dev);
+
+	/* Bus specific */
+	err = bcma_bus_resume(bus);
+	if (err)
+		return err;
+
+	return 0;
+}
+#else /* CONFIG_PM */
+# define bcma_host_pci_suspend	NULL
+# define bcma_host_pci_resume	NULL
+#endif /* CONFIG_PM */
+
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
@@ -239,6 +274,8 @@ static struct pci_driver bcma_pci_bridge_driver = {
 	.id_table = bcma_pci_bridge_tbl,
 	.probe = bcma_host_pci_probe,
 	.remove = bcma_host_pci_remove,
+	.suspend = bcma_host_pci_suspend,
+	.resume = bcma_host_pci_resume,
 };
 
 int __init bcma_host_pci_init(void)
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 70c84b9..10f92b3 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -240,6 +240,22 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	return 0;
 }
 
+#ifdef CONFIG_PM
+int bcma_bus_resume(struct bcma_bus *bus)
+{
+	struct bcma_device *core;
+
+	/* Init CC core */
+	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	if (core) {
+		bus->drv_cc.setup_done = false;
+		bcma_core_chipcommon_init(&bus->drv_cc);
+	}
+
+	return 0;
+}
+#endif
+
 int __bcma_driver_register(struct bcma_driver *drv, struct module *owner)
 {
 	drv->drv.name = drv->name;
-- 
1.7.3.4

