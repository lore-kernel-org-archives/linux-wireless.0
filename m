Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32835 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbJBHlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:36 -0400
Received: by pacex6 with SMTP id ex6so100063857pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:35 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 03/12] staging: wilc1000: remove if defined codes of USE_OLD_SPI_SW
Date: Fri,  2 Oct 2015 16:41:12 +0900
Message-Id: <1443771681-15540-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094139_061171_B996148D)
In-Reply-To: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes if defined codes of USE_OLD_SPI_SW.
This macro is deleted because it is commented out.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 08/12 patch is changed.

 drivers/staging/wilc1000/wilc_spi.c | 125 ------------------------------------
 1 file changed, 125 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 0e06fc2..8acf648 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -756,22 +756,6 @@ static int spi_internal_write(u32 adr, u32 dat)
 {
 	int result;
 
-#if defined USE_OLD_SPI_SW
-	/**
-	 *      Command
-	 **/
-	result = spi_cmd(CMD_INTERNAL_WRITE, adr, dat, 4, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal write cmd...\n");
-		return 0;
-	}
-
-	result = spi_cmd_rsp(CMD_INTERNAL_WRITE, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal write cmd response...\n");
-	}
-#else
-
 #ifdef BIG_ENDIAN
 	dat = BYTE_SWAP(dat);
 #endif
@@ -780,7 +764,6 @@ static int spi_internal_write(u32 adr, u32 dat)
 		PRINT_ER("[wilc spi]: Failed internal write cmd...\n");
 	}
 
-#endif
 	return result;
 }
 
@@ -788,35 +771,11 @@ static int spi_internal_read(u32 adr, u32 *data)
 {
 	int result;
 
-#if defined USE_OLD_SPI_SW
-	result = spi_cmd(CMD_INTERNAL_READ, adr, 0, 4, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal read cmd...\n");
-		return 0;
-	}
-
-	result = spi_cmd_rsp(CMD_INTERNAL_READ, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal read cmd response...\n");
-		return 0;
-	}
-
-	/**
-	 *      Data
-	 **/
-	result = spi_data_read((u8 *)data, 4);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal read data...\n");
-		return 0;
-	}
-#else
 	result = spi_cmd_complete(CMD_INTERNAL_READ, adr, (u8 *)data, 4, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal read cmd...\n");
 		return 0;
 	}
-#endif
-
 
 #ifdef BIG_ENDIAN
 	*data = BYTE_SWAP(*data);
@@ -837,24 +796,6 @@ static int spi_write_reg(u32 addr, u32 data)
 	u8 cmd = CMD_SINGLE_WRITE;
 	u8 clockless = 0;
 
-
-#if defined USE_OLD_SPI_SW
-	{
-		result = spi_cmd(cmd, addr, data, 4, 0);
-		if (result != N_OK) {
-			PRINT_ER("[wilc spi]: Failed cmd, write reg (%08x)...\n", addr);
-			return 0;
-		}
-
-		result = spi_cmd_rsp(cmd, 0);
-		if (result != N_OK) {
-			PRINT_ER("[wilc spi]: Failed cmd response, write reg (%08x)...\n", addr);
-			return 0;
-		}
-
-		return 1;
-	}
-#else
 #ifdef BIG_ENDIAN
 	data = BYTE_SWAP(data);
 #endif
@@ -870,8 +811,6 @@ static int spi_write_reg(u32 addr, u32 data)
 	}
 
 	return result;
-#endif
-
 }
 
 static int spi_write(u32 addr, u8 *buf, u32 size)
@@ -885,28 +824,11 @@ static int spi_write(u32 addr, u8 *buf, u32 size)
 	if (size <= 4)
 		return 0;
 
-#if defined USE_OLD_SPI_SW
-	/**
-	 *      Command
-	 **/
-	result = spi_cmd(cmd, addr, 0, size, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, write block (%08x)...\n", addr);
-		return 0;
-	}
-
-	result = spi_cmd_rsp(cmd, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi ]: Failed cmd response, write block (%08x)...\n", addr);
-		return 0;
-	}
-#else
 	result = spi_cmd_complete(cmd, addr, NULL, size, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, write block (%08x)...\n", addr);
 		return 0;
 	}
-#endif
 
 	/**
 	 *      Data
@@ -925,24 +847,6 @@ static int spi_read_reg(u32 addr, u32 *data)
 	u8 cmd = CMD_SINGLE_READ;
 	u8 clockless = 0;
 
-#if defined USE_OLD_SPI_SW
-	result = spi_cmd(cmd, addr, 0, 4, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, read reg (%08x)...\n", addr);
-		return 0;
-	}
-	result = spi_cmd_rsp(cmd, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd response, read reg (%08x)...\n", addr);
-		return 0;
-	}
-
-	result = spi_data_read((u8 *)data, 4);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed data read...\n");
-		return 0;
-	}
-#else
 	if (addr < 0x30) {
 		/* PRINT_ER("***** read addr %d\n\n", addr); */
 		/* Clockless register*/
@@ -955,8 +859,6 @@ static int spi_read_reg(u32 addr, u32 *data)
 		PRINT_ER("[wilc spi]: Failed cmd, read reg (%08x)...\n", addr);
 		return 0;
 	}
-#endif
-
 
 #ifdef BIG_ENDIAN
 	*data = BYTE_SWAP(*data);
@@ -973,38 +875,11 @@ static int spi_read(u32 addr, u8 *buf, u32 size)
 	if (size <= 4)
 		return 0;
 
-#if defined USE_OLD_SPI_SW
-	/**
-	 *      Command
-	 **/
-	result = spi_cmd(cmd, addr, 0, size, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, read block (%08x)...\n", addr);
-		return 0;
-	}
-
-	result = spi_cmd_rsp(cmd, 0);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd response, read block (%08x)...\n", addr);
-		return 0;
-	}
-
-	/**
-	 *      Data
-	 **/
-	result = spi_data_read(buf, size);
-	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed block data read...\n");
-		return 0;
-	}
-#else
 	result = spi_cmd_complete(cmd, addr, buf, size, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, read block (%08x)...\n", addr);
 		return 0;
 	}
-#endif
-
 
 	return 1;
 }
-- 
2.6.0

