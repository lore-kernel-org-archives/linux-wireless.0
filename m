Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60274 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbZLKNl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:29 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/31] wl1271: limit TX power to 25dBm for every channel
Date: Fri, 11 Dec 2009 15:40:46 +0200
Message-Id: <1260538870-32297-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1271 firmware supports maximun 25.5dBm, so the driver was returning
-EINVALID to anything above that.  This patch uses the channel max_power
option to limit the TX power to 25dBm.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f6d42e6..7f164e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1675,19 +1675,19 @@ static struct ieee80211_rate wl1271_rates[] = {
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_channel wl1271_channels[] = {
-	{ .hw_value = 1, .center_freq = 2412},
-	{ .hw_value = 2, .center_freq = 2417},
-	{ .hw_value = 3, .center_freq = 2422},
-	{ .hw_value = 4, .center_freq = 2427},
-	{ .hw_value = 5, .center_freq = 2432},
-	{ .hw_value = 6, .center_freq = 2437},
-	{ .hw_value = 7, .center_freq = 2442},
-	{ .hw_value = 8, .center_freq = 2447},
-	{ .hw_value = 9, .center_freq = 2452},
-	{ .hw_value = 10, .center_freq = 2457},
-	{ .hw_value = 11, .center_freq = 2462},
-	{ .hw_value = 12, .center_freq = 2467},
-	{ .hw_value = 13, .center_freq = 2472},
+	{ .hw_value = 1, .center_freq = 2412, .max_power = 25 },
+	{ .hw_value = 2, .center_freq = 2417, .max_power = 25 },
+	{ .hw_value = 3, .center_freq = 2422, .max_power = 25 },
+	{ .hw_value = 4, .center_freq = 2427, .max_power = 25 },
+	{ .hw_value = 5, .center_freq = 2432, .max_power = 25 },
+	{ .hw_value = 6, .center_freq = 2437, .max_power = 25 },
+	{ .hw_value = 7, .center_freq = 2442, .max_power = 25 },
+	{ .hw_value = 8, .center_freq = 2447, .max_power = 25 },
+	{ .hw_value = 9, .center_freq = 2452, .max_power = 25 },
+	{ .hw_value = 10, .center_freq = 2457, .max_power = 25 },
+	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
+	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
+	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
 };
 
 /* can't be const, mac80211 writes to this */
-- 
1.6.3.3

