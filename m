Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23028 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbJTF2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 12/12] staging: wilc1000: assign pointer of g_linux_wlan to sdio device data
Date: Tue, 20 Oct 2015 14:26:56 +0900
Message-ID: <1445318816-21686-13-git-send-email-tony.cho@atmel.com> (sfid-20151020_074655_229168_52FB267D)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch assigns wl pointer to sdio device data. The global variable
g_linux_wlan will be removed finally.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 5 +++--
 drivers/staging/wilc1000/linux_wlan_sdio.c    | 5 +++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3cad5b6..5701e58 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1620,9 +1620,8 @@ void wl_wlan_cleanup(void)
 	linux_wlan_device_power(0);
 }
 
-int wilc_netdev_init(void)
+int wilc_netdev_init(struct wilc **wilc)
 {
-
 	int i;
 	perInterface_wlan_t *nic;
 	struct net_device *ndev;
@@ -1634,6 +1633,8 @@ int wilc_netdev_init(void)
 	if (!g_linux_wlan)
 		return -ENOMEM;
 
+	*wilc = g_linux_wlan;
+
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 9a45871..1f8d874 100644
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
index 74eb7b6..e0c66bc 100644
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

