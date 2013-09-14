Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:58002
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756519Ab3INCsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 22:48:40 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] cw1200: Use a threaded oneshot irq handler for cw1200_spi
Date: Fri, 13 Sep 2013 22:48:34 -0400
Message-Id: <1379126914-27922-1-git-send-email-pizza@shaftnet.org> (sfid-20130914_044843_495255_BA262553)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This supercedes the older patch ("cw1200: Don't perform SPI transfers in
interrupt context") that badly attempted to fix this problem.

This is a far simpler solution, with has the added benefit of actually
working.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 5a64ac9..899cad3 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -250,9 +250,10 @@ static int cw1200_spi_irq_subscribe(struct hwbus_priv *self)
 
 	pr_debug("SW IRQ subscribe\n");
 
-	ret = request_any_context_irq(self->func->irq, cw1200_spi_irq_handler,
-				      IRQF_TRIGGER_HIGH,
-				      "cw1200_wlan_irq", self);
+	ret = request_threaded_irq(self->func->irq, NULL,
+				   cw1200_spi_irq_handler,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   "cw1200_wlan_irq", self);
 	if (WARN_ON(ret < 0))
 		goto exit;
 
-- 
1.8.3.1

