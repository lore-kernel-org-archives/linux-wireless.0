Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:51482 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbIIHIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 03:08:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: remove unused PLAT_RK3026_TCHIP
Date: Wed, 9 Sep 2015 16:08:13 +0900
Message-ID: <1441782493-11338-4-git-send-email-tony.cho@atmel.com> (sfid-20150909_090816_793086_FBFAEAD6)
In-Reply-To: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the preprocessor definition, PLAT_RK3026_TCHIP which
is not used anymore.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4c54ea7..39716ba 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -19,9 +19,6 @@
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 extern wilc_cfg_func_t mac_cfg;
-#if defined(PLAT_RK3026_TCHIP)
-extern u8 g_wilc_initialized; /* AMR : 0422 RK3026 Crash issue */
-#endif
 extern void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size);
 uint32_t wilc_get_chipid(uint8_t update);
 u16 Set_machw_change_vir_if(bool bValue);
@@ -1943,11 +1940,7 @@ uint32_t init_chip(void)
 	uint32_t chipid;
 	uint32_t reg, ret = 0;
 
-#if defined(PLAT_RK3026_TCHIP)
-	acquire_bus(ACQUIRE_AND_WAKEUP); /* AMR : 0422 RK3026 Crash issue */
-#else
 	acquire_bus(ACQUIRE_ONLY);
-#endif
 
 	chipid = wilc_get_chipid(true);
 
@@ -2077,13 +2070,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/***
 	 *      host interface init
 	 **/
-#if defined(PLAT_RK3026_TCHIP) /* AMR : 0422 RK3026 Crash issue */
-	if (!g_wilc_initialized) {
-		custom_lock_bus(g_mac_open);
-		custom_wakeup(g_mac_open);
-	}
-#endif
-
 	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
 		if (!hif_sdio.hif_init(inp, wilc_debug)) {
 			/* EIO	5 */
@@ -2176,11 +2162,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	Init_TCP_tracking();
 #endif
 
-#if defined(PLAT_RK3026_TCHIP) /* AMR : 0422 RK3026 Crash issue */
-	if (!g_wilc_initialized)
-		custom_unlock_bus(g_mac_open);
-#endif
-
 	return 1;
 
 _fail_:
@@ -2192,11 +2173,6 @@ _fail_:
 	kfree(g_wlan.tx_buffer);
 	g_wlan.tx_buffer = NULL;
 
-#if defined(PLAT_RK3026_TCHIP) /* AMR : 0422 RK3026 Crash issue */
-	if (!g_wilc_initialized)
-		custom_unlock_bus(g_mac_open);
-#endif
-
 	return ret;
 
 }
-- 
1.9.1

