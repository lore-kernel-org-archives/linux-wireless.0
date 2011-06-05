Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33019 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab1FEWIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 02/10] bcma: Make it possible to run bcma_register_cores() later
Date: Mon,  6 Jun 2011 00:07:30 +0200
Message-Id: <1307311658-15853-3-git-send-email-hauke@hauke-m.de> (sfid-20110606_000821_880253_7DCF11DD)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On embedded device we can not allocate memory with kalloc or sleep for
some time, when bcma is initialized, because this is done early in the
boot process. This patch makes it possible to do the
bcma_register_cores() sometime later and not directly after searching
for the cores. The initialization of the PCI(e) core is also done later
as it uses udelay(), which will not work so early. The buses are placed
into a list and bcma_register_cores() will be run when the bcma module
is initialized. When using bcma on a PCI-Bus in a normal PC
bcma_register_cores() is triggered directly after bcma_bus_register().
This patch is based on ssb code.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c       |   65 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/bcma/bcma.h |    3 ++
 2 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index b0e7f5e..1afa107 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -15,6 +15,16 @@ static int bcma_bus_match(struct device *dev, struct device_driver *drv);
 static int bcma_device_probe(struct device *dev);
 static int bcma_device_remove(struct device *dev);
 
+/* Temporary list of yet-to-be-attached buses */
+static LIST_HEAD(attach_queue);
+/* There are differences in the codeflow, if the bus is
+ * initialized from early boot, as various needed services
+ * are not available early. This is a mechanism to delay
+ * these initializations to after early boot has finished.
+ * It's also used to avoid mutex locking, as that's not
+ * available and needed early. */
+static bool bcma_is_early_boot = 1;
+
 static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct __bcma_dev_wrapper *wrapper = container_of(dev,
@@ -126,6 +136,36 @@ static int bcma_register_cores(struct bcma_bus *bus)
 	return 0;
 }
 
+static int bcma_attach_queued_buses(void)
+{
+	struct bcma_bus *bus, *n;
+	int err = 0;
+	int drop_them_all = 0;
+
+	list_for_each_entry_safe(bus, n, &attach_queue, attach_list) {
+		if (drop_them_all) {
+			list_del(&bus->attach_list);
+			continue;
+		}
+		/* Can't init the PCIcore in bcma_bus_register(), as that
+		 * is too early in boot for embedded systems
+		 * (no udelay() available). So do it here in attach stage.
+		 */
+		if (bus->drv_pci.core)
+			bcma_core_pci_init(&bus->drv_pci);
+
+		err = bcma_register_cores(bus);
+		if (err) {
+			drop_them_all = 1;
+			list_del(&bus->attach_list);
+			continue;
+		}
+		list_del(&bus->attach_list);
+	}
+
+	return err;
+}
+
 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
@@ -157,15 +197,20 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_init(&bus->drv_cc);
 	}
 
-	/* Init PCIE core */
+	/* Find PCIE core */
 	core = bcma_find_core(bus, BCMA_CORE_PCIE);
 	if (core) {
+		/* will be initilized in bcma_attach_queued_buses() */
 		bus->drv_pci.core = core;
-		bcma_core_pci_init(&bus->drv_pci);
 	}
 
-	/* Register found cores */
-	bcma_register_cores(bus);
+	/* Queue it for attach.
+	 * See the comment at the bcma_is_early_boot definition. */
+	list_add_tail(&bus->attach_list, &attach_queue);
+	if (!bcma_is_early_boot) {
+		/* This is not early boot, so we must attach the bus now */
+		bcma_attach_queued_buses();
+	}
 
 	pr_info("Bus registered\n");
 
@@ -247,10 +292,22 @@ static int __init bcma_modinit(void)
 {
 	int err;
 
+	/* See the comment at the bcma_is_early_boot definition */
+	bcma_is_early_boot = 0;
+
 	err = bus_register(&bcma_bus_type);
 	if (err)
 		return err;
 
+	/* Maybe we already registered some buses at early boot.
+	 * Check for this and attach them.
+	 */
+	err = bcma_attach_queued_buses();
+	if (err) {
+		pr_err("Attaching core registered in early boot failed\n");
+		err = 0;
+	}
+
 #ifdef CONFIG_BCMA_HOST_PCI
 	err = bcma_host_pci_init();
 	if (err) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 3dc5302..8b6feca 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -195,6 +195,9 @@ struct bcma_bus {
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
+
+	/* Internal-only stuff follows. Do not touch. */
+	struct list_head attach_list;
 };
 
 extern inline u32 bcma_read8(struct bcma_device *core, u16 offset)
-- 
1.7.4.1

