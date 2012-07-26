Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60840 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab2GZPqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 11:46:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	fengguang.wu@intel.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add missing iounmap on error path
Date: Thu, 26 Jul 2012 17:45:52 +0200
Message-Id: <1343317552-3918-1-git-send-email-hauke@hauke-m.de> (sfid-20120726_174623_568392_CA22D6FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix the problem reported by Fengguang:

The coccinelle static checker emits these warnings:

drivers/bcma/scan.c:466:3-9: ERROR: missing iounmap; ioremap on line 451 and execution via conditional on line 465
drivers/bcma/scan.c:540:3-9: ERROR: missing iounmap; ioremap on line 515 and execution via conditional on line 539

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 5672b13..8d0b571 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -462,8 +462,10 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	while (eromptr < eromend) {
 		struct bcma_device *other_core;
 		struct bcma_device *core = kzalloc(sizeof(*core), GFP_KERNEL);
-		if (!core)
-			return -ENOMEM;
+		if (!core) {
+			err = -ENOMEM;
+			goto out;
+		}
 		INIT_LIST_HEAD(&core->list);
 		core->bus = bus;
 
@@ -478,7 +480,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 			} else if (err == -ESPIPE) {
 				break;
 			}
-			return err;
+			goto out;
 		}
 
 		core->core_index = core_num++;
@@ -494,10 +496,12 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		list_add_tail(&core->list, &bus->cores);
 	}
 
+	err = 0;
+out:
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
 		iounmap(eromptr);
 
-	return 0;
+	return err;
 }
 
 int __init bcma_bus_scan_early(struct bcma_bus *bus,
@@ -537,7 +541,7 @@ int __init bcma_bus_scan_early(struct bcma_bus *bus,
 		else if (err == -ESPIPE)
 			break;
 		else if (err < 0)
-			return err;
+			goto out;
 
 		core->core_index = core_num++;
 		bus->nr_cores++;
@@ -551,6 +555,7 @@ int __init bcma_bus_scan_early(struct bcma_bus *bus,
 		break;
 	}
 
+out:
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
 		iounmap(eromptr);
 
-- 
1.7.9.5

