Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31765 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3IJI4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:56:41 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00EZJJFG4SU0@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:56:27 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 5/8] wireless: libertas: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:56:27 +0900
Message-id: <005701ceae03$a286a0f0$e793e2d0$%han@samsung.com> (sfid-20130910_105645_119438_2C605AB2)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/libertas/if_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 4bb6574..5d39ec8 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1128,7 +1128,7 @@ static int if_spi_probe(struct spi_device *spi)
 {
 	struct if_spi_card *card;
 	struct lbs_private *priv = NULL;
-	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
+	struct libertas_spi_platform_data *pdata = dev_get_platdata(&spi->dev);
 	int err = 0;
 
 	lbs_deb_enter(LBS_DEB_SPI);
-- 
1.7.10.4


