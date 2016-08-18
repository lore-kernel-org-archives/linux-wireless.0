Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38213
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768091AbcHROSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 10:18:05 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwifiex: propagate error if IRQ request fails in mwifiex_sdio_of()
Date: Thu, 18 Aug 2016 10:17:48 -0400
Message-Id: <1471529868-13669-1-git-send-email-javier@osg.samsung.com> (sfid-20160818_162132_485592_1108F040)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If request_irq() fails in mwifiex_sdio_probe_of(), only an error message
is printed but the actual error is not propagated to the caller function.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index d3e1561ca075..00727936ad6e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -125,6 +125,7 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 				dev_err(dev,
 					"Failed to request irq_wifi %d (%d)\n",
 					cfg->irq_wifi, ret);
+				return ret;
 			}
 			disable_irq(cfg->irq_wifi);
 		}
-- 
2.5.5
