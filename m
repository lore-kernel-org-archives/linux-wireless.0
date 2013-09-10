Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36638 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IJIzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:55:43 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00D65JGTR8R0@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:55:42 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Solomon Peachy' <pizza@shaftnet.org>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 4/8] wireless: cw1200: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:55:41 +0900
Message-id: <005601ceae03$8716db00$95449100$%han@samsung.com> (sfid-20130910_105546_258180_524AE621)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/cw1200/cw1200_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index d063760..b7d1e0f 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -355,7 +355,7 @@ static struct hwbus_ops cw1200_spi_hwbus_ops = {
 static int cw1200_spi_probe(struct spi_device *func)
 {
 	const struct cw1200_platform_data_spi *plat_data =
-		func->dev.platform_data;
+		dev_get_platdata(&func->dev);
 	struct hwbus_priv *self;
 	int status;
 
@@ -431,7 +431,7 @@ static int cw1200_spi_disconnect(struct spi_device *func)
 		}
 		kfree(self);
 	}
-	cw1200_spi_off(func->dev.platform_data);
+	cw1200_spi_off(dev_get_platdata(&func->dev));
 
 	return 0;
 }
-- 
1.7.10.4


