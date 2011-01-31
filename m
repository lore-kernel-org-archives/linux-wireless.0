Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14690 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab1AaSSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:18:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:18:25 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/5] ath9k: move update tx power to common
Date: Mon, 31 Jan 2011 23:47:44 +0530
Message-ID: <1296497866-3189-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
References: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ath_update_txpow to common to remove code duplication
in both ath9k & ath9k_htc.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/common.h |    2 ++
 drivers/net/wireless/ath/ath9k/main.c   |   26 ++++++++++----------------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index df1998d..615e682 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -189,6 +189,17 @@ void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
 }
 EXPORT_SYMBOL(ath9k_cmn_btcoex_bt_stomp);
 
+void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
+			    u16 new_txpow, u16 *txpower)
+{
+	if (cur_txpow != new_txpow) {
+		ath9k_hw_set_txpowerlimit(ah, new_txpow, false);
+		/* read back in case value is clamped */
+		*txpower = ath9k_hw_regulatory(ah)->power_limit;
+	}
+}
+EXPORT_SYMBOL(ath9k_cmn_update_txpow);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 4c7020b..b2f7b5f 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -68,3 +68,5 @@ struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
 void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
 				  enum ath_stomp_type stomp_type);
+void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
+			    u16 new_txpow, u16 *txpower);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9e3faa6..21e8d29 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -18,17 +18,6 @@
 #include "ath9k.h"
 #include "btcoex.h"
 
-static void ath_update_txpow(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (sc->curtxpow != sc->config.txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
-		/* read back in case value is clamped */
-		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
-	}
-}
-
 static u8 parse_mpdudensity(u8 mpdudensity)
 {
 	/*
@@ -271,7 +260,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		goto ps_restore;
 	}
 
-	ath_update_txpow(sc);
+	ath9k_cmn_update_txpow(ah, sc->curtxpow,
+			       sc->config.txpowlimit, &sc->curtxpow);
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
@@ -857,7 +847,8 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			channel->center_freq, r);
 	}
 
-	ath_update_txpow(sc);
+	ath9k_cmn_update_txpow(ah, sc->curtxpow,
+			       sc->config.txpowlimit, &sc->curtxpow);
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
 		goto out;
@@ -960,7 +951,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_update_txpow(sc);
+	ath9k_cmn_update_txpow(ah, sc->curtxpow,
+			       sc->config.txpowlimit, &sc->curtxpow);
 
 	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -1036,7 +1028,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * This is needed only to setup initial state
 	 * but it's best done after a reset.
 	 */
-	ath_update_txpow(sc);
+	ath9k_cmn_update_txpow(ah, sc->curtxpow,
+			sc->config.txpowlimit, &sc->curtxpow);
 
 	/*
 	 * Setup the hardware after reset:
@@ -1701,7 +1694,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
 		ath9k_ps_wakeup(sc);
-		ath_update_txpow(sc);
+		ath9k_cmn_update_txpow(ah, sc->curtxpow,
+				       sc->config.txpowlimit, &sc->curtxpow);
 		ath9k_ps_restore(sc);
 	}
 
-- 
1.7.3.5

