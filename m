Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20526 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0BVGlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:32 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/22] wl1271: Remove annoying PSM entry/exit kernel traces
Date: Mon, 22 Feb 2010 08:38:34 +0200
Message-Id: <1266820722-20202-15-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the annoying and dmesg-flooding WLAN PSM entry/exit traces. Instead,
only output them if PSM traces are enabled.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 184264a..4d091eb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1235,13 +1235,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * through the bss_info_changed() hook.
 		 */
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
-			wl1271_info("psm enabled");
+			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
 						 true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
-		wl1271_info("psm disabled");
+		wl1271_debug(DEBUG_PSM, "psm disabled");
 
 		clear_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
 
-- 
1.6.3.3

