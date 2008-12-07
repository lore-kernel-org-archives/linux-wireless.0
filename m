Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:43033 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYLGQsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:48:45 -0500
Received: by ti-out-0910.google.com with SMTP id b6so522409tic.23
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:48:43 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18747.65000.953959.335010@localhost.localdomain> (sfid-20081207_174849_616251_DF3B4569)
Date: Sun, 7 Dec 2008 22:16:32 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Mats Johannesson <spamcan1@abrasax.se>,
	Tomas Winkler <tomasw@gmail.com>, Jouni.Malinen@Atheros.com
Subject: [RFT] mac80211: fix HT channel selection
In-Reply-To: <1228667447.22164.46.camel@johannes.berg>
References: <1228667447.22164.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> @@ -2151,7 +2086,8 @@ static int ath9k_config(struct ieee80211
>  	struct ath_softc *sc = hw->priv;
>  	struct ieee80211_conf *conf = &hw->conf;
>  
> -	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> +	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
> +		       IEEE80211_CONF_CHANGE_HT)) {
>  		struct ieee80211_channel *curchan = hw->conf.channel;
>  		int pos;
>  

The check for AP mode should be removed. The patch below applies on top of your
patch and should handle the new changes properly.

But I'll test it tomorrow by switching like crazy among ht20/ht40/legacy,
in both STA and AP mode. :)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 3f3d75f..dc2adfd 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2089,6 +2089,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
+		ath_update_chainmask(sc, conf->ht.enabled);
+
 		pos = ath_get_channel(sc, curchan);
 		if (pos == -1) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n",
@@ -2101,8 +2103,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			(curchan->band == IEEE80211_BAND_2GHZ) ?
 			CHANNEL_G : CHANNEL_A;
 
-		if ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) &&
-		    (conf->ht.enabled)) {
+		if (conf->ht.enabled) {
 			sc->tx_chan_width = (!!conf->ht.sec_chan_offset) ?
 				ATH9K_HT_MACMODE_2040 : ATH9K_HT_MACMODE_20;
 
@@ -2118,9 +2119,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_HT)
-		ath_update_chainmask(sc, conf->ht.enabled);
-
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
