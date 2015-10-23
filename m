Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51712 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbJWF0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:26:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/28] staging: wilc1000: deinit_irq: use wilc instead of g_linux_wlan
Date: Fri, 23 Oct 2015 14:28:20 +0900
Message-ID: <1445578124-31486-4-git-send-email-glen.lee@atmel.com> (sfid-20151023_072619_872087_B60ADED0)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes function parameter linux_wlan_t nic with net_dev dev and
use wilc instead of nic and g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e31760e..75cbacf 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -309,12 +309,18 @@ static int init_irq(struct net_device *dev)
 }
 #endif
 
-static void deinit_irq(struct wilc *nic)
+static void deinit_irq(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
-	if (&nic->dev_irq_num != 0) {
-		free_irq(nic->dev_irq_num, g_linux_wlan);
+	if (&wl->dev_irq_num != 0) {
+		free_irq(wl->dev_irq_num, wl);
 
 		gpio_free(GPIO_NUM);
 	}
@@ -906,7 +912,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		wlan_deinitialize_threads(wl);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
-		deinit_irq(wl);
+		deinit_irq(dev);
 
 		wilc_wlan_stop();
 
@@ -1143,7 +1149,7 @@ _fail_irq_enable_:
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(wl);
+		deinit_irq(dev);
 
 #endif
 		wlan_deinitialize_threads(wl);
-- 
1.9.1

