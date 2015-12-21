Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11373 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbLUFQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 14/46] staging: wilc1000: wilc_sdio_cmd53: return linux error value
Date: Mon, 21 Dec 2015 14:18:18 +0900
Message-ID: <1450675130-17866-15-git-send-email-glen.lee@atmel.com> (sfid-20151221_063100_558890_9DC19BD7)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return value with linux error value, not 1 or 0.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  7 ++-----
 drivers/staging/wilc1000/wilc_sdio.c       | 26 ++++++++++++++++----------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 64fb81b..a918de9 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -83,13 +83,10 @@ int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
 
 	sdio_release_host(func);
 
-
-	if (ret < 0) {
+	if (ret)
 		dev_err(&func->dev, "wilc_sdio_cmd53..failed, err(%d)\n", ret);
-		return 0;
-	}
 
-	return 1;
+	return ret;
 }
 
 static int linux_sdio_probe(struct sdio_func *func,
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 325e274..d1b023a 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -138,6 +138,7 @@ _fail_:
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	int ret;
 
 	data = cpu_to_le32(data);
 
@@ -171,8 +172,8 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.count = 4;
 		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
-
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
@@ -191,7 +192,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
-	int nblk, nleft;
+	int nblk, nleft, ret;
 
 	cmd.read_write = 1;
 	if (addr > 0) {
@@ -237,7 +238,8 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
@@ -259,7 +261,8 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
@@ -276,6 +279,7 @@ _fail_:
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	int ret;
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
@@ -305,8 +309,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.buffer = (u8 *)data;
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
-
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
@@ -327,7 +331,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
-	int nblk, nleft;
+	int nblk, nleft, ret;
 
 	cmd.read_write = 0;
 	if (addr > 0) {
@@ -373,7 +377,8 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
@@ -395,7 +400,8 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(wilc, &cmd)) {
+		ret = wilc_sdio_cmd53(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
-- 
1.9.1

