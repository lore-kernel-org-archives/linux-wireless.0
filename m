Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36984 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3IJI5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:57:11 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00931JIZNZT0@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:57:05 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 6/8] wireless: wl1251: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:57:05 +0900
Message-id: <005801ceae03$b93890b0$2ba9b210$%han@samsung.com> (sfid-20130910_105714_678047_BA183444)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ti/wl1251/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index c7dc6fe..1342f81 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -243,7 +243,7 @@ static int wl1251_spi_probe(struct spi_device *spi)
 	struct wl1251 *wl;
 	int ret;
 
-	pdata = spi->dev.platform_data;
+	pdata = dev_get_platdata(&spi->dev);
 	if (!pdata) {
 		wl1251_error("no platform data");
 		return -ENODEV;
-- 
1.7.10.4


