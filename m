Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11533 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbLUFRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:17:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 23/46] staging: wilc1000: linux_wlan_spi.c: return linux error value
Date: Mon, 21 Dec 2015 14:18:27 +0900
Message-ID: <1450675130-17866-24-git-send-email-glen.lee@atmel.com> (sfid-20151221_063102_148921_73687F96)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

return linux error value instead of 0 or 1 and use -EINVAL. Related codes
also changed together.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 14 +++-----------
 drivers/staging/wilc1000/wilc_spi.c       | 18 +++++++++---------
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 6111405..c7d2542 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -104,13 +104,9 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 		dev_err(&spi->dev,
 			"FAILED due to NULL buffer or ZERO length check the following length: %d\n",
 			len);
-		ret = -1;
+		ret = -EINVAL;
 	}
 
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
-
-
 	return ret;
 }
 
@@ -148,10 +144,8 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 		dev_err(&spi->dev,
 			"can't read data with the following length: %u\n",
 			rlen);
-		ret = -1;
+		ret = -EINVAL;
 	}
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
 
 	return ret;
 }
@@ -185,10 +179,8 @@ int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 		dev_err(&spi->dev,
 			"can't read data with the following length: %u\n",
 			rlen);
-		ret = -1;
+		ret = -EINVAL;
 	}
-	/* change return value to match WILC interface */
-	(ret < 0) ? (ret = 0) : (ret = 1);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index faaeaf7..bd61aac 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -250,7 +250,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	}
 	rix = len;
 
-	if (!wilc_spi_write_read(wilc, wb, rb, len2)) {
+	if (wilc_spi_write_read(wilc, wb, rb, len2)) {
 		dev_err(&spi->dev, "Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
@@ -366,7 +366,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
+				if (wilc_spi_read(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
@@ -376,7 +376,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!wilc_spi_read(wilc, crc, 2)) {
+					if (wilc_spi_read(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
@@ -407,7 +407,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 **/
 				retry = 10;
 				do {
-					if (!wilc_spi_read(wilc, &rsp, 1)) {
+					if (wilc_spi_read(wilc, &rsp, 1)) {
 						dev_err(&spi->dev, "Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -423,7 +423,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
+				if (wilc_spi_read(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
@@ -433,7 +433,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!wilc_spi_read(wilc, crc, 2)) {
+					if (wilc_spi_read(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -484,7 +484,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 				order = 0x2;
 		}
 		cmd |= order;
-		if (!wilc_spi_write(wilc, &cmd, 1)) {
+		if (wilc_spi_write(wilc, &cmd, 1)) {
 			dev_err(&spi->dev,
 				"Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
@@ -494,7 +494,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		/**
 		 *      Write data
 		 **/
-		if (!wilc_spi_write(wilc, &b[ix], nbytes)) {
+		if (wilc_spi_write(wilc, &b[ix], nbytes)) {
 			dev_err(&spi->dev,
 				"Failed data block write, bus error...\n");
 			result = N_FAIL;
@@ -505,7 +505,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		 *      Write Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (!wilc_spi_write(wilc, crc, 2)) {
+			if (wilc_spi_write(wilc, crc, 2)) {
 				dev_err(&spi->dev,"Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
-- 
1.9.1

