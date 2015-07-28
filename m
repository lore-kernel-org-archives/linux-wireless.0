Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48287 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbbG1IuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:50:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/21] staging: wilc1000: remove unnecessary spcae
Date: Tue, 28 Jul 2015 17:47:39 +0900
Message-ID: <1438073261-28315-21-git-send-email-tony.cho@atmel.com> (sfid-20150728_105027_080192_50C3892D)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kim, Leo" <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl on
space prohibited between function name and open parenthesis '('

Signed-off-by: Kim, Leo <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d012af5..3e55a8a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -194,9 +194,9 @@ static char *ps8current = DebugBuffer;
 void printk_later(const char *format, ...)
 {
 	va_list args;
-	va_start (args, format);
-	ps8current += vsprintf (ps8current, format, args);
-	va_end (args);
+	va_start(args, format);
+	ps8current += vsprintf(ps8current, format, args);
+	va_end(args);
 	if ((ps8current - DebugBuffer) > DEGUG_BUFFER_LENGTH)
 		ps8current = DebugBuffer;
 
@@ -477,9 +477,9 @@ static int init_irq(linux_wlan_t *p_nic)
  *
  * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
  */
-#elif defined (NM73131_0_BOARD)
+#elif defined(NM73131_0_BOARD)
 		nic->dev_irq_num = IRQ_WILC1000;
-#elif defined (PANDA_BOARD)
+#elif defined(PANDA_BOARD)
 		gpio_export(GPIO_NUM, 1);
 		nic->dev_irq_num = OMAP_GPIO_IRQ(GPIO_NUM);
 		irq_set_irq_type(nic->dev_irq_num, IRQ_TYPE_LEVEL_LOW);
@@ -1483,7 +1483,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	nwi->os_context.txq_wait_event = (void *)&g_linux_wlan->txq_event;
 
-#if defined (MEMORY_STATIC)
+#if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
 	nwi->os_context.rxq_critical_section = (void *)&g_linux_wlan->rxq_cs;
@@ -1935,7 +1935,7 @@ _fail_locks_:
  *      - this function will be called automatically by OS when module inserted.
  */
 
-#if !defined (NM73131_0_BOARD)
+#if !defined(NM73131_0_BOARD)
 int mac_init_fn(struct net_device *ndev)
 {
 
@@ -1966,7 +1966,7 @@ void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
 				u16 frame_type, bool reg);
 
 /* This fn is called, when this device is setup using ifconfig */
-#if !defined (NM73131_0_BOARD)
+#if !defined(NM73131_0_BOARD)
 int mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
@@ -2565,7 +2565,7 @@ int wilc_netdev_init(void)
 /*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
-#if defined (WILC_DEBUGFS)
+#if defined(WILC_DEBUGFS)
 	if (wilc_debugfs_init() < 0) {
 		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
 		return -1;
@@ -2671,7 +2671,7 @@ static void __exit exit_wilc_driver(void)
 		}
 		printk("Module_exit Done.\n");
 
-#if defined (WILC_DEBUGFS)
+#if defined(WILC_DEBUGFS)
 		wilc_debugfs_remove();
 #endif
 
-- 
1.9.1

