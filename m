Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38680 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3ACXvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:42 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/6] bcma: make bcma_find_core_unit() accessible
Date: Fri,  4 Jan 2013 00:51:20 +0100
Message-Id: <1357257085-11822-2-git-send-email-hauke@hauke-m.de> (sfid-20130104_005149_327798_6FE2EF7B)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This bcma_find_core_unit() is needed by the mips driver in the next
patch.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h |    2 ++
 drivers/bcma/main.c         |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 4a2d72e..d35294e 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -31,6 +31,8 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 int bcma_bus_suspend(struct bcma_bus *bus);
 int bcma_bus_resume(struct bcma_bus *bus);
 #endif
+struct bcma_device *bcma_find_core_unit(struct bcma_bus *bus, u16 coreid,
+					u8 unit);
 
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 53ba20c..d12b7da 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -81,8 +81,8 @@ struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 }
 EXPORT_SYMBOL_GPL(bcma_find_core);
 
-static struct bcma_device *bcma_find_core_unit(struct bcma_bus *bus, u16 coreid,
-					       u8 unit)
+struct bcma_device *bcma_find_core_unit(struct bcma_bus *bus, u16 coreid,
+					u8 unit)
 {
 	struct bcma_device *core;
 
-- 
1.7.10.4

