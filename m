Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:34578
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab3JYWPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 18:15:47 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 2/2] wireless: cw1200: Use consistent internal  locking conventions
Date: Fri, 25 Oct 2013 18:15:43 -0400
Message-Id: <1382739343-5727-2-git-send-email-pizza@shaftnet.org> (sfid-20131026_001551_491142_F8A3FCFA)
In-Reply-To: <1382739343-5727-1-git-send-email-pizza@shaftnet.org>
References: <1382739343-5727-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cw1200_irq_handler() function expects the hwbus lock to be held when
it is called.  On the SDIO platform, this lock is implemented in terms
of sdio_claim_host/sdio_release_host.

This trivial patch makes it explicit that we are performing the hwbus
lock rather than something SDIO-specific.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index ebdcdf4..d3acc85 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -108,9 +108,9 @@ static irqreturn_t cw1200_gpio_irq(int irq, void *dev_id)
 	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
-		sdio_claim_host(self->func);
+		cw1200_sdio_lock(self);
 		cw1200_irq_handler(self->core);
-		sdio_release_host(self->func);
+		cw1200_sdio_unlock(self);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
-- 
1.8.3.1

