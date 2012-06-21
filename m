Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51705 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583Ab2FUONe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:34 -0400
Received: by lbbgj3 with SMTP id gj3so1915252lbb.25
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:30 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 09/12] wl18xx: explicitly remove the 5Ghz MIMO HT cap
Date: Thu, 21 Jun 2012 17:13:08 +0300
Message-Id: <1340287991-15241-10-git-send-email-coelho@ti.com> (sfid-20120621_161419_113587_7D313F11)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The 18xx chip does not support MIMO in 5Ghz. Use the siso20 HT cap as
fallback in 5Ghz when "mimo" is requested.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 066e8e5..365063b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1255,18 +1255,6 @@ static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_2ghz = {
 		},
 };
 
-static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap_5ghz = {
-	.cap = IEEE80211_HT_CAP_SGI_20,
-	.ht_supported = true,
-	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
-	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
-	.mcs = {
-		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
-		.rx_highest = cpu_to_le16(72),
-		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
-		},
-};
-
 static int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -1309,9 +1297,10 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
 		       &wl18xx_mimo_ht_cap_2ghz,
 		       sizeof(wl18xx_mimo_ht_cap_2ghz));
+		/* we don't support MIMO in 5Ghz */
 		memcpy(&wl->ht_cap[IEEE80211_BAND_5GHZ],
-		       &wl18xx_mimo_ht_cap_5ghz,
-		       sizeof(wl18xx_mimo_ht_cap_5ghz));
+		       &wl18xx_siso20_ht_cap,
+		       sizeof(wl18xx_siso20_ht_cap));
 	} else if (!strcmp(ht_mode_param, "siso20")) {
 		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
 		       &wl18xx_siso20_ht_cap,
-- 
1.7.10

