Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20515 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0BVGl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:28 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 09/22] wl1271: Fixed unloading of the wl1271_sdio module
Date: Mon, 22 Feb 2010 08:38:29 +0200
Message-Id: <1266820722-20202-10-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Fixed two bugs causing problems when unloding wl1271 module. First was
missing sdio_set_drvdata call from the probe function, second was order
of function calls in the remove function.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index be5c149..7d7c850 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -219,6 +219,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 		goto out_irq;
 
 	sdio_claim_host(func);
+	sdio_set_drvdata(func, wl);
+
 	ret = sdio_enable_func(func);
 	if (ret)
 		goto out_release;
@@ -246,10 +248,11 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl1271 *wl = sdio_get_drvdata(func);
 
+	ieee80211_unregister_hw(wl->hw);
+
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
-	ieee80211_unregister_hw(wl->hw);
 
 	free_irq(wl->irq, wl);
 
-- 
1.6.3.3

