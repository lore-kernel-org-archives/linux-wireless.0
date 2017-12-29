Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59051 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdL2VkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 16:40:16 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] p54spi: Delete an error message for a failed memory
 allocation in p54spi_rx()
Message-ID: <bd089cea-62a5-620b-78d2-d13a2911006e@users.sourceforge.net> (sfid-20171229_224039_102664_222699AA)
Date: Fri, 29 Dec 2017 22:40:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 29 Dec 2017 22:33:10 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/intersil/p54/p54spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index e41bf042352e..900cfaacf25e 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -367,7 +367,6 @@ static int p54spi_rx(struct p54s_priv *priv)
 	skb = dev_alloc_skb(len + 4);
 	if (!skb) {
 		p54spi_sleep(priv);
-		dev_err(&priv->spi->dev, "could not alloc skb");
 		return -ENOMEM;
 	}
 
-- 
2.15.1
