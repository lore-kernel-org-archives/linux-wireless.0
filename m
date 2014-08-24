Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43953 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaHXVZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 17:25:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 6/7] bcma: get sprom from devicetree
Date: Sun, 24 Aug 2014 23:24:44 +0200
Message-Id: <1408915485-8078-8-git-send-email-hauke@hauke-m.de> (sfid-20140824_232547_173751_BAF4144E)
In-Reply-To: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make it possible to device an sprom provider in device tree
and get the sprom from this driver. Every time there is such a provider
it gets asked for a sprom.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/sprom.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index efb037f..ebe495d 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -15,6 +15,8 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 static int(*get_fallback_sprom)(struct bcma_bus *dev, struct ssb_sprom *out);
 
@@ -46,6 +48,46 @@ int bcma_arch_register_fallback_sprom(int (*sprom_callback)(struct bcma_bus *bus
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static int bcma_fill_sprom_with_dt(struct bcma_bus *bus,
+				   struct ssb_sprom *out)
+{
+	const __be32 *handle;
+	struct device_node *sprom_node;
+	struct platform_device *sprom_dev;
+	struct ssb_sprom *sprom;
+
+	if (!bus->host_pdev || !bus->host_pdev->dev.of_node)
+		return -ENOENT;
+
+	handle = of_get_property(bus->host_pdev->dev.of_node, "sprom", NULL);
+	if (!handle)
+		return -ENOENT;
+
+	sprom_node = of_find_node_by_phandle(be32_to_cpup(handle));
+	if (!sprom_node)
+		return -ENOENT;
+
+	sprom_dev = of_find_device_by_node(sprom_node);
+	if (!sprom_dev)
+		return -ENOENT;
+
+	sprom = platform_get_drvdata(sprom_dev);
+	if (!sprom)
+		return -ENOENT;
+
+	memcpy(out, sprom, sizeof(*out));
+
+	return 0;
+}
+#else
+static int bcma_fill_sprom_with_dt(struct bcma_bus *bus,
+				   struct ssb_sprom *out)
+{
+	return -ENOENT;
+}
+#endif
+
 static int bcma_fill_sprom_with_fallback(struct bcma_bus *bus,
 					 struct ssb_sprom *out)
 {
@@ -580,7 +622,14 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	u16 *sprom;
 	size_t sprom_sizes[] = { SSB_SPROMSIZE_WORDS_R4,
 				 SSB_SPROMSIZE_WORDS_R10, };
-	int i, err = 0;
+	int i, err;
+
+	err = bcma_fill_sprom_with_dt(bus, &bus->sprom);
+	if (err == 0) {
+		bcma_info(bus, "Found sprom from device tree provider\n");
+		return 0;
+	}
+	err = 0;
 
 	if (!bus->drv_cc.core)
 		return -EOPNOTSUPP;
-- 
1.9.1

