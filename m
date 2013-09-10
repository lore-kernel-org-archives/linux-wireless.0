Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36277 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IJI6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:58:46 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW0097NJL7PI60@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:58:32 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Luciano Coelho' <luca@coelho.fi>
References: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
In-reply-to: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com>
Subject: [PATCH 8/8] wireless: wl12xx: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:58:32 +0900
Message-id: <005a01ceae03$ece02310$c6a06930$%han@samsung.com> (sfid-20130910_105849_925148_CE3D18DB)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1c627da..591526b 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1704,7 +1704,7 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
-	struct wlcore_platdev_data *pdev_data = wl->pdev->dev.platform_data;
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&wl->pdev->dev);
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	wl->rtable = wl12xx_rtable;
-- 
1.7.10.4


