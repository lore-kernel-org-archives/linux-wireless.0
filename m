Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41687 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 24/31] wl18xx: default to siso40 in 2.4ghz with a single antenna
Date: Thu, 27 Sep 2012 13:38:02 +0300
Message-Id: <1348742289-6587-25-git-send-email-luca@coelho.fi> (sfid-20120927_123858_432671_A496C505)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The driver used siso20 in this case for legacy reasons.

Reported-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9bf2d87..44e5cad 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1485,14 +1485,14 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (priv->conf.ht.mode == HT_MODE_DEFAULT) {
 		/*
 		 * Only support mimo with multiple antennas. Fall back to
-		 * siso20.
+		 * siso40.
 		 */
 		if (wl18xx_is_mimo_supported(wl))
 			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
 					  &wl18xx_mimo_ht_cap_2ghz);
 		else
 			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
-					  &wl18xx_siso20_ht_cap);
+					  &wl18xx_siso40_ht_cap_2ghz);
 
 		/* 5Ghz is always wide */
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
-- 
1.7.10.4

