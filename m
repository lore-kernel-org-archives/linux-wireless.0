Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42477 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYJWD2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 23:28:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 20:28:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Allow user to change tx power when asked
Date: Wed, 22 Oct 2008 13:28:45 -0700
Message-ID: <1224707325-13101-3-git-send-email-lrodriguez@atheros.com> (sfid-20081023_052913_211688_155DC9EE)
In-Reply-To: <1224707325-13101-2-git-send-email-lrodriguez@atheros.com>
References: <1224707325-13101-1-git-send-email-lrodriguez@atheros.com>
 <1224707325-13101-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were also changing tx power even when we were not asked to,
this enforces the change only when we are asked nicely. When
not asked we simply try to use the max power, we don't tx power
at all for rate control.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 ++-
 drivers/net/wireless/ath9k/xmit.c |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5b49552..02e00bd 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1251,7 +1251,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		sc->sc_ah->ah_channels[pos].chanmode =
 			ath_get_extchanmode(sc, curchan);
 
-	sc->sc_config.txpowlimit = 2 * conf->power_level;
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
 	/* set h/w channel */
 	if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 781c6cc..7fbcb20 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -230,7 +230,13 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 	txctl->if_id = 0;
 	txctl->frmlen = skb->len + FCS_LEN - (hdrlen & 3);
-	txctl->txpower = MAX_RATE_POWER; /* FIXME */
+
+	/* Always try at highest power possible unless the the device
+	 * was configured by the user to use another power. */
+	if (likely(sc->sc_config.txpowlimit == ATH_TXPOWER_MAX))
+		txctl->txpower = ATH_TXPOWER_MAX;
+	else
+		txctl->txpower = sc->sc_config.txpowlimit;
 
 	/* Fill Key related fields */
 
-- 
1.5.6.3

