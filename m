Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47473 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1FSVwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 17:52:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC v2 02/12] bcma: move initializing of struct bcma_bus to own function.
Date: Sun, 19 Jun 2011 23:49:59 +0200
Message-Id: <1308520209-668-3-git-send-email-hauke@hauke-m.de> (sfid-20110619_235206_846971_284F7D4C)
In-Reply-To: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to use this code in some other method.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 4012d8d..7970553 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -312,15 +312,10 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	return 0;
 }
 
-int bcma_bus_scan(struct bcma_bus *bus)
+static void bcma_init_bus(struct bcma_bus *bus)
 {
-	u32 erombase;
-	u32 __iomem *eromptr, *eromend;
-
 	s32 tmp;
 
-	int err;
-
 	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
 
@@ -330,6 +325,16 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
 	bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
 	bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+}
+
+int bcma_bus_scan(struct bcma_bus *bus)
+{
+	u32 erombase;
+	u32 __iomem *eromptr, *eromend;
+
+	int err;
+
+	bcma_init_bus(bus);
 
 	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
 	eromptr = bus->mmio;
-- 
1.7.4.1

