Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55850 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3FQRTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:19:35 -0400
Received: by mail-ea0-f173.google.com with SMTP id g15so2006766eak.18
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 10:19:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: use const for serial flash hardware table
Date: Mon, 17 Jun 2013 19:19:20 +0200
Message-Id: <1371489560-30433-2-git-send-email-zajec5@gmail.com> (sfid-20130617_191938_203394_046735E7)
In-Reply-To: <1371489560-30433-1-git-send-email-zajec5@gmail.com>
References: <1371489560-30433-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_sflash.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index e6ed4fe..4d07cce 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -30,7 +30,7 @@ struct bcma_sflash_tbl_e {
 	u16 numblocks;
 };
 
-static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
+static const struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
 	{ "M25P20", 0x11, 0x10000, 4, },
 	{ "M25P40", 0x12, 0x10000, 8, },
 
@@ -41,7 +41,7 @@ static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
 	{ 0 },
 };
 
-static struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
+static const struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
 	{ "SST25WF512", 1, 0x1000, 16, },
 	{ "SST25VF512", 0x48, 0x1000, 16, },
 	{ "SST25WF010", 2, 0x1000, 32, },
@@ -59,7 +59,7 @@ static struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
 	{ 0 },
 };
 
-static struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
+static const struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
 	{ "AT45DB011", 0xc, 256, 512, },
 	{ "AT45DB021", 0x14, 256, 1024, },
 	{ "AT45DB041", 0x1c, 256, 2048, },
@@ -89,7 +89,7 @@ int bcma_sflash_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
 	struct bcma_sflash *sflash = &cc->sflash;
-	struct bcma_sflash_tbl_e *e;
+	const struct bcma_sflash_tbl_e *e;
 	u32 id, id2;
 
 	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
-- 
1.7.10.4

