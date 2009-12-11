Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60470 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbZLKNlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:49 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 23/31] wl1271: Add pre-power-on sleep
Date: Fri, 11 Dec 2009 15:41:02 +0200
Message-Id: <1260538870-32297-24-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds a short delay before powering on the wl1271. Normally, it is
not needed, but if the wl1271 has been powered off shortly before, for reliable
firmware-booting this small stabilization delay is required.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 81e1c95..c965c4a 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -458,7 +458,9 @@ int wl1271_plt_stop(struct wl1271 *wl);
 
 #define WL1271_TX_QUEUE_MAX_LENGTH 20
 
-/* WL1271 needs a 200ms sleep after power on */
+/* WL1271 needs a 200ms sleep after power on, and a 20ms sleep before power
+   on in case is has been shut down shortly before */
+#define WL1271_PRE_POWER_ON_SLEEP 20 /* in miliseconds */
 #define WL1271_POWER_ON_SLEEP 200 /* in miliseconds */
 
 static inline bool wl1271_11a_enabled(void)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0795bf3..0520b38 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -618,6 +618,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	struct wl1271_partition_set partition;
 	int ret = 0;
 
+	msleep(WL1271_PRE_POWER_ON_SLEEP);
 	wl1271_power_on(wl);
 	msleep(WL1271_POWER_ON_SLEEP);
 	wl1271_spi_reset(wl);
-- 
1.6.3.3

