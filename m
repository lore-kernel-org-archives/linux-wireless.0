Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37071 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3C0QRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:17:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: mark eromptr as __iomem
Date: Wed, 27 Mar 2013 17:16:58 +0100
Message-Id: <1364401018-25534-1-git-send-email-hauke@hauke-m.de> (sfid-20130327_171739_022256_B6920BE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some sparse warnings.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 8d0b571..bca9c80 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -137,19 +137,19 @@ static void bcma_scan_switch_core(struct bcma_bus *bus, u32 addr)
 				       addr);
 }
 
-static u32 bcma_erom_get_ent(struct bcma_bus *bus, u32 **eromptr)
+static u32 bcma_erom_get_ent(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent = readl(*eromptr);
 	(*eromptr)++;
 	return ent;
 }
 
-static void bcma_erom_push_ent(u32 **eromptr)
+static void bcma_erom_push_ent(u32 __iomem **eromptr)
 {
 	(*eromptr)--;
 }
 
-static s32 bcma_erom_get_ci(struct bcma_bus *bus, u32 **eromptr)
+static s32 bcma_erom_get_ci(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
 	if (!(ent & SCAN_ER_VALID))
@@ -159,14 +159,14 @@ static s32 bcma_erom_get_ci(struct bcma_bus *bus, u32 **eromptr)
 	return ent;
 }
 
-static bool bcma_erom_is_end(struct bcma_bus *bus, u32 **eromptr)
+static bool bcma_erom_is_end(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
 	bcma_erom_push_ent(eromptr);
 	return (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID));
 }
 
-static bool bcma_erom_is_bridge(struct bcma_bus *bus, u32 **eromptr)
+static bool bcma_erom_is_bridge(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
 	bcma_erom_push_ent(eromptr);
@@ -175,7 +175,7 @@ static bool bcma_erom_is_bridge(struct bcma_bus *bus, u32 **eromptr)
 		((ent & SCAN_ADDR_TYPE) == SCAN_ADDR_TYPE_BRIDGE));
 }
 
-static void bcma_erom_skip_component(struct bcma_bus *bus, u32 **eromptr)
+static void bcma_erom_skip_component(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent;
 	while (1) {
@@ -189,7 +189,7 @@ static void bcma_erom_skip_component(struct bcma_bus *bus, u32 **eromptr)
 	bcma_erom_push_ent(eromptr);
 }
 
-static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr)
+static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
 	if (!(ent & SCAN_ER_VALID))
@@ -199,7 +199,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr)
 	return ent;
 }
 
-static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 **eromptr,
+static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
 	u32 addrl, addrh, sizel, sizeh = 0;
-- 
1.7.10.4

