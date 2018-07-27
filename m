Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46144 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeG0KGd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:06:33 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: simon@thekelleys.org.uk, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: atmel: Replace mdelay() with msleep() in probe_atmel_card()
Date: Fri, 27 Jul 2018 16:45:35 +0800
Message-Id: <20180727084535.3848-1-baijiaju1990@gmail.com> (sfid-20180727_104557_637007_6D4ADD57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

probe_atmel_card() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/atmel/atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index d122386c382b..d90f04e14292 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -3692,7 +3692,7 @@ static int probe_atmel_card(struct net_device *dev)
 		atmel_write16(dev, GCR, 0x0060);
 
 	atmel_write16(dev, GCR, 0x0040);
-	mdelay(500);
+	msleep(500);
 
 	if (atmel_read16(dev, MR2) == 0) {
 		/* No stored firmware so load a small stub which just
-- 
2.17.0
