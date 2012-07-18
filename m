Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:43507 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656Ab2GRMOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:14:00 -0400
Received: by lbon10 with SMTP id n10so3739674lbo.27
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 12/14] wl18xx: enable MIMO rates when connected as a MIMO STA
Date: Wed, 18 Jul 2012 15:13:31 +0300
Message-Id: <1342613613-917-13-git-send-email-coelho@ti.com> (sfid-20120718_141420_525600_ABCE2B30)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Use this opportunity to consolidate the check for MIMO support into a
separate function.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 2b9398c..69042bb 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1013,6 +1013,13 @@ static void wl18xx_set_rx_csum(struct wl1271 *wl,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
+static bool wl18xx_is_mimo_supported(struct wl1271 *wl)
+{
+	struct wl18xx_priv *priv = wl->priv;
+
+	return priv->conf.phy.number_of_assembled_ant2_4 >= 2;
+}
+
 /*
  * TODO: instead of having these two functions to get the rate mask,
  * we should modify the wlvif->rate_set instead
@@ -1029,6 +1036,9 @@ static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 
 		/* we don't support MIMO in wide-channel mode */
 		hw_rate_set &= ~CONF_TX_MIMO_RATES;
+	} else if (wl18xx_is_mimo_supported(wl)) {
+		wl1271_debug(DEBUG_ACX, "using MIMO channel rate mask");
+		hw_rate_set |= CONF_TX_MIMO_RATES;
 	}
 
 	return hw_rate_set;
@@ -1037,8 +1047,6 @@ static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 					     struct wl12xx_vif *wlvif)
 {
-	struct wl18xx_priv *priv = wl->priv;
-
 	if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
 	    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
 		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
@@ -1048,7 +1056,7 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 			return 0;
 
 		return CONF_TX_RATE_USE_WIDE_CHAN;
-	} else if (priv->conf.phy.number_of_assembled_ant2_4 >= 2 &&
+	} else if (wl18xx_is_mimo_supported(wl) &&
 		   wlvif->band == IEEE80211_BAND_2GHZ) {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
 		/*
@@ -1478,7 +1486,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		 * Only support mimo with multiple antennas. Fall back to
 		 * siso20.
 		 */
-		if (priv->conf.phy.number_of_assembled_ant2_4 >= 2)
+		if (wl18xx_is_mimo_supported(wl))
 			wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
 					  &wl18xx_mimo_ht_cap_2ghz);
 		else
-- 
1.7.10.4

