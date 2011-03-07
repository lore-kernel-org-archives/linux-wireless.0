Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1CGHZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 02:25:02 -0500
Message-ID: <4D7486B3.3090507@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 15:18:11 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
MIME-Version: 1.0
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
	jmalinen@atheros.com, vasanth@atheros.com,
	senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH ] wireless:ath: use resource_size() help function
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c |    2 +-
 drivers/net/wireless/ath/ath9k/ahb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index ae84b86..82324e9 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -93,7 +93,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	mem = ioremap_nocache(res->start, res->end - res->start + 1);
+	mem = ioremap_nocache(res->start, resource_size(res));
 	if (mem == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 9936721..9cb0efa 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -75,7 +75,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	mem = ioremap_nocache(res->start, res->end - res->start + 1);
+	mem = ioremap_nocache(res->start, resource_size(res));
 	if (mem == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
-- 
1.6.3.3
