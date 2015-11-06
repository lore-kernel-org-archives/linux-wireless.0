Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37669 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031554AbbKFCRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 56/73] staging: wilc1000: replace numeric type to kernel error type
Date: Fri, 6 Nov 2015 11:19:55 +0900
Message-ID: <1446776412-30670-7-git-send-email-glen.lee@atmel.com> (sfid-20151106_031751_924851_8592E7E3)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replaces numeric type to generic type by kernel style.
 -5 -> -EIO
 -105 -> -ENOBUFS

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ffe7baa..283c506 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1194,7 +1194,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
 	if (!dma_buffer) {
-		ret = -5;
+		ret = -EIO;
 		PRINT_ER("Can't allocate buffer for firmware download IO error\n ");
 		goto _fail_1;
 	}
@@ -1229,7 +1229,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 		release_bus(RELEASE_ONLY);
 
 		if (!ret) {
-			ret = -5;
+			ret = -EIO;
 			PRINT_ER("Can't download firmware IO error\n ");
 			goto _fail_;
 		}
@@ -1263,7 +1263,7 @@ int wilc_wlan_start(void)
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
 		release_bus(RELEASE_ONLY);
-		ret = -5;
+		ret = -EIO;
 		return ret;
 	}
 	reg = 0;
@@ -1298,7 +1298,7 @@ int wilc_wlan_start(void)
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
 		release_bus(RELEASE_ONLY);
-		ret = -5;
+		ret = -EIO;
 		return ret;
 	}
 
@@ -1308,7 +1308,7 @@ int wilc_wlan_start(void)
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
 		release_bus(RELEASE_ONLY);
-		ret = -5;
+		ret = -EIO;
 		return ret;
 	}
 
@@ -1661,7 +1661,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 
 	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
 		if (!hif_sdio.hif_init(inp, wilc_debug)) {
-			ret = -5;
+			ret = -EIO;
 			goto _fail_;
 		}
 		memcpy((void *)&g_wlan.hif_func, &hif_sdio,
@@ -1669,19 +1669,19 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	} else {
 		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
 			if (!hif_spi.hif_init(inp, wilc_debug)) {
-				ret = -5;
+				ret = -EIO;
 				goto _fail_;
 			}
 			memcpy((void *)&g_wlan.hif_func, &hif_spi,
 			       sizeof(wilc_hif_func_t));
 		} else {
-			ret = -5;
+			ret = -EIO;
 			goto _fail_;
 		}
 	}
 
 	if (!wilc_wlan_cfg_init(wilc_debug)) {
-		ret = -105;
+		ret = -ENOBUFS;
 		goto _fail_;
 	}
 
@@ -1690,7 +1690,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	PRINT_D(TX_DBG, "g_wlan.tx_buffer = %p\n", g_wlan.tx_buffer);
 
 	if (!g_wlan.tx_buffer) {
-		ret = -105;
+		ret = -ENOBUFS;
 		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
@@ -1700,14 +1700,14 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
 	if (!g_wlan.rx_buffer) {
-		ret = -105;
+		ret = -ENOBUFS;
 		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
 	}
 #endif
 
 	if (!init_chip(dev)) {
-		ret = -5;
+		ret = -EIO;
 		goto _fail_;
 	}
 #ifdef	TCP_ACK_FILTER
-- 
1.9.1

