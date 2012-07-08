Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34234 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2GHHXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:51 -0400
Received: by lboj14 with SMTP id j14so20797154lbo.21
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 8/8] wlcore: determine AP extra rates correctly
Date: Sun,  8 Jul 2012 10:23:31 +0300
Message-Id: <1341732211-25871-9-git-send-email-coelho@ti.com> (sfid-20120708_092356_932348_2FE6A350)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Don't use the ht_mode module parameter for determining AP supported
rates. We can rely on channel type, since HT40 won't be enabled if our
HT cap doesn't support it.

Enable MIMO only if there enough antennas, and rely on per-peer rate
limitation to prevent IOPs.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index aea2e32..1b2fb1d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1036,14 +1036,24 @@ static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 					     struct wl12xx_vif *wlvif)
 {
-	if ((wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
-	     wlvif->channel_type == NL80211_CHAN_HT40PLUS) &&
-	    !strcmp(ht_mode_param, "wide")) {
+	struct wl18xx_priv *priv = wl->priv;
+
+	if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
+	    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
 		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
+
+		/* sanity check - we don't support this */
+		if (WARN_ON(wlvif->band != IEEE80211_BAND_5GHZ))
+			return 0;
+
 		return CONF_TX_RATE_USE_WIDE_CHAN;
-	} else if (!strcmp(ht_mode_param, "mimo")) {
+	} else if (priv->conf.phy.number_of_assembled_ant2_4 >= 2 &&
+		   wlvif->band == IEEE80211_BAND_2GHZ) {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
-
+		/*
+		 * we don't care about HT channel here - if a peer doesn't
+		 * support MIMO, we won't enable it in its rates
+		 */
 		return CONF_TX_MIMO_RATES;
 	} else {
 		return 0;
-- 
1.7.10

