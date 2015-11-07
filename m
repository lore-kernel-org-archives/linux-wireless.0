Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38676 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbKGLcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 06:32:13 -0500
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH] Staging: wilc1000: Fix build break due to undeclared *wilc and implicit declaration of init_irq
Date: Sat,  7 Nov 2015 17:01:49 +0530
Message-Id: <1446895909-30052-1-git-send-email-punitvara@gmail.com> (sfid-20151107_123259_023126_7D54E4A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the linux_wlan.c file that fixes up break found during
make drivers/staging/wilc1000/linux_wlan.o

Patch add following things to file :
-struct wilc *wilc declaration
-init_irq declaration
-At preprocessor (!defined WILC_SDIO) to defination of init_irq
-At preprocessor (!defined WILC_SDIO) to defination isr_uh_routine

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 09ddba2..0a21e62 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -224,7 +224,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WILC_SDIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	perInterface_wlan_t *nic;
@@ -264,7 +264,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	return IRQ_HANDLED;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WILC_SDIO)
 static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
@@ -1082,6 +1082,9 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 		wl->txq_thread = NULL;
 	}
 }
+
+#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
+static int init_irq(struct net_device *dev);
+#endif
 
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
@@ -1791,6 +1794,7 @@ int wilc_netdev_init(struct wilc **wilc)
 /*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
+	struct wilc *wilc;
 #ifdef WILC_SPI
 	struct wilc *wilc;
 #endif
-- 
2.6.2

