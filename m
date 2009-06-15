Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:35650 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZFOQME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 12:12:04 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linwille <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: restore power mode on error path
Date: Mon, 15 Jun 2009 17:49:09 +0200
Message-Id: <1245080951-24804-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k_ps_{wakeup,restore} calls must be in balance.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f7baa40..af39143 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -283,7 +283,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			"reset status %d\n",
 			channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
-		return r;
+		goto ps_restore;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -292,14 +292,17 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to restart recv logic\n");
-		return -EIO;
+		r = -EIO;
+		goto ps_restore;
 	}
 
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, sc->imask);
+
+ ps_restore:
 	ath9k_ps_restore(sc);
-	return 0;
+	return r;
 }
 
 /*
-- 
1.5.3.2

