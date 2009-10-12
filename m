Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59007 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZJLMNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:45 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/16] wl1271: add workaround to avoid distortion due to excessive tx power
Date: Mon, 12 Oct 2009 15:08:44 +0300
Message-Id: <1255349337-9776-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We still don't have proper calibration for our devices, so we are using way
too much power for TX, which causes a lot of distortion.  This hack hardcodes
the txpower to 7dBm.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index b9dfa09..d5dac57 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -137,7 +137,12 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 		goto out;
 	}
 
-	acx->current_tx_power = power * 10;
+	/*
+	 * FIXME: This is a workaround needed while we don't the correct
+	 * calibration, to avoid distortions
+	 */
+	/* acx->current_tx_power = power * 10; */
+	acx->current_tx_power = 70;
 
 	ret = wl1271_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
 	if (ret < 0) {
-- 
1.5.6.5

