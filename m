Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59023 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab2I2SeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:34:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] bcma: add some more flash chips for serial flash
Date: Sat, 29 Sep 2012 20:33:53 +0200
Message-Id: <1348943633-22800-6-git-send-email-hauke@hauke-m.de> (sfid-20120929_203414_591602_2B374169)
In-Reply-To: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
References: <1348943633-22800-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_sflash.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index a0993fc..63e6883 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -31,15 +31,42 @@ struct bcma_sflash_tbl_e {
 };
 
 static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
-	{ "", 0x14, 0x10000, 32, },
+	{ "M25P20", 0x11, 0x10000, 4, },
+	{ "M25P40", 0x12, 0x10000, 8, },
+
+	{ "M25P16", 0x14, 0x10000, 32, },
+	{ "M25P32", 0x14, 0x10000, 64, },
+	{ "M25P64", 0x16, 0x10000, 128, },
+	{ "M25FL128", 0x17, 0x10000, 256, },
 	{ 0 },
 };
 
 static struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
+	{ "SST25WF512", 1, 0x1000, 16, },
+	{ "SST25VF512", 0x48, 0x1000, 16, },
+	{ "SST25WF010", 2, 0x1000, 32, },
+	{ "SST25VF010", 0x49, 0x1000, 32, },
+	{ "SST25WF020", 3, 0x1000, 64, },
+	{ "SST25VF020", 0x43, 0x1000, 64, },
+	{ "SST25WF040", 4, 0x1000, 128, },
+	{ "SST25VF040", 0x44, 0x1000, 128, },
+	{ "SST25VF040B", 0x8d, 0x1000, 128, },
+	{ "SST25WF080", 5, 0x1000, 256, },
+	{ "SST25VF080B", 0x8e, 0x1000, 256, },
+	{ "SST25VF016", 0x41, 0x1000, 512, },
+	{ "SST25VF032", 0x4a, 0x1000, 1024, },
+	{ "SST25VF064", 0x4b, 0x1000, 2048, },
 	{ 0 },
 };
 
 static struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
+	{ "AT45DB011", 0xc, 256, 512, },
+	{ "AT45DB021", 0x14, 256, 1024, },
+	{ "AT45DB041", 0x1c, 256, 2048, },
+	{ "AT45DB081", 0x24, 256, 4096, },
+	{ "AT45DB161", 0x2c, 512, 4096, },
+	{ "AT45DB321", 0x34, 512, 8192, },
+	{ "AT45DB642", 0x3c, 1024, 8192, },
 	{ 0 },
 };
 
@@ -84,6 +111,8 @@ int bcma_sflash_init(struct bcma_drv_cc *cc)
 					break;
 			}
 			break;
+		case 0x13:
+			return -ENOTSUPP;
 		default:
 			for (e = bcma_sflash_st_tbl; e->name; e++) {
 				if (e->id == id)
-- 
1.7.9.5

