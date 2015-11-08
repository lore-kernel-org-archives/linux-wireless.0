Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37264 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbKHVcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 16:32:11 -0500
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared *wilc and implicit declaration of init_irq
Date: Mon,  9 Nov 2015 03:01:50 +0530
Message-Id: <1447018310-4524-1-git-send-email-punitvara@gmail.com> (sfid-20151108_223228_759819_B9F43ADF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the linux_wlan.c file that fixes up break found during
make drivers/staging/wilc1000/linux_wlan.o

Patch add following things to file :
-init_irq declaration
-At preprocessor (!defined WILC_SDIO) to defination of init_irq
-At preprocessor (!defined WILC_SDIO) to defination isr_uh_routine
-removes unnecessary lines to declare *wilc

Patch fixes 702c0e50f and 2c1d05d10 tags.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
-Fixes tag added suggested by Dan carpenter.
-Remove declaration of autovariable with same type and same name suggested by Joe Perches

 drivers/staging/wilc1000/linux_wlan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 086f1db..5bd14ed 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -208,7 +208,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	return NOTIFY_DONE;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WILC_SDIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	perInterface_wlan_t *nic;
@@ -246,7 +246,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	return IRQ_HANDLED;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WILC_SDIO)
 static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
@@ -937,6 +937,10 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 	}
 }
 
+#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
+static int init_irq(struct net_device *dev);
+#endif
+
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
 	wilc_wlan_inp_t nwi;
@@ -1578,9 +1582,7 @@ int wilc_netdev_init(struct wilc **wilc)
 
 static int __init init_wilc_driver(void)
 {
-#ifdef WILC_SPI
 	struct wilc *wilc;
-#endif
 
 #if defined(WILC_DEBUGFS)
 	if (wilc_debugfs_init() < 0) {
-- 
2.6.2

