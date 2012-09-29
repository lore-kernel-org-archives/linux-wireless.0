Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58949 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2SaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:30:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] bcma: init sprom struct earlier
Date: Sat, 29 Sep 2012 20:29:50 +0200
Message-Id: <1348943390-22411-3-git-send-email-hauke@hauke-m.de> (sfid-20120929_203054_698733_91BA0645)
In-Reply-To: <1348943390-22411-1-git-send-email-hauke@hauke-m.de>
References: <1348943390-22411-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIe host driver and the chip common initialisation accesses the
sprom struct, but it is not initialized when these functions are run.
Move the sprom parsing up in to do it earlier.
As we need the chip common core rev and some other attributes from the
chip common core, the early initialization is done before accessing the
sprom.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index bea2d7c..d6b5c4c 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -182,6 +182,20 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 		return -1;
 	}
 
+	/* Early init CC core */
+	core = bcma_find_core(bus, bcma_cc_core_id(bus));
+	if (core) {
+		bus->drv_cc.core = core;
+		bcma_core_chipcommon_early_init(&bus->drv_cc);
+	}
+
+	/* Try to get SPROM */
+	err = bcma_sprom_get(bus);
+	if (err == -ENOENT) {
+		bcma_err(bus, "No SPROM available\n");
+	} else if (err)
+		bcma_err(bus, "Failed to get SPROM: %d\n", err);
+
 	/* Init CC core */
 	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
@@ -210,13 +224,6 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_gmac_cmn_init(&bus->drv_gmac_cmn);
 	}
 
-	/* Try to get SPROM */
-	err = bcma_sprom_get(bus);
-	if (err == -ENOENT) {
-		bcma_err(bus, "No SPROM available\n");
-	} else if (err)
-		bcma_err(bus, "Failed to get SPROM: %d\n", err);
-
 	/* Register found cores */
 	bcma_register_cores(bus);
 
-- 
1.7.9.5

