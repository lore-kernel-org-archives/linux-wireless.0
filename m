Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20506 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:31 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/16] staging: wilc1000: remove spi speed control codes
Date: Wed, 18 Nov 2015 15:11:23 +0900
Message-ID: <1447827097-9436-3-git-send-email-glen.lee@atmel.com> (sfid-20151118_070835_482018_C31DCD63)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes spi speed control codes. We are not using define SPEED to
specify speed of spi, it is not proper way of doing this. It will be
provided by the device tree.

The following functions and variable are removed.
MIN_SPEED, MAX_SPEED, SPEED
wilc_spi_set_max_speed
wilc_spi_max_bus_speed
wilc_spi_default_bus_speed
hif_set_max_bus_speed
hif_set_default_bus_speed

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 42 -------------------------------
 drivers/staging/wilc1000/linux_wlan_spi.h |  2 --
 drivers/staging/wilc1000/wilc_spi.c       | 11 --------
 drivers/staging/wilc1000/wilc_wlan.h      |  2 --
 4 files changed, 57 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 1d8922d..5e3bff0 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -17,33 +17,6 @@
 
 #define USE_SPI_DMA     0       /* johnny add */
 
-#ifdef WILC_ASIC_A0
- #if defined(PLAT_PANDA_ES_OMAP4460)
-  #define MIN_SPEED 12000000
-  #define MAX_SPEED 24000000
- #elif defined(PLAT_WMS8304)
-  #define MIN_SPEED 12000000
-  #define MAX_SPEED 24000000 /* 4000000 */
- #elif defined(CUSTOMER_PLATFORM)
-/*
-  TODO : define Clock speed under 48M.
- *
- * ex)
- * #define MIN_SPEED 24000000
- * #define MAX_SPEED 48000000
- */
- #else
-  #define MIN_SPEED 24000000
-  #define MAX_SPEED 48000000
- #endif
-#else /* WILC_ASIC_A0 */
-/* Limit clk to 6MHz on FPGA. */
- #define MIN_SPEED 6000000
- #define MAX_SPEED 6000000
-#endif /* WILC_ASIC_A0 */
-
-static u32 SPEED = MIN_SPEED;
-
 static const struct wilc1000_ops wilc1000_spi_ops;
 
 static int wilc_bus_probe(struct spi_device *spi)
@@ -119,7 +92,6 @@ int wilc_spi_write(u8 *b, u32 len)
 				struct spi_transfer tr = {
 					.tx_buf = b + (i * TXRX_PHASE_SIZE),
 					.len = TXRX_PHASE_SIZE,
-					.speed_hz = SPEED,
 					.bits_per_word = 8,
 					.delay_usecs = 0,
 				};
@@ -145,7 +117,6 @@ int wilc_spi_write(u8 *b, u32 len)
 			struct spi_transfer tr = {
 				.tx_buf = b + (blk * TXRX_PHASE_SIZE),
 				.len = remainder,
-				.speed_hz = SPEED,
 				.bits_per_word = 8,
 				.delay_usecs = 0,
 			};
@@ -187,7 +158,6 @@ int wilc_spi_write(u8 *b, u32 len)
 		struct spi_transfer tr = {
 			.tx_buf = b,
 			.len = len,
-			.speed_hz = SPEED,
 			.delay_usecs = 0,
 		};
 		char *r_buffer = kzalloc(len, GFP_KERNEL);
@@ -249,7 +219,6 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 				struct spi_transfer tr = {
 					.rx_buf = rb + (i * TXRX_PHASE_SIZE),
 					.len = TXRX_PHASE_SIZE,
-					.speed_hz = SPEED,
 					.bits_per_word = 8,
 					.delay_usecs = 0,
 				};
@@ -273,7 +242,6 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 			struct spi_transfer tr = {
 				.rx_buf = rb + (blk * TXRX_PHASE_SIZE),
 				.len = remainder,
-				.speed_hz = SPEED,
 				.bits_per_word = 8,
 				.delay_usecs = 0,
 			};
@@ -313,7 +281,6 @@ int wilc_spi_read(u8 *rb, u32 rlen)
 		struct spi_transfer tr = {
 			.rx_buf = rb,
 			.len = rlen,
-			.speed_hz = SPEED,
 			.delay_usecs = 0,
 
 		};
@@ -359,7 +326,6 @@ int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 			.rx_buf = rb,
 			.tx_buf = wb,
 			.len = rlen,
-			.speed_hz = SPEED,
 			.bits_per_word = 8,
 			.delay_usecs = 0,
 
@@ -384,11 +350,3 @@ int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 
 	return ret;
 }
-
-int wilc_spi_set_max_speed(void)
-{
-	SPEED = MAX_SPEED;
-
-	PRINT_INFO(BUS_DBG, "@@@@@@@@@@@@ change SPI speed to %d @@@@@@@@@\n", SPEED);
-	return 1;
-}
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index f434f79..baa98cc 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -7,6 +7,4 @@ int wilc_spi_init(void);
 int wilc_spi_write(u8 *b, u32 len);
 int wilc_spi_read(u8 *rb, u32 rlen);
 int wilc_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
-int wilc_spi_set_max_speed(void);
-
 #endif
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 803d0f4..bd150a5 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -791,15 +791,6 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	return 1;
 }
 
-static void wilc_spi_max_bus_speed(void)
-{
-	wilc_spi_set_max_speed();
-}
-
-static void wilc_spi_default_bus_speed(void)
-{
-}
-
 static int wilc_spi_read_size(u32 *size)
 {
 	int ret;
@@ -1034,6 +1025,4 @@ const struct wilc_hif_func wilc_hif_spi = {
 	.hif_block_tx_ext = _wilc_spi_write,
 	.hif_block_rx_ext = _wilc_spi_read,
 	.hif_sync_ext = wilc_spi_sync_ext,
-	.hif_set_max_bus_speed = wilc_spi_max_bus_speed,
-	.hif_set_default_bus_speed = wilc_spi_default_bus_speed,
 };
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 20bca44..ee13771e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -251,8 +251,6 @@ struct wilc_hif_func {
 	int (*hif_block_tx_ext)(u32, u8 *, u32);
 	int (*hif_block_rx_ext)(u32, u8 *, u32);
 	int (*hif_sync_ext)(int);
-	void (*hif_set_max_bus_speed)(void);
-	void (*hif_set_default_bus_speed)(void);
 	int (*enable_interrupt)(struct wilc *nic);
 	void (*disable_interrupt)(struct wilc *nic);
 };
-- 
1.9.1

