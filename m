Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35007 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcCCF2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 00:28:38 -0500
Received: by mail-pf0-f194.google.com with SMTP id w128so717499pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 21:28:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: remove typedef from sdio_cmd53_t
Date: Thu,  3 Mar 2016 14:28:22 +0900
Message-Id: <1456982904-8063-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_062858_380069_A9EF3131)
In-Reply-To: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct sdio_cmd53_t and renames it to
sdio_cmd53.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c    | 10 +++++-----
 drivers/staging/wilc1000/wilc_wlan_if.h |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 37fa1ed..a839a79 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -81,7 +81,7 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
 }
 
 
-static int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
+static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int size, ret;
@@ -396,7 +396,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 			goto _fail_;
 		}
 	} else {
-		sdio_cmd53_t cmd;
+		struct sdio_cmd53 cmd;
 
 		/**
 		 *      set the AHB address
@@ -431,7 +431,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
-	sdio_cmd53_t cmd;
+	struct sdio_cmd53 cmd;
 	int nblk, nleft, ret;
 
 	cmd.read_write = 1;
@@ -536,7 +536,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		}
 		*data = cmd.data;
 	} else {
-		sdio_cmd53_t cmd;
+		struct sdio_cmd53 cmd;
 
 		if (!sdio_set_func0_csa_address(wilc, addr))
 			goto _fail_;
@@ -571,7 +571,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
-	sdio_cmd53_t cmd;
+	struct sdio_cmd53 cmd;
 	int nblk, nleft, ret;
 
 	cmd.read_write = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index dcde9ef..9eb123b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -58,7 +58,7 @@ struct sdio_cmd52 {
 	u32 data:		8;
 };
 
-typedef struct {
+struct sdio_cmd53 {
 	u32 read_write:		1;
 	u32 function:		3;
 	u32 block_mode:		1;
@@ -67,7 +67,7 @@ typedef struct {
 	u32 count:		9;
 	u8 *buffer;
 	u32 block_size;
-} sdio_cmd53_t;
+};
 
 #define WILC_MAC_INDICATE_STATUS	0x1
 #define WILC_MAC_STATUS_INIT		-1
-- 
2.7.1

