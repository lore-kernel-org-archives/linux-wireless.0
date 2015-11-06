Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37793 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031601AbbKFCSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 63/73] staging: wilc1000: remove typedef from wilc_hif_func_t
Date: Fri, 6 Nov 2015 11:20:02 +0900
Message-ID: <1446776412-30670-14-git-send-email-glen.lee@atmel.com> (sfid-20151106_031824_308338_14F7E668)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct wilc_hif_func_t and
renames it to wilc_hif_func.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c |  2 +-
 drivers/staging/wilc1000/wilc_spi.c  |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_wlan.h |  4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 300c571..cfa76b2 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -992,7 +992,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
  *
  ********************************************/
 
-wilc_hif_func_t hif_sdio = {
+struct wilc_hif_func hif_sdio = {
 	sdio_init,
 	sdio_deinit,
 	sdio_read_reg,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 599508b..b09b3bd 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1256,7 +1256,7 @@ static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
  *      Global spi HIF function table
  *
  ********************************************/
-wilc_hif_func_t hif_spi = {
+struct wilc_hif_func hif_spi = {
 	spi_init,
 	spi_deinit,
 	spi_read_reg,
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7b8e70b..b6d784b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2,14 +2,14 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-extern wilc_hif_func_t hif_sdio;
-extern wilc_hif_func_t hif_spi;
+extern struct wilc_hif_func hif_sdio;
+extern struct wilc_hif_func hif_spi;
 u32 wilc_get_chipid(u8 update);
 
 typedef struct {
 	int quit;
 	wilc_wlan_io_func_t io_func;
-	wilc_hif_func_t hif_func;
+	struct wilc_hif_func hif_func;
 	int cfg_frame_in_use;
 	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
@@ -1665,7 +1665,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 			goto _fail_;
 		}
 		memcpy((void *)&g_wlan.hif_func, &hif_sdio,
-		       sizeof(wilc_hif_func_t));
+		       sizeof(struct wilc_hif_func));
 	} else {
 		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
 			if (!hif_spi.hif_init(inp, wilc_debug)) {
@@ -1673,7 +1673,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 				goto _fail_;
 			}
 			memcpy((void *)&g_wlan.hif_func, &hif_spi,
-			       sizeof(wilc_hif_func_t));
+			       sizeof(struct wilc_hif_func));
 		} else {
 			ret = -EIO;
 			goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 368b7ff..ff4872f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -236,7 +236,7 @@ struct rxq_entry_t {
  *
  ********************************************/
 
-typedef struct {
+struct wilc_hif_func {
 	int (*hif_init)(wilc_wlan_inp_t *, wilc_debug_func);
 	int (*hif_deinit)(void *);
 	int (*hif_read_reg)(u32, u32 *);
@@ -253,7 +253,7 @@ typedef struct {
 	int (*hif_sync_ext)(int);
 	void (*hif_set_max_bus_speed)(void);
 	void (*hif_set_default_bus_speed)(void);
-} wilc_hif_func_t;
+};
 
 /********************************************
  *
-- 
1.9.1

