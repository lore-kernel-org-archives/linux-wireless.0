Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17990 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFDNr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:27 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 02/13] ath9k: Move txpower limit to channel context
Date: Wed, 4 Jun 2014 19:16:28 +0530
Message-ID: <1401889599-412-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154732_504615_3D46B280)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 6 +-----
 drivers/net/wireless/ath/ath9k/channel.c | 1 +
 drivers/net/wireless/ath/ath9k/init.c    | 5 ++---
 drivers/net/wireless/ath/ath9k/main.c    | 6 +++---
 drivers/net/wireless/ath/ath9k/mci.c     | 2 +-
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index cc75b9d..840cdf9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -36,10 +36,6 @@ extern int ath9k_modparam_nohwcrypt;
 extern int led_blink;
 extern bool is_ath9k_unloaded;
 
-struct ath_config {
-	u16 txpowlimit;
-};
-
 /*************************/
 /* Descriptor Management */
 /*************************/
@@ -328,6 +324,7 @@ struct ath_rx {
 struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
+	u16 txpower;
 	bool offchannel;
 };
 
@@ -753,7 +750,6 @@ struct ath_softc {
 	short nvifs;
 	unsigned long ps_usecount;
 
-	struct ath_config config;
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index aee6cdb..1b40cf5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -118,6 +118,7 @@ void ath_chanctx_init(struct ath_softc *sc)
 		ctx = &sc->chanctx[i];
 		cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 		INIT_LIST_HEAD(&ctx->vifs);
+		ctx->txpower = ATH_TXPOWER_MAX;
 	}
 	sc->cur_chan = &sc->chanctx[0];
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 32d9542..ffd42bf 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -169,9 +169,9 @@ static void ath9k_reg_notifier(struct wiphy *wiphy,
 
 	/* Set tx power */
 	if (ah->curchan) {
-		sc->config.txpowlimit = 2 * ah->curchan->chan->max_power;
+		sc->cur_chan->txpower = 2 * ah->curchan->chan->max_power;
 		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
+		ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
 		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 		/* synchronize DFS detector if regulatory domain changed */
 		if (sc->dfs_detector != NULL)
@@ -335,7 +335,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
-	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2e7cce7..5a9cee4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -227,7 +227,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	}
 
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
-			       sc->config.txpowlimit, &sc->curtxpow);
+			       sc->cur_chan->txpower, &sc->curtxpow);
 
 	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ath9k_hw_set_interrupts(ah);
@@ -1315,9 +1315,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		ath_dbg(common, CONFIG, "Set power: %d\n", conf->power_level);
-		sc->config.txpowlimit = 2 * conf->power_level;
+		sc->cur_chan->txpower = 2 * conf->power_level;
 		ath9k_cmn_update_txpow(ah, sc->curtxpow,
-				       sc->config.txpowlimit, &sc->curtxpow);
+				       sc->cur_chan->txpower, &sc->curtxpow);
 	}
 
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index a0dbcc4..313ed99 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -720,7 +720,7 @@ void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
 		mci_hw->concur_tx = concur_tx;
 
 	if (old_concur_tx != mci_hw->concur_tx)
-		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
+		ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
 }
 
 static void ath9k_mci_stomp_audio(struct ath_softc *sc)
-- 
2.0.0

