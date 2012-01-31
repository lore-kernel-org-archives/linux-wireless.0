Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39649 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2AaXON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:14:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] bcma: log the id, rev and pkg of the chip found
Date: Wed,  1 Feb 2012 00:13:54 +0100
Message-Id: <1328051636-15449-3-git-send-email-hauke@hauke-m.de> (sfid-20120201_001417_962439_E23B1102)
In-Reply-To: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
References: <1328051636-15449-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes us see what type of hardware someone uses by the dmesg
output.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cad9948..a6f17fe 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -353,6 +353,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 void bcma_init_bus(struct bcma_bus *bus)
 {
 	s32 tmp;
+	struct bcma_chipinfo *chipinfo = &(bus->chipinfo);
 
 	if (bus->init_done)
 		return;
@@ -363,9 +364,12 @@ void bcma_init_bus(struct bcma_bus *bus)
 	bcma_scan_switch_core(bus, BCMA_ADDR_BASE);
 
 	tmp = bcma_scan_read32(bus, 0, BCMA_CC_ID);
-	bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
-	bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
-	bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+	chipinfo->id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
+	chipinfo->rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
+	chipinfo->pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+	pr_info("Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
+		chipinfo->id, chipinfo->rev, chipinfo->pkg);
+
 	bus->init_done = true;
 }
 
-- 
1.7.5.4

