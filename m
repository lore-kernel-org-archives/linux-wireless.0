Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48849 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbbKWJpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 04:45:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/10] staging: wilc1000: wilc_sdio_cmd52: return linux error value
Date: Mon, 23 Nov 2015 18:48:05 +0900
Message-ID: <1448272088-13973-7-git-send-email-glen.lee@atmel.com> (sfid-20151123_104527_113460_A1717221)
In-Reply-To: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
References: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return value with linux error value, not 1 or 0.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  6 ++--
 drivers/staging/wilc1000/wilc_sdio.c       | 51 +++++++++++++++++++-----------
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index a918de9..e25811d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -51,11 +51,9 @@ int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
 
 	sdio_release_host(func);
 
-	if (ret < 0) {
+	if (ret)
 		dev_err(&func->dev, "wilc_sdio_cmd52..failed, err(%d)\n", ret);
-		return 0;
-	}
-	return 1;
+	return ret;
 }
 
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 24bc6f7..fd640f1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -38,6 +38,7 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
+	int ret;
 
 	/**
 	 *      Review: BIG ENDIAN
@@ -47,21 +48,24 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	cmd.raw = 0;
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
@@ -75,20 +79,23 @@ static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
+	int ret;
 
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
@@ -108,19 +115,22 @@ static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
+	int ret;
 
 	cmd.read_write = 1;
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
@@ -150,7 +160,8 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		cmd.data = data;
-		if (!wilc_sdio_cmd52(wilc, &cmd)) {
+		ret = wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
@@ -288,7 +299,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.function = 0;
 		cmd.raw = 0;
 		cmd.address = addr;
-		if (!wilc_sdio_cmd52(wilc, &cmd)) {
+		ret = wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
@@ -430,7 +442,7 @@ static int sdio_init(struct wilc *wilc)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
-	int loop;
+	int loop, ret;
 	u32 chipid;
 
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
@@ -450,7 +462,8 @@ static int sdio_init(struct wilc *wilc)
 	cmd.raw = 1;
 	cmd.address = 0x100;
 	cmd.data = 0x80;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
@@ -472,7 +485,8 @@ static int sdio_init(struct wilc *wilc)
 	cmd.raw = 1;
 	cmd.address = 0x2;
 	cmd.data = 0x2;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev,
 			"Fail cmd 52, set IOE register...\n");
 		goto _fail_;
@@ -488,7 +502,8 @@ static int sdio_init(struct wilc *wilc)
 	loop = 3;
 	do {
 		cmd.data = 0;
-		if (!wilc_sdio_cmd52(wilc, &cmd)) {
+		ret = wilc_sdio_cmd52(wilc, &cmd);
+		if (ret) {
 			dev_err(&func->dev,
 				"Fail cmd 52, get IOR register...\n");
 			goto _fail_;
@@ -518,7 +533,8 @@ static int sdio_init(struct wilc *wilc)
 	cmd.raw = 1;
 	cmd.address = 0x4;
 	cmd.data = 0x3;
-	if (!wilc_sdio_cmd52(wilc, &cmd)) {
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
 		dev_err(&func->dev, "Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
@@ -546,7 +562,6 @@ _fail_:
 
 static int sdio_read_size(struct wilc *wilc, u32 *size)
 {
-
 	u32 tmp;
 	sdio_cmd52_t cmd;
 
@@ -665,7 +680,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			cmd.data = reg;
 
 			ret = wilc_sdio_cmd52(wilc, &cmd);
-			if (!ret) {
+			if (ret) {
 				dev_err(&func->dev,
 					"Failed cmd52, set 0xf8 data (%d) ...\n",
 					__LINE__);
@@ -695,7 +710,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 						cmd.data = BIT(i);
 
 						ret = wilc_sdio_cmd52(wilc, &cmd);
-						if (!ret) {
+						if (ret) {
 							dev_err(&func->dev,
 								"Failed cmd52, set 0xf8 data (%d) ...\n",
 								__LINE__);
@@ -742,7 +757,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				cmd.address = 0xf6;
 				cmd.data = vmm_ctl;
 				ret = wilc_sdio_cmd52(wilc, &cmd);
-				if (!ret) {
+				if (ret) {
 					dev_err(&func->dev,
 						"Failed cmd52, set 0xf6 data (%d) ...\n",
 						__LINE__);
-- 
1.9.1

