Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36131 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3IJI57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:57:59 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW004EBJKK7GC0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:57:58 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Luciano Coelho' <luca@coelho.fi>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 7/8] wireless: wlcore: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:57:57 +0900
Message-id: <005901ceae03$d88d31f0$89a795d0$%han@samsung.com> (sfid-20130910_105809_961716_22E390E9)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 38995f9..c30e1f1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5900,7 +5900,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
 	struct wl1271 *wl = context;
 	struct platform_device *pdev = wl->pdev;
-	struct wlcore_platdev_data *pdev_data = pdev->dev.platform_data;
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 	unsigned long irqflags;
 	int ret;
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 1b0cd98..b2c018d 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -335,7 +335,7 @@ static int wl1271_probe(struct spi_device *spi)
 	if (!pdev_data)
 		goto out;
 
-	pdev_data->pdata = spi->dev.platform_data;
+	pdev_data->pdata = dev_get_platdata(&spi->dev);
 	if (!pdev_data->pdata) {
 		dev_err(&spi->dev, "no platform data\n");
 		ret = -ENODEV;
-- 
1.7.10.4


