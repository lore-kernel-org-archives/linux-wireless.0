Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33191 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0CRK1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:52 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 17/21] wl1271: Removed duplicate code from module remove function.
Date: Thu, 18 Mar 2010 12:26:42 +0200
Message-Id: <1268908006-16992-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Removed duplicate code from wl1271_sdio module remove function. For
freeing stuff in the remove function wl1271_free_hw function is now
used.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 0478919..99b5b3f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -248,20 +248,9 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl1271 *wl = sdio_get_drvdata(func);
 
-	ieee80211_unregister_hw(wl->hw);
-
 	free_irq(wl->irq, wl);
 
-	kfree(wl->target_mem_map);
-	vfree(wl->fw);
-	wl->fw = NULL;
-	kfree(wl->nvs);
-	wl->nvs = NULL;
-
-	kfree(wl->fw_status);
-	kfree(wl->tx_res_if);
-
-	ieee80211_free_hw(wl->hw);
+	wl1271_free_hw(wl);
 }
 
 static struct sdio_driver wl1271_sdio_driver = {
-- 
1.6.3.3

