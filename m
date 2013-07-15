Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55273 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab3GOLPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] bcma: fix handling of big addrl
Date: Mon, 15 Jul 2013 13:15:08 +0200
Message-Id: <1373886908-4460-6-git-send-email-hauke@hauke-m.de> (sfid-20130715_131534_833602_0A011A13)
In-Reply-To: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
References: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of bcma_erom_get_addr_desc() is a unsigned value and it
could wrap around in the two complement writing. This happens for one
core in the BCM4708 SoC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index f2f1415..cd6b20f 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -213,7 +213,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 	return ent;
 }
 
-static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
+static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
 	u32 addrl, addrh, sizel, sizeh = 0;
@@ -225,7 +225,7 @@ static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 	    ((ent & SCAN_ADDR_TYPE) != type) ||
 	    (((ent & SCAN_ADDR_PORT) >> SCAN_ADDR_PORT_SHIFT) != port)) {
 		bcma_erom_push_ent(eromptr);
-		return -EINVAL;
+		return (u32)-EINVAL;
 	}
 
 	addrl = ent & SCAN_ADDR_ADDR;
@@ -273,7 +273,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device_id *match, int core_num,
 			      struct bcma_device *core)
 {
-	s32 tmp;
+	u32 tmp;
 	u8 i, j;
 	s32 cia, cib;
 	u8 ports[2], wrappers[2];
@@ -351,11 +351,11 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	 * the main register space for the core
 	 */
 	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
-	if (tmp <= 0) {
+	if (tmp == 0 || IS_ERR_VALUE(tmp)) {
 		/* Try again to see if it is a bridge */
 		tmp = bcma_erom_get_addr_desc(bus, eromptr,
 					      SCAN_ADDR_TYPE_BRIDGE, 0);
-		if (tmp <= 0) {
+		if (tmp == 0 || IS_ERR_VALUE(tmp)) {
 			return -EILSEQ;
 		} else {
 			bcma_info(bus, "Bridge found\n");
@@ -369,7 +369,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SLAVE, i);
-			if (tmp < 0) {
+			if (IS_ERR_VALUE(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: slave port %d "
 				 * "has %d descriptors\n", i, j); */
@@ -386,7 +386,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_MWRAP, i);
-			if (tmp < 0) {
+			if (IS_ERR_VALUE(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * "has %d descriptors\n", i, j); */
@@ -404,7 +404,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SWRAP, i + hack);
-			if (tmp < 0) {
+			if (IS_ERR_VALUE(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * has %d descriptors\n", i, j); */
-- 
1.7.10.4

