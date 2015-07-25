Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:59965 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbbGYTKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 15:10:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@codeaurora.org
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	manabian@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: fix build error when build as module
Date: Sat, 25 Jul 2015 21:10:27 +0200
Message-Id: <1437851427-7485-1-git-send-email-hauke@hauke-m.de> (sfid-20150725_211316_415670_BCE4A909)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently of_default_bus_match_table is not exported so we can only use
this feature when bcma is build into the kernel. This patch removes
support for child buses when bcma is build as a module as a temporary
fix for a build problem introduces in this commit:

commit cae761b5a6bdc597ba476a040fdcd5b4bc559b85
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Sun Jun 28 17:17:13 2015 +0200

    bcma: populate bus DT subnodes as platform_device-s

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 5912847..8d973c4 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -410,7 +410,11 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_early_init(&bus->drv_pci[0]);
 	}
 
-	if (bus->host_pdev) {
+	/* TODO: remove check for IS_BUILTIN(CONFIG_BCMA) check when
+	 * of_default_bus_match_table is exported or in some other way
+	 * accessible. This is just a temporary workaround.
+	 */
+	if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
 		struct device *dev = &bus->host_pdev->dev;
 
 		of_platform_populate(dev->of_node, of_default_bus_match_table,
-- 
2.1.4

