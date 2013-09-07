Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53683 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab3IGPDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Sep 2013 11:03:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	arend@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3.12] bcma: fix error code handling on 64 Bit systems
Date: Sat,  7 Sep 2013 17:02:49 +0200
Message-Id: <1378566169-24302-1-git-send-email-hauke@hauke-m.de> (sfid-20130907_170314_289479_B2714671)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On most 64 Bit systems unsigned long is 64 bit long and then -MAX_ERRNO
is out of the range of a u32 used to store the error code in.
This patch casts the -MAX_ERRNO to a u32 instead.

This fixes a regression introduced in:
commit fd4edf197544bae1c77d84bad354aa7ce1d08ce1
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Mon Jul 15 13:15:08 2013 +0200

    bcma: fix handling of big addrl

Reported-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Tested-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/bcma/scan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cd6b20f..3776840 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -269,6 +269,8 @@ static struct bcma_device *bcma_find_core_reverse(struct bcma_bus *bus, u16 core
 	return NULL;
 }
 
+#define IS_ERR_VALUE_U32(x) ((x) >= (u32)-MAX_ERRNO)
+
 static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device_id *match, int core_num,
 			      struct bcma_device *core)
@@ -351,11 +353,11 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	 * the main register space for the core
 	 */
 	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
-	if (tmp == 0 || IS_ERR_VALUE(tmp)) {
+	if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
 		/* Try again to see if it is a bridge */
 		tmp = bcma_erom_get_addr_desc(bus, eromptr,
 					      SCAN_ADDR_TYPE_BRIDGE, 0);
-		if (tmp == 0 || IS_ERR_VALUE(tmp)) {
+		if (tmp == 0 || IS_ERR_VALUE_U32(tmp)) {
 			return -EILSEQ;
 		} else {
 			bcma_info(bus, "Bridge found\n");
@@ -369,7 +371,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SLAVE, i);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: slave port %d "
 				 * "has %d descriptors\n", i, j); */
@@ -386,7 +388,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_MWRAP, i);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * "has %d descriptors\n", i, j); */
@@ -404,7 +406,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
 				SCAN_ADDR_TYPE_SWRAP, i + hack);
-			if (IS_ERR_VALUE(tmp)) {
+			if (IS_ERR_VALUE_U32(tmp)) {
 				/* no more entries for port _i_ */
 				/* pr_debug("erom: master wrapper %d "
 				 * has %d descriptors\n", i, j); */
-- 
1.7.10.4

