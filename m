Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25136 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaFKKtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:23 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 14/28] ath9k: Move beacon config to channel context
Date: Wed, 11 Jun 2014 16:18:02 +0530
Message-ID: <1402483696-2498-15-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124929_816394_443FE68C)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +-
 drivers/net/wireless/ath/ath9k/beacon.c  | 10 +++++-----
 drivers/net/wireless/ath/ath9k/channel.c |  1 -
 drivers/net/wireless/ath/ath9k/init.c    |  1 +
 drivers/net/wireless/ath/ath9k/link.c    |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c    |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c    |  6 +++---
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4df412b..d632f8f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -328,6 +328,7 @@ struct ath_chanctx {
 	struct list_head vifs;
 	struct list_head acq[IEEE80211_NUM_ACS];
 
+	struct ath_beacon_config beacon;
 	struct ath9k_hw_cal_data caldata;
 	struct timespec tsf_ts;
 	u64 tsf_val;
@@ -828,7 +829,6 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
 #endif
-	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
 	struct timer_list sleep_timer;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index eae8f68..c0ff015 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -249,7 +249,7 @@ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
 static int ath9k_beacon_choose_slot(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 	u16 intval;
 	u32 tsftu;
 	u64 tsf;
@@ -277,7 +277,7 @@ static int ath9k_beacon_choose_slot(struct ath_softc *sc)
 static void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	u32 tsfadjust;
 
@@ -528,7 +528,7 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 				      struct ieee80211_bss_conf *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 
 	ath_dbg(common, BEACON,
 		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
@@ -564,7 +564,7 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			 u32 changed)
 {
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
         struct ath_hw *ah = sc->sc_ah;
         struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
@@ -631,7 +631,7 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 void ath9k_set_beacon(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 
 	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 4a7691e..1566253 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -271,7 +271,6 @@ void ath_chanctx_init(struct ath_softc *sc)
 		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
 			INIT_LIST_HEAD(&ctx->acq[j]);
 	}
-	sc->cur_chan = &sc->chanctx[0];
 	ctx = &sc->offchannel.chan;
 	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 	INIT_LIST_HEAD(&ctx->vifs);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 45f198f..1ff1a75 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -510,6 +510,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
 	sc->tx99_power = MAX_RATE_POWER + 1;
 	init_waitqueue_head(&sc->tx_wait);
+	sc->cur_chan = &sc->chanctx[0];
 
 	if (!pdata || pdata->use_eeprom) {
 		ah->ah_flags |= AH_USE_EEPROM;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index d9c01d5..2343f56 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -440,7 +440,7 @@ void ath_check_ani(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 
 	/*
 	 * Check for the various conditions in which ANI has to
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fec9e0b..7b9c7e5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -545,7 +545,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
-		if (!(WARN_ON_ONCE(sc->cur_beacon_conf.beacon_interval == 0)))
+		if (!(WARN_ON_ONCE(sc->cur_chan->beacon.beacon_interval == 0)))
 			ath9k_set_beacon(sc);
 		if (sc->p2p_ps_vif)
 			ath9k_update_p2p_ps(sc, sc->p2p_ps_vif->vif);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 22460a1..7dd6187 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1694,7 +1694,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 int ath_cabq_update(struct ath_softc *sc)
 {
 	struct ath9k_tx_queue_info qi;
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 	int qnum = sc->beacon.cabq->axq_qnum;
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
@@ -2301,8 +2301,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int max_duration;
 
 	max_duration =
-		sc->cur_beacon_conf.beacon_interval * 1000 *
-		sc->cur_beacon_conf.dtim_period / ATH_BCBUF;
+		sc->cur_chan->beacon.beacon_interval * 1000 *
+		sc->cur_chan->beacon.dtim_period / ATH_BCBUF;
 
 	do {
 		struct ath_frame_info *fi = get_frame_info(skb);
-- 
2.0.0

