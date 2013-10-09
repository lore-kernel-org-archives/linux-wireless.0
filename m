Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47151
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754467Ab3JIQPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 12:15:16 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, stable@vger.kernel.org,
	David Mosberger <davidm@egauge.net>
Subject: [PATCH] wireless: cw1200: acquire hwbus lock around cw1200_irq_handler() call.
Date: Wed,  9 Oct 2013 12:15:11 -0400
Message-Id: <1381335311-20842-1-git-send-email-pizza@shaftnet.org> (sfid-20131009_181520_714499_CD3D28BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes "lost interrupt" problems that occurred on SPI-based systems.
cw1200_irq_handler() expects the hwbus to be locked, but on the
SPI-path, that lock wasn't taken (unlike in the SDIO-path, where the
generic SDIO-code takes care of acquiring the lock).

Cc: stable@vger.kernel.org
Signed-off-by: David Mosberger <davidm@egauge.net>
Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
Please consider this for 3.12-rc if it's not too late!

 drivers/net/wireless/cw1200/cw1200_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 899cad3..755a0c8 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -237,7 +237,9 @@ static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
+		cw1200_spi_lock(self);
 		cw1200_irq_handler(self->core);
+		cw1200_spi_unlock(self);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
-- 
1.8.3.1

