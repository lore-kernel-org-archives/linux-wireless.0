Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52960 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaHBLVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 07:21:33 -0400
Date: Sat, 2 Aug 2014 16:51:30 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] net: wireless: wl1251: Remove unnecessary free_irq
Message-ID: <20140802112130.GA3193@himangi-Dell> (sfid-20140802_132203_203760_CE007B41)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does away with free_irq in the remove function as the irq is
allocated with a devm_request_irq.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
I'm not sure that devm_request_irq should be used in
the first place, as it will move the stopping of the interrupt over
wl1251_free_hw. Should I use request_irq?
 drivers/net/wireless/ti/wl1251/spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index a0aa8fa..735be53 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -345,7 +345,6 @@ static int wl1251_spi_remove(struct spi_device *spi)
 {
 	struct wl1251 *wl = spi_get_drvdata(spi);
 
-	free_irq(wl->irq, wl);
 	wl1251_free_hw(wl);
 	regulator_disable(wl->vio);
 
-- 
1.9.1

