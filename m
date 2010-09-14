Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51384 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0INUof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 16:44:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1271: remove warnings in wl1271_sdio_set_power
Date: Tue, 14 Sep 2010 16:30:43 -0400
Message-Id: <1284496243-28484-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20100914203000.GF2484@tuxdriver.com>
References: <20100914203000.GF2484@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were introduced in "wl1271: sdio: claim host only when doing IO"

drivers/net/wireless/wl12xx/wl1271_sdio.c: In function ‘wl1271_sdio_set_power’:
drivers/net/wireless/wl12xx/wl1271_sdio.c:193: warning: ‘return’ with a value, in function returning void
drivers/net/wireless/wl12xx/wl1271_sdio.c:195: warning: ‘return’ with a value, in function returning void
drivers/net/wireless/wl12xx/wl1271_sdio.c:186: warning: unused variable ‘func’

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index b3c3158..b5d9565 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -159,40 +159,34 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 		wl1271_error("sdio write failed (%d)", ret);
 }
 
-static int wl1271_sdio_power_on(struct wl1271 *wl)
+static void wl1271_sdio_power_on(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 	sdio_release_host(func);
-
-	return 0;
 }
 
-static int wl1271_sdio_power_off(struct wl1271 *wl)
+static void wl1271_sdio_power_off(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
-
-	return 0;
 }
 
 static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
-	struct sdio_func *func = wl_to_func(wl);
-
 	/* Let the SDIO stack handle wlan_enable control, so we
 	 * keep host claimed while wlan is in use to keep wl1271
 	 * alive.
 	 */
 	if (enable)
-		return wl1271_sdio_power_on(wl);
+		wl1271_sdio_power_on(wl);
 	else
-		return wl1271_sdio_power_off(wl);
+		wl1271_sdio_power_off(wl);
 
 }
 
-- 
1.7.2.2

