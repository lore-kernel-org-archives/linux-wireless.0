Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:50594 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FQRTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:19:32 -0400
Received: by mail-ea0-f178.google.com with SMTP id l15so1948565eak.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 10:19:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: use const for serial flash hardware table
Date: Mon, 17 Jun 2013 19:19:19 +0200
Message-Id: <1371489560-30433-1-git-send-email-zajec5@gmail.com> (sfid-20130617_191935_517778_4F6BA3DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon_sflash.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
index 720665c..1b9e770 100644
--- a/drivers/ssb/driver_chipcommon_sflash.c
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -16,7 +16,7 @@ struct ssb_sflash_tbl_e {
 	u16 numblocks;
 };
 
-static struct ssb_sflash_tbl_e ssb_sflash_st_tbl[] = {
+static const struct ssb_sflash_tbl_e ssb_sflash_st_tbl[] = {
 	{ "M25P20", 0x11, 0x10000, 4, },
 	{ "M25P40", 0x12, 0x10000, 8, },
 
@@ -27,7 +27,7 @@ static struct ssb_sflash_tbl_e ssb_sflash_st_tbl[] = {
 	{ 0 },
 };
 
-static struct ssb_sflash_tbl_e ssb_sflash_sst_tbl[] = {
+static const struct ssb_sflash_tbl_e ssb_sflash_sst_tbl[] = {
 	{ "SST25WF512", 1, 0x1000, 16, },
 	{ "SST25VF512", 0x48, 0x1000, 16, },
 	{ "SST25WF010", 2, 0x1000, 32, },
@@ -45,7 +45,7 @@ static struct ssb_sflash_tbl_e ssb_sflash_sst_tbl[] = {
 	{ 0 },
 };
 
-static struct ssb_sflash_tbl_e ssb_sflash_at_tbl[] = {
+static const struct ssb_sflash_tbl_e ssb_sflash_at_tbl[] = {
 	{ "AT45DB011", 0xc, 256, 512, },
 	{ "AT45DB021", 0x14, 256, 1024, },
 	{ "AT45DB041", 0x1c, 256, 2048, },
@@ -73,7 +73,7 @@ static void ssb_sflash_cmd(struct ssb_chipcommon *cc, u32 opcode)
 /* Initialize serial flash access */
 int ssb_sflash_init(struct ssb_chipcommon *cc)
 {
-	struct ssb_sflash_tbl_e *e;
+	const struct ssb_sflash_tbl_e *e;
 	u32 id, id2;
 
 	switch (cc->capabilities & SSB_CHIPCO_CAP_FLASHT) {
-- 
1.7.10.4

