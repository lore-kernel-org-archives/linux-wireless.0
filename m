Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33635 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbcCCF2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 00:28:32 -0500
Received: by mail-pa0-f67.google.com with SMTP id gc2so54881pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 21:28:31 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: remove typedef from struct sdio_cmd52_t
Date: Thu,  3 Mar 2016 14:28:20 +0900
Message-Id: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_062835_043681_4DA742E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct sdio_cmd52_t and renames it to
sdio_cmd52.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c    | 26 +++++++++++++-------------
 drivers/staging/wilc1000/wilc_wlan_if.h |  4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 029bd09..37fa1ed 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -51,7 +51,7 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 	sdio_claim_host(func);
 }
 
-static int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
+static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int ret;
@@ -145,7 +145,7 @@ static void linux_sdio_remove(struct sdio_func *func)
 
 static int sdio_reset(struct wilc *wilc)
 {
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 	int ret;
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 
@@ -266,7 +266,7 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
 static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 	int ret;
 
 	/**
@@ -307,7 +307,7 @@ _fail_:
 static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 	int ret;
 
 	cmd.read_write = 1;
@@ -343,7 +343,7 @@ _fail_:
 static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 	int ret;
 
 	cmd.read_write = 1;
@@ -382,7 +382,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	data = cpu_to_le32(data);
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
-		sdio_cmd52_t cmd;
+		struct sdio_cmd52 cmd;
 
 		cmd.read_write = 1;
 		cmd.function = 0;
@@ -522,7 +522,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 	int ret;
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
-		sdio_cmd52_t cmd;
+		struct sdio_cmd52 cmd;
 
 		cmd.read_write = 0;
 		cmd.function = 0;
@@ -670,7 +670,7 @@ static int sdio_deinit(struct wilc *wilc)
 static int sdio_init(struct wilc *wilc, bool resume)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 	int loop, ret;
 	u32 chipid;
 
@@ -791,7 +791,7 @@ _fail_:
 static int sdio_read_size(struct wilc *wilc, u32 *size)
 {
 	u32 tmp;
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 
 	/**
 	 *      Read DMA count in words
@@ -820,7 +820,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 tmp;
-	sdio_cmd52_t cmd;
+	struct sdio_cmd52 cmd;
 
 	sdio_read_size(wilc, &tmp);
 
@@ -899,7 +899,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		if ((val & EN_VMM) == EN_VMM)
 			reg |= BIT(7);
 		if (reg) {
-			sdio_cmd52_t cmd;
+			struct sdio_cmd52 cmd;
 
 			cmd.read_write = 1;
 			cmd.function = 0;
@@ -929,7 +929,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				ret = 1;
 				for (i = 0; i < g_sdio.nint; i++) {
 					if (flags & 1) {
-						sdio_cmd52_t cmd;
+						struct sdio_cmd52 cmd;
 
 						cmd.read_write = 1;
 						cmd.function = 0;
@@ -977,7 +977,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				vmm_ctl |= BIT(2);
 
 			if (vmm_ctl) {
-				sdio_cmd52_t cmd;
+				struct sdio_cmd52 cmd;
 
 				cmd.read_write = 1;
 				cmd.function = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index f19ecb5..99aaec7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -50,13 +50,13 @@
  *
  ********************************************/
 
-typedef struct {
+struct sdio_cmd52 {
 	u32 read_write:		1;
 	u32 function:		3;
 	u32 raw:		1;
 	u32 address:		17;
 	u32 data:		8;
-} sdio_cmd52_t;
+};
 
 typedef struct {
 	/* struct { */
-- 
2.7.1

