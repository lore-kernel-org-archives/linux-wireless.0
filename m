Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9843 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbJBFX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:23:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/10] staging: wilc1000: remove function pointer cfg_init
Date: Fri, 2 Oct 2015 14:22:11 +0900
Message-ID: <1443763332-7330-9-git-send-email-tony.cho@atmel.com> (sfid-20151002_073148_970404_DD35C14A)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer cfg_init and call the function
wilc_wlan_cfg_init instead. Remove static from function declaration.
After removing cfg_init, the struct wilc_cfg_func_t is useless so just delete
it and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 3 +--
 drivers/staging/wilc1000/wilc_wlan.h     | 4 ----
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 6 +-----
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 1 +
 4 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index cd4598a..4ca8721 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -18,7 +18,6 @@
  ********************************************/
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
-extern wilc_cfg_func_t mac_cfg;
 extern void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
 u32 wilc_get_chipid(u8 update);
 u16 Set_machw_change_vir_if(bool bValue);
@@ -1994,7 +1993,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp)
 	/***
 	 *      mac interface init
 	 **/
-	if (!mac_cfg.cfg_init(wilc_debug)) {
+	if (!wilc_wlan_cfg_init(wilc_debug)) {
 		/* ENOBUFS	105 */
 		ret = -105;
 		goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 5099cf0..bd89689 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -295,10 +295,6 @@ typedef struct {
 	u32 seq_no;
 } wilc_cfg_rsp_t;
 
-typedef struct {
-	int (*cfg_init)(wilc_debug_func);
-} wilc_cfg_func_t;
-
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 2916d45..d148d6e 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -558,13 +558,9 @@ int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 	return ret;
 }
 
-static int wilc_wlan_cfg_init(wilc_debug_func func)
+int wilc_wlan_cfg_init(wilc_debug_func func)
 {
 	memset((void *)&g_mac, 0, sizeof(wilc_mac_cfg_t));
 	g_mac.dPrint = func;
 	return 1;
 }
-
-wilc_cfg_func_t mac_cfg = {
-	wilc_wlan_cfg_init,
-};
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index fe2c0382..30e60ec 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -34,5 +34,6 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp);
+int wilc_wlan_cfg_init(wilc_debug_func func);
 
 #endif
-- 
1.9.1

