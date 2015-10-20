Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:23016 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbJTF21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 11/12] staging: wilc1000: introduce struct wilc_sdio for sdio data
Date: Tue, 20 Oct 2015 14:26:55 +0900
Message-ID: <1445318816-21686-12-git-send-email-tony.cho@atmel.com> (sfid-20151020_074655_495165_34084923)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces struct wilc_sdio for sdio driver data. The wilc_sdio is
allocated and set as driver data when the sdio is probed and deallocated when
the sdio is removed.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 1bd7f9b..9a45871 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -21,6 +21,10 @@
  #define MAX_SPEED (6 * 1000000) /* Max 50M */
 #endif
 
+struct wilc_sdio {
+	struct sdio_func *func;
+	struct wilc *wilc;
+};
 
 struct sdio_func *local_sdio_func;
 extern int wilc_netdev_init(void);
@@ -112,14 +116,22 @@ int linux_sdio_cmd53(sdio_cmd53_t *cmd)
 
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
+	struct wilc_sdio *wl_sdio;
+
 	PRINT_D(INIT_DBG, "probe function\n");
+	wl_sdio = kzalloc(sizeof(struct wilc_sdio), GFP_KERNEL);
+	if (!wl_sdio)
+		return -ENOMEM;
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
 	local_sdio_func = func;
 	if (wilc_netdev_init()) {
 		PRINT_ER("Couldn't initialize netdev\n");
+		kfree(wl_sdio);
 		return -1;
 	}
+	wl_sdio->func = func;
+	sdio_set_drvdata(func, wl_sdio);
 
 	printk("Driver Initializing success\n");
 	return 0;
@@ -127,7 +139,11 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
+	struct wilc_sdio *wl_sdio;
+
+	wl_sdio = sdio_get_drvdata(func);
 	wl_wlan_cleanup();
+	kfree(wl_sdio);
 }
 
 struct sdio_driver wilc_bus = {
-- 
1.9.1

