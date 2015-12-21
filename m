Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11595 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:17:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 27/46] staging: wilc1000: rename spi function names
Date: Mon, 21 Dec 2015 14:18:31 +0900
Message-ID: <1450675130-17866-28-git-send-email-glen.lee@atmel.com> (sfid-20151221_063103_178141_D07199F4)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several similar function names, such as wilc_spi_write and
_wilc_spi_write. It is likely to be confused after merging linux_wlan_spi.c and
wilc_spi.c, so rename following functions properly.
Rename wilc_spi_write to wilc_spi_tx, wilc_spi_read to wilc_spi_rx,
wilc_spi_write_read to wilc_spi_tx_rx, _wilc_spi_write to wilc_spi_write,
_wilc_spi_read to wilc_spi_read.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c |  6 +++---
 drivers/staging/wilc1000/linux_wlan_spi.h |  6 +++---
 drivers/staging/wilc1000/wilc_spi.c       | 34 +++++++++++++++----------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c7d2542..e9ad33f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -66,7 +66,7 @@ int wilc_spi_init(void)
 	return 1;
 }
 
-int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
+int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
@@ -110,7 +110,7 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 	return ret;
 }
 
-int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
+int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
@@ -150,7 +150,7 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 	return ret;
 }
 
-int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
+int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 00733ab..5ff070b 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -5,7 +5,7 @@
 #include "wilc_wfi_netdevice.h"
 
 int wilc_spi_init(void);
-int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len);
-int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen);
-int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen);
+int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len);
+int wilc_spi_rx(struct wilc *wilc, u8 *rb, u32 rlen);
+int wilc_spi_tx_rx(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index bd61aac..ce12d29 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -21,8 +21,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int _wilc_spi_read(struct wilc *wilc, u32, u8 *, u32);
-static int _wilc_spi_write(struct wilc *wilc, u32, u8 *, u32);
+static int wilc_spi_read(struct wilc *wilc, u32, u8 *, u32);
+static int wilc_spi_write(struct wilc *wilc, u32, u8 *, u32);
 
 /********************************************
  *
@@ -250,7 +250,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	}
 	rix = len;
 
-	if (wilc_spi_write_read(wilc, wb, rb, len2)) {
+	if (wilc_spi_tx_rx(wilc, wb, rb, len2)) {
 		dev_err(&spi->dev, "Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
@@ -366,7 +366,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (wilc_spi_read(wilc, &b[ix], nbytes)) {
+				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
@@ -376,7 +376,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (wilc_spi_read(wilc, crc, 2)) {
+					if (wilc_spi_rx(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
@@ -407,7 +407,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 **/
 				retry = 10;
 				do {
-					if (wilc_spi_read(wilc, &rsp, 1)) {
+					if (wilc_spi_rx(wilc, &rsp, 1)) {
 						dev_err(&spi->dev, "Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -423,7 +423,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (wilc_spi_read(wilc, &b[ix], nbytes)) {
+				if (wilc_spi_rx(wilc, &b[ix], nbytes)) {
 					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
@@ -433,7 +433,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (wilc_spi_read(wilc, crc, 2)) {
+					if (wilc_spi_rx(wilc, crc, 2)) {
 						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -484,7 +484,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 				order = 0x2;
 		}
 		cmd |= order;
-		if (wilc_spi_write(wilc, &cmd, 1)) {
+		if (wilc_spi_tx(wilc, &cmd, 1)) {
 			dev_err(&spi->dev,
 				"Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
@@ -494,7 +494,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		/**
 		 *      Write data
 		 **/
-		if (wilc_spi_write(wilc, &b[ix], nbytes)) {
+		if (wilc_spi_tx(wilc, &b[ix], nbytes)) {
 			dev_err(&spi->dev,
 				"Failed data block write, bus error...\n");
 			result = N_FAIL;
@@ -505,7 +505,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		 *      Write Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (wilc_spi_write(wilc, crc, 2)) {
+			if (wilc_spi_tx(wilc, crc, 2)) {
 				dev_err(&spi->dev,"Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
@@ -589,7 +589,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	return result;
 }
 
-static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
@@ -644,7 +644,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 	return 1;
 }
 
-static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
+static int wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	u8 cmd = CMD_DMA_EXT_READ;
@@ -998,12 +998,12 @@ const struct wilc_hif_func wilc_hif_spi = {
 	.hif_deinit = _wilc_spi_deinit,
 	.hif_read_reg = wilc_spi_read_reg,
 	.hif_write_reg = wilc_spi_write_reg,
-	.hif_block_rx = _wilc_spi_read,
-	.hif_block_tx = _wilc_spi_write,
+	.hif_block_rx = wilc_spi_read,
+	.hif_block_tx = wilc_spi_write,
 	.hif_read_int = wilc_spi_read_int,
 	.hif_clear_int_ext = wilc_spi_clear_int_ext,
 	.hif_read_size = wilc_spi_read_size,
-	.hif_block_tx_ext = _wilc_spi_write,
-	.hif_block_rx_ext = _wilc_spi_read,
+	.hif_block_tx_ext = wilc_spi_write,
+	.hif_block_rx_ext = wilc_spi_read,
 	.hif_sync_ext = wilc_spi_sync_ext,
 };
-- 
1.9.1

