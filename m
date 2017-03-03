Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36408 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdCCKel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 05:34:41 -0500
Received: by mail-lf0-f67.google.com with SMTP id g70so6712972lfh.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 02:34:23 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.12 1/2] bcma: use helper function to set core dev's parent
Date: Fri,  3 Mar 2017 11:34:14 +0100
Message-Id: <20170303103415.5188-1-zajec5@gmail.com> (sfid-20170303_113739_161065_3828EE56)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

A tiny code deduplication thanks to the bcma_bus_get_host_dev.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 12da68ec48ba..4f88821c1b2a 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -242,17 +242,16 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
+	core->dev.parent = bcma_bus_get_host_dev(bus);
 
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
-		core->dev.parent = &bus->host_pci->dev;
 		core->dma_dev = &bus->host_pci->dev;
 		core->irq = bus->host_pci->irq;
 		break;
 	case BCMA_HOSTTYPE_SOC:
 		if (IS_ENABLED(CONFIG_OF) && bus->host_pdev) {
 			core->dma_dev = &bus->host_pdev->dev;
-			core->dev.parent = &bus->host_pdev->dev;
 			if (core->dev.parent)
 				bcma_of_fill_device(core->dev.parent, core);
 		} else {
-- 
2.11.0
