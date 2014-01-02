Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51313 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaABSbn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:43 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] bcma: fix sparse warnings in driver_chipcommon_sflash.c
Date: Thu,  2 Jan 2014 19:31:36 +0100
Message-Id: <1388687497-8645-1-git-send-email-hauke@hauke-m.de> (sfid-20140102_193154_138715_4DA87CD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/bcma/driver_chipcommon_sflash.c
drivers/bcma/driver_chipcommon_sflash.c:41:11: warning: Using plain integer as NULL pointer
drivers/bcma/driver_chipcommon_sflash.c:59:11: warning: Using plain integer as NULL pointer
drivers/bcma/driver_chipcommon_sflash.c:70:11: warning: Using plain integer as NULL pointer

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_sflash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 4d07cce..7e11ef4 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -38,7 +38,7 @@ static const struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
 	{ "M25P32", 0x15, 0x10000, 64, },
 	{ "M25P64", 0x16, 0x10000, 128, },
 	{ "M25FL128", 0x17, 0x10000, 256, },
-	{ 0 },
+	{ NULL },
 };
 
 static const struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
@@ -56,7 +56,7 @@ static const struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
 	{ "SST25VF016", 0x41, 0x1000, 512, },
 	{ "SST25VF032", 0x4a, 0x1000, 1024, },
 	{ "SST25VF064", 0x4b, 0x1000, 2048, },
-	{ 0 },
+	{ NULL },
 };
 
 static const struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
@@ -67,7 +67,7 @@ static const struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
 	{ "AT45DB161", 0x2c, 512, 4096, },
 	{ "AT45DB321", 0x34, 512, 8192, },
 	{ "AT45DB642", 0x3c, 1024, 8192, },
-	{ 0 },
+	{ NULL },
 };
 
 static void bcma_sflash_cmd(struct bcma_drv_cc *cc, u32 opcode)
-- 
1.7.10.4

