Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51320 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaABSbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:46 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ssb: fix sparse warnings in driver_chipcommon_sflash.c
Date: Thu,  2 Jan 2014 19:31:37 +0100
Message-Id: <1388687497-8645-2-git-send-email-hauke@hauke-m.de> (sfid-20140102_193154_726353_46AEF5E0)
In-Reply-To: <1388687497-8645-1-git-send-email-hauke@hauke-m.de>
References: <1388687497-8645-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/ssb/driver_chipcommon_sflash.c
drivers/ssb/driver_chipcommon_sflash.c:40:11: warning: Using plain integer as NULL pointer
drivers/ssb/driver_chipcommon_sflash.c:58:11: warning: Using plain integer as NULL pointer
drivers/ssb/driver_chipcommon_sflash.c:69:11: warning: Using plain integer as NULL pointer

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon_sflash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
index 50328de..937fc31 100644
--- a/drivers/ssb/driver_chipcommon_sflash.c
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -37,7 +37,7 @@ static const struct ssb_sflash_tbl_e ssb_sflash_st_tbl[] = {
 	{ "M25P32", 0x15, 0x10000, 64, },
 	{ "M25P64", 0x16, 0x10000, 128, },
 	{ "M25FL128", 0x17, 0x10000, 256, },
-	{ 0 },
+	{ NULL },
 };
 
 static const struct ssb_sflash_tbl_e ssb_sflash_sst_tbl[] = {
@@ -55,7 +55,7 @@ static const struct ssb_sflash_tbl_e ssb_sflash_sst_tbl[] = {
 	{ "SST25VF016", 0x41, 0x1000, 512, },
 	{ "SST25VF032", 0x4a, 0x1000, 1024, },
 	{ "SST25VF064", 0x4b, 0x1000, 2048, },
-	{ 0 },
+	{ NULL },
 };
 
 static const struct ssb_sflash_tbl_e ssb_sflash_at_tbl[] = {
@@ -66,7 +66,7 @@ static const struct ssb_sflash_tbl_e ssb_sflash_at_tbl[] = {
 	{ "AT45DB161", 0x2c, 512, 4096, },
 	{ "AT45DB321", 0x34, 512, 8192, },
 	{ "AT45DB642", 0x3c, 1024, 8192, },
-	{ 0 },
+	{ NULL },
 };
 
 static void ssb_sflash_cmd(struct ssb_chipcommon *cc, u32 opcode)
-- 
1.7.10.4

