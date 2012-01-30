Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35991 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab2A3XEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 18:04:30 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/7] bcma: add bus num counter
Date: Tue, 31 Jan 2012 00:03:36 +0100
Message-Id: <1327964617-7910-7-git-send-email-hauke@hauke-m.de> (sfid-20120131_000433_724604_DC6E5BB9)
In-Reply-To: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
References: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have two bcma buses on one computer the second will not work
without this patch. Now each bus gets an own number.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c       |   12 +++++++++++-
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 3363036..bcd1c01 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -13,6 +13,12 @@
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
 
+/* contains the number the next bus should get. */
+static unsigned int bcma_bus_next_num = 0;
+
+/* bcma_buses_mutex locks the bcma_bus_next_num */
+static DEFINE_MUTEX(bcma_buses_mutex);
+
 static int bcma_bus_match(struct device *dev, struct device_driver *drv);
 static int bcma_device_probe(struct device *dev);
 static int bcma_device_remove(struct device *dev);
@@ -93,7 +99,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
 		core->dev.release = bcma_release_core_dev;
 		core->dev.bus = &bcma_bus_type;
-		dev_set_name(&core->dev, "bcma%d:%d", 0/*bus->num*/, dev_id);
+		dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
 
 		switch (bus->hosttype) {
 		case BCMA_HOSTTYPE_PCI:
@@ -137,6 +143,10 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	int err;
 	struct bcma_device *core;
 
+	mutex_lock(&bcma_buses_mutex);
+	bus->num = bcma_bus_next_num++;
+	mutex_unlock(&bcma_buses_mutex);
+
 	/* Scan for devices (cores) */
 	err = bcma_bus_scan(bus);
 	if (err) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 024a6e2..b9f65fb 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -196,6 +196,7 @@ struct bcma_bus {
 	struct list_head cores;
 	u8 nr_cores;
 	u8 init_done:1;
+	u8 num;
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
-- 
1.7.5.4

