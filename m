Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57855 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbJ0JZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:18 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 03/27] staging: wilc1000: deinit_irq: use wilc instead of g_linux_wlan
Date: Tue, 27 Oct 2015 18:27:39 +0900
Message-ID: <1445938083-20445-3-git-send-email-glen.lee@atmel.com> (sfid-20151027_102522_523129_E97BD5C0)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes function parameter linux_wlan_t nic with net_dev dev and
use netdev private data member wilc instead of nic and g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7d0d722..ac2bc06 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -310,12 +310,18 @@ static int init_irq(struct net_device *dev)
 }
 #endif
 
-static void deinit_irq(struct wilc *nic)
+static void deinit_irq(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
-	if (&nic->dev_irq_num != 0) {
-		free_irq(nic->dev_irq_num, g_linux_wlan);
+	if (&wilc->dev_irq_num != 0) {
+		free_irq(wilc->dev_irq_num, wilc);
 
 		gpio_free(GPIO_NUM);
 	}
@@ -907,7 +913,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		wlan_deinitialize_threads(wl);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
-		deinit_irq(wl);
+		deinit_irq(dev);
 
 		wilc_wlan_stop();
 
@@ -1144,7 +1150,7 @@ _fail_irq_enable_:
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(wl);
+		deinit_irq(dev);
 
 #endif
 		wlan_deinitialize_threads(wl);
-- 
1.9.1

