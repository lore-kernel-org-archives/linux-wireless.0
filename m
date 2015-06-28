Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35540 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbF1PRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2015 11:17:23 -0400
Received: by lagh6 with SMTP id h6so28408234lag.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2015 08:17:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: populate bus DT subnodes as platform_device-s
Date: Sun, 28 Jun 2015 17:17:13 +0200
Message-Id: <1435504633-20831-1-git-send-email-zajec5@gmail.com> (sfid-20150628_171728_455332_F478A2B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our bus should allow defining children nodes as we may want to specify
devices attached to the bus. This is required e.g. to specify NAND or
ChipCommon cores and use bus's address and IRQ mappings.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 9635f10..5912847 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/of_platform.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
@@ -409,6 +410,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_early_init(&bus->drv_pci[0]);
 	}
 
+	if (bus->host_pdev) {
+		struct device *dev = &bus->host_pdev->dev;
+
+		of_platform_populate(dev->of_node, of_default_bus_match_table,
+				     NULL, dev);
+	}
+
 	/* Cores providing flash access go before SPROM init */
 	list_for_each_entry(core, &bus->cores, list) {
 		if (bcma_is_core_needed_early(core->id.id))
-- 
1.8.4.5

