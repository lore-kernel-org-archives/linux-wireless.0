Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20548 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0BVGln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:43 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/22] wl1271: Remove tx-power level workaround
Date: Mon, 22 Feb 2010 08:38:42 +0200
Message-Id: <1266820722-20202-23-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the workaround limiting chipset TX power to 12dB, instead
using the value configured by the mac80211.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index f41f886..60e2087 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -135,12 +135,7 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 		goto out;
 	}
 
-	/*
-	 * FIXME: This is a workaround needed while we don't the correct
-	 * calibration, to avoid distortions
-	 */
-	/* acx->current_tx_power = power * 10; */
-	acx->current_tx_power = 120;
+	acx->current_tx_power = power * 10;
 
 	ret = wl1271_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
 	if (ret < 0) {
-- 
1.6.3.3

