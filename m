Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:35303 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbJHSXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:23:32 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: linux_wlan_spi: correct types
Date: Thu,  8 Oct 2015 21:23:13 +0300
Message-Id: <1444328594-10656-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20151008_202404_850171_006B7001)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux_spi_write(), linux_spi_read(), linux_spi_write_read():

    nwi->io_func.u.spi.spi_tx = linux_spi_write;
    nwi->io_func.u.spi.spi_rx = linux_spi_read;
    nwi->io_func.u.spi.spi_trx = linux_spi_write_read;

are expected to accept arguments of 'u8 *', u32 types:

    struct {
        int (*spi_max_speed)(void);
        int (*spi_tx)(u8 *, u32);
        int (*spi_rx)(u8 *, u32);
        int (*spi_trx)(u8 *, u8 *, u32);
    } spi;

However, linux_spi_read() and linux_spi_write_read() do not do this,
they use 'unsigned char *' and 'unsigned long' instead.

Changed the types of their arguments to satisfy the expectations.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 12 ++++++------
 drivers/staging/wilc1000/linux_wlan_spi.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 51bbd96..c6c1f6e 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -243,7 +243,7 @@ int linux_spi_write(u8 *b, u32 len)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_read(unsigned char *rb, unsigned long rlen)
+int linux_spi_read(u8 *rb, u32 rlen)
 {
 	int ret;
 
@@ -307,7 +307,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 
 		kfree(t_buffer);
 	} else {
-		PRINT_ER("can't read data with the following length: %ld\n", rlen);
+		PRINT_ER("can't read data with the following length: %u\n", rlen);
 		ret = -1;
 	}
 	/* change return value to match WILC interface */
@@ -317,7 +317,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 }
 
 #else
-int linux_spi_read(unsigned char *rb, unsigned long rlen)
+int linux_spi_read(u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -351,7 +351,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 		}
 		kfree(t_buffer);
 	} else {
-		PRINT_ER("can't read data with the following length: %ld\n", rlen);
+		PRINT_ER("can't read data with the following length: %u\n", rlen);
 		ret = -1;
 	}
 	/* change return value to match WILC interface */
@@ -362,7 +362,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 
 #endif
 
-int linux_spi_write_read(unsigned char *wb, unsigned char *rb, unsigned int rlen)
+int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen)
 {
 
 	int ret;
@@ -390,7 +390,7 @@ int linux_spi_write_read(unsigned char *wb, unsigned char *rb, unsigned int rlen
 			PRINT_ER("SPI transaction failed\n");
 		}
 	} else {
-		PRINT_ER("can't read data with the following length: %d\n", rlen);
+		PRINT_ER("can't read data with the following length: %u\n", rlen);
 		ret = -1;
 	}
 	/* change return value to match WILC interface */
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index d8eed0f..7356785 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -9,6 +9,6 @@ int linux_spi_init(void *vp);
 void linux_spi_deinit(void *vp);
 int linux_spi_write(u8 *b, u32 len);
 int linux_spi_read(u8 *rb, u32 rlen);
-int linux_spi_write_read(unsigned char *wb, unsigned char *rb, unsigned int rlen);
+int linux_spi_write_read(u8 *wb, u8 *rb, u32 rlen);
 int linux_spi_set_max_speed(void);
 #endif
-- 
1.9.1

