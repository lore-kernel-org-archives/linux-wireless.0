Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43921 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAJBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:01:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:01:16 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.34513.730914.486113@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 14:50:17 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix HT rate control configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The operating channel type is now handed down to
the driver by mac80211, use it directly.
This fixes HT-mode operation.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ac34a05..0e79e58 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1323,7 +1323,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta, void *priv_sta,
-			    u32 changed)
+			    u32 changed, enum nl80211_channel_type oper_chan_type)
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
@@ -1340,8 +1340,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 			return;
 
-		if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
-		    sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
+		if (oper_chan_type == NL80211_CHAN_HT40MINUS ||
+		    oper_chan_type == NL80211_CHAN_HT40PLUS)
 			oper_cw40 = true;
 
 		oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
-- 
1.7.0.1

