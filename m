Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:51463 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdE3LU7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 07:20:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] bcm47xx: fix build regression
Date: Tue, 30 May 2017 13:20:12 +0200
Message-Id: <20170530112027.3983554-1-arnd@arndb.de> (sfid-20170530_132104_494343_5F6B356B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An unknown change in the kernel headers caused a build regression
in an MTD partition driver:

In file included from drivers/mtd/bcm47xxpart.c:12:0:
include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first use in this function)

Clearly we want to include linux/errno.h here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/bcm47xx_nvram.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
index 2793652fbf66..a414a2b53e41 100644
--- a/include/linux/bcm47xx_nvram.h
+++ b/include/linux/bcm47xx_nvram.h
@@ -8,6 +8,7 @@
 #ifndef __BCM47XX_NVRAM_H
 #define __BCM47XX_NVRAM_H
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
-- 
2.9.0
