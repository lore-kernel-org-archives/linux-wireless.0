Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57801 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbJ0JZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:05 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 01/27] staging: wicl1000: isr_uh_routine: use netdev private wilc
Date: Tue, 27 Oct 2015 18:27:37 +0900
Message-ID: <1445938083-20445-1-git-send-email-glen.lee@atmel.com> (sfid-20151027_102510_336790_9DCE9AA7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use netdev private member wilc instead of g_linux_wlan and change argument wilc
with dev in the function request_threaded_irq to pass back to handler
the function isr_uh_routine.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ded302a..324cc57 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -229,10 +229,16 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+	struct net_device *dev = (struct net_device *)user_data;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
 	PRINT_D(INT_DBG, "Interrupt received UH\n");
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle UH interrupt\n");
 		return IRQ_HANDLED;
 	}
@@ -284,7 +290,7 @@ static int init_irq(struct net_device *dev)
 
 	if ((ret != -1) && (request_threaded_irq(wl->dev_irq_num, isr_uh_routine, isr_bh_routine,
 						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,               /*Without IRQF_ONESHOT the uh will remain kicked in and dont gave a chance to bh*/
-						  "WILC_IRQ", wl)) < 0) {
+						  "WILC_IRQ", dev)) < 0) {
 
 		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
 		ret = -1;
-- 
1.9.1

