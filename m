Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbdA2NCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 08:02:46 -0500
Date: Sun, 29 Jan 2017 12:40:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] rt2x00: fix clk_get call
Message-ID: <20170129114052.GB7489@redhat.com> (sfid-20170129_140249_899250_4DAEBE10)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

clk_get() takes two arguments and might return ERR_PTR(), so we
have to nullify pointer on that case, to do not break further call
to clk_get_rate().

Reported-by: Felix Fietkau <nbd@nbd.name>
Fixes: 34db70b92fae5 ("rt2x00: add copy of clk for soc devices")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
index 362f9d3..29250f7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
@@ -92,7 +92,10 @@ int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
 	rt2x00dev->hw = hw;
 	rt2x00dev->irq = platform_get_irq(pdev, 0);
 	rt2x00dev->name = pdev->dev.driver->name;
-	rt2x00dev->clk = clk_get(&pdev->dev);
+
+	rt2x00dev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rt2x00dev->clk))
+		rt2x00dev->clk = NULL;
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
 
-- 
1.8.3.1
