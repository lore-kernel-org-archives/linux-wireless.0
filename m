Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63501 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762584AbZLKLli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:38 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/31] wl1271: fix tx power setting function
Date: Fri, 11 Dec 2009 13:40:58 +0200
Message-Id: <1260531682-4695-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1271 firmware supports maximun 25.5dBm, so the driver was returning
-EINVALID to anything above that.  The new mac80211 stack uses 27dBm as
default TX power, so we were never setting this correctly.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 5cc89bb..59bb95b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -127,8 +127,14 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 
 	wl1271_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
 
-	if (power < 0 || power > 25)
+	if (power < 0)
 		return -EINVAL;
+	else if (power > 25)
+		/*
+		 * The power is a uint8 in the firmware, so we can't have
+		 * anything higher than 25 (this value is multiplied by 10)
+		 */
+		power = 25;
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
-- 
1.6.3.3

