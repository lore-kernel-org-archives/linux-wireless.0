Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20665 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/16] staging: wilc1000: wilc_spi_read: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:30 +0900
Message-ID: <1447827097-9436-10-git-send-email-glen.lee@atmel.com> (sfid-20151118_070918_553745_3B0520DA)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter struct wilc and use it instead of
global variable wilc_dev, and pass wilc to the functions as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c |  4 ++--
 drivers/staging/wilc1000/linux_wlan_spi.h |  2 +-
 drivers/staging/wilc1000/wilc_spi.c       | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 7be750b..5066191 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -112,9 +112,9 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 	return ret;
 }
 
-int wilc_spi_read(u8 *rb, u32 rlen)
+int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 {
-	struct spi_device *spi = to_spi_device(wilc_dev->dev);
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 
 	if (rlen > 0) {
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 41d47dc..16f0b9f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -6,6 +6,6 @@
 
 int wilc_spi_init(void);
 int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len);
-int wilc_spi_read(u8 *rb, u32 rlen);
+int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen);
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 0d89a282..f5db2fc 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -365,7 +365,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (!wilc_spi_read(&b[ix], nbytes)) {
+				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
@@ -375,7 +375,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!wilc_spi_read(crc, 2)) {
+					if (!wilc_spi_read(wilc, crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
@@ -406,7 +406,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 **/
 				retry = 10;
 				do {
-					if (!wilc_spi_read(&rsp, 1)) {
+					if (!wilc_spi_read(wilc, &rsp, 1)) {
 						PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -422,7 +422,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				/**
 				 * Read bytes
 				 **/
-				if (!wilc_spi_read(&b[ix], nbytes)) {
+				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
@@ -432,7 +432,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!wilc_spi_read(crc, 2)) {
+					if (!wilc_spi_read(wilc, crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
-- 
1.9.1

