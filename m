Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35949 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab2A3XES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 18:04:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] bcma: add the core unit number
Date: Tue, 31 Jan 2012 00:03:31 +0100
Message-Id: <1327964617-7910-2-git-send-email-hauke@hauke-m.de> (sfid-20120131_000422_768813_6ACB162C)
In-Reply-To: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
References: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some SoCs have two pcie or gmac cores and we need to know the number of
the specific core on the bus. This is the case for the BCM4706.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c       |   14 ++++++++++++++
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cad9948..e513aa8 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -212,6 +212,17 @@ static struct bcma_device *bcma_find_core_by_index(struct bcma_bus *bus,
 	return NULL;
 }
 
+static struct bcma_device *bcma_find_core_reverse(struct bcma_bus *bus, u16 coreid)
+{
+	struct bcma_device *core;
+
+	list_for_each_entry_reverse(core, &bus->cores, list) {
+		if (core->id.id == coreid)
+			return core;
+	}
+	return NULL;
+}
+
 static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device_id *match, int core_num,
 			      struct bcma_device *core)
@@ -392,6 +403,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	bcma_scan_switch_core(bus, erombase);
 
 	while (eromptr < eromend) {
+		struct bcma_device *other_core;
 		struct bcma_device *core = kzalloc(sizeof(*core), GFP_KERNEL);
 		if (!core)
 			return -ENOMEM;
@@ -411,6 +423,8 @@ int bcma_bus_scan(struct bcma_bus *bus)
 
 		core->core_index = core_num++;
 		bus->nr_cores++;
+		other_core = bcma_find_core_reverse(bus, core->id.id);
+		core->core_unit = (other_core == NULL) ? 0 : other_core->core_unit + 1;
 
 		pr_info("Core %d found: %s "
 			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 83c209f..024a6e2 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -136,6 +136,7 @@ struct bcma_device {
 	bool dev_registered;
 
 	u8 core_index;
+	u8 core_unit;
 
 	u32 addr;
 	u32 wrap;
-- 
1.7.5.4

