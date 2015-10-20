Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:17316 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbJTIPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/13] staging: wilc1000: init_irq: change argument and use netdev private wilc
Date: Tue, 20 Oct 2015 17:14:03 +0900
Message-ID: <1445328843-32247-13-git-send-email-tony.cho@atmel.com> (sfid-20151020_101551_519658_915657AE)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch changes function argument type wilc with net_device and use
netdev private data member wilc instead of p_nic.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2c4673c..bb5bd81 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -259,10 +259,14 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 }
 
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
-static int init_irq(struct wilc *p_nic)
+static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
-	struct wilc *nic = p_nic;
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
 	/*initialize GPIO and register IRQ num*/
 	/*GPIO request*/
@@ -275,23 +279,23 @@ static int init_irq(struct wilc *p_nic)
  * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
  */
 #else
-		nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
+		wl->dev_irq_num = gpio_to_irq(GPIO_NUM);
 #endif
 	} else {
 		ret = -1;
 		PRINT_ER("could not obtain gpio for WILC_INTR\n");
 	}
 
-	if ((ret != -1) && (request_threaded_irq(nic->dev_irq_num, isr_uh_routine, isr_bh_routine,
+	if ((ret != -1) && (request_threaded_irq(wl->dev_irq_num, isr_uh_routine, isr_bh_routine,
 						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
-						  "WILC_IRQ", nic)) < 0) {
+						  "WILC_IRQ", wl)) < 0) {
 
 		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
 		ret = -1;
 	} else {
 
 		PRINT_D(INIT_DBG, "IRQ request succeeded IRQ-NUM= %d on GPIO: %d\n",
-			nic->dev_irq_num, GPIO_NUM);
+			wl->dev_irq_num, GPIO_NUM);
 	}
 
 	return ret;
@@ -1055,7 +1059,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(wl)) {
+		if (init_irq(dev)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_locks_;
-- 
1.9.1

