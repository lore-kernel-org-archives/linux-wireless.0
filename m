Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36342 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:10:30 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/73] staging: wilc1000: fixes alignment should match open parenthesis
Date: Fri, 6 Nov 2015 11:12:22 +0900
Message-ID: <1446776014-28094-1-git-send-email-glen.lee@atmel.com> (sfid-20151106_031034_215689_530B1ED2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for alignment should match open parenthesis

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f82ecb9..976964d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -264,9 +264,11 @@ static int init_irq(struct net_device *dev)
 		PRINT_ER("could not obtain gpio for WILC_INTR\n");
 	}
 
-	if ((ret != -1) && (request_threaded_irq(wl->dev_irq_num, isr_uh_routine, isr_bh_routine,
-						  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-						  "WILC_IRQ", dev)) < 0) {
+	if (ret != -1 && request_threaded_irq(wl->dev_irq_num,
+					      isr_uh_routine,
+					      isr_bh_routine,
+					      IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					      "WILC_IRQ", dev) < 0) {
 		PRINT_ER("Failed to request IRQ for GPIO: %d\n", GPIO_NUM);
 		ret = -1;
 	} else {
@@ -1472,8 +1474,7 @@ void wl_wlan_cleanup(struct wilc *wilc)
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
 
-	if (wilc &&
-	   (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
+	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-- 
1.9.1

