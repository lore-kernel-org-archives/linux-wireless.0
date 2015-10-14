Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43784 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbbJNLsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:48:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/16] staging: wilc1000: assign pointer of wl to sdio device data
Date: Wed, 14 Oct 2015 20:46:44 +0900
Message-ID: <1444823204-16736-16-git-send-email-tony.cho@atmel.com> (sfid-20151014_134901_267702_D20DF1FF)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch assigns wl pointer to sdio device data. The global variable wl will
be removed finally.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 3 ++-
 drivers/staging/wilc1000/linux_wlan_sdio.c    | 5 +++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4708d44..3cc4861 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1616,7 +1616,7 @@ void wl_wlan_cleanup(void)
 	linux_wlan_device_power(0);
 }
 
-int wilc_netdev_init(void)
+int wilc_netdev_init(struct wilc **wilc)
 {
 
 	int i;
@@ -1629,6 +1629,7 @@ int wilc_netdev_init(void)
 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
 		return -ENOMEM;
+	*wilc = wl;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 7fd53be..45342e8 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -27,7 +27,6 @@ struct wilc_sdio {
 };
 
 struct sdio_func *local_sdio_func;
-extern int wilc_netdev_init(void);
 extern void wilc_handle_isr(void);
 
 static unsigned int sdio_default_speed;
@@ -117,6 +116,7 @@ int linux_sdio_cmd53(sdio_cmd53_t *cmd)
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	struct wilc_sdio *wl_sdio;
+	struct wilc *wilc;
 
 	PRINT_D(INIT_DBG, "probe function\n");
 	wl_sdio = kzalloc(sizeof(struct wilc_sdio), GFP_KERNEL);
@@ -125,12 +125,13 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	local_sdio_func = func;
-	if (wilc_netdev_init()) {
+	if (wilc_netdev_init(&wilc)) {
 		PRINT_ER("Couldn't initialize netdev\n");
 		kfree(wl_sdio);
 		return -1;
 	}
 	wl_sdio->func = func;
+	wl_sdio->wilc = wilc;
 	sdio_set_drvdata(func, wl_sdio);
 
 	printk("Driver Initializing success\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a6b948a..9a9e082 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -214,4 +214,5 @@ void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wl_wlan_cleanup(void);
+int wilc_netdev_init(struct wilc **wilc);
 #endif
-- 
1.9.1

