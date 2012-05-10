Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab2EJJQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:42 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 60/78] wlcore: use all AP basic rates as default
Date: Thu, 10 May 2012 12:14:05 +0300
Message-Id: <1336641263-5761-61-git-send-email-arik@wizery.com> (sfid-20120510_111840_246331_E35E7A71)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Sometimes we get a BSS_CHANGED_BEACON_ENABLED event before the basic
rates have been properly set.  To avoid problems with the firmware not
expecting to receive frames at rates that are not set during
CMD_START_ROLE, we now start with all basic rates by default.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f952098..1d9c11c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1845,6 +1845,9 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.basic_rate_idx);
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.ap_rate_idx);
 		wl12xx_allocate_rate_policy(wl, &wlvif->sta.p2p_rate_idx);
+		wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
+		wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
+		wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 	} else {
 		/* init ap data */
 		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
@@ -1854,13 +1857,19 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		for (i = 0; i < CONF_TX_MAX_AC_COUNT; i++)
 			wl12xx_allocate_rate_policy(wl,
 						&wlvif->ap.ucast_rate_idx[i]);
+		wlvif->basic_rate_set = CONF_TX_AP_ENABLED_RATES;
+		/*
+		 * TODO: check if basic_rate shouldn't be
+		 * wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+		 * instead (the same thing for STA above).
+		*/
+		wlvif->basic_rate = CONF_TX_AP_ENABLED_RATES;
+		/* TODO: this seems to be used only for STA, check it */
+		wlvif->rate_set = CONF_TX_AP_ENABLED_RATES;
 	}
 
 	wlvif->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
 	wlvif->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
-	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
-	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
-	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
 	/*
-- 
1.7.9.5

