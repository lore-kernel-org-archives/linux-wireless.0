Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:54153 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754976AbeFRPNs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 11:13:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        Russell Hu <rhu@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ath9k: use timespec64 for tsf_ts
Date: Mon, 18 Jun 2018 17:11:17 +0200
Message-Id: <20180618151142.1214422-4-arnd@arndb.de> (sfid-20180618_171441_035851_006E3D57)
In-Reply-To: <20180618151142.1214422-1-arnd@arndb.de>
References: <20180618151142.1214422-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k is the last remaining user of the deprecated getrawmonotonic()
interface. There is nothing wrong with this usage, but migrating
to a timespec64 based interface lets us clean up the old API.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++--
 drivers/net/wireless/ath/ath9k/channel.c | 14 +++++++-------
 drivers/net/wireless/ath/ath9k/hw.c      | 10 +++++-----
 drivers/net/wireless/ath/ath9k/hw.h      |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    |  4 ++--
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ef0de4f1312c..21ba20981a80 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -342,7 +342,7 @@ struct ath_chanctx {
 
 	struct ath_beacon_config beacon;
 	struct ath9k_hw_cal_data caldata;
-	struct timespec tsf_ts;
+	struct timespec64 tsf_ts;
 	u64 tsf_val;
 	u32 last_beacon;
 
@@ -1021,7 +1021,7 @@ struct ath_softc {
 	struct ath_offchannel offchannel;
 	struct ath_chanctx *next_chan;
 	struct completion go_beacon;
-	struct timespec last_event_time;
+	struct timespec64 last_event_time;
 #endif
 
 	unsigned long driver_data;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1b05b5d7a038..fd61ae4782b6 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -233,9 +233,9 @@ static const char *chanctx_state_string(enum ath_chanctx_state state)
 static u32 chanctx_event_delta(struct ath_softc *sc)
 {
 	u64 ms;
-	struct timespec ts, *old;
+	struct timespec64 ts, *old;
 
-	getrawmonotonic(&ts);
+	ktime_get_raw_ts64(&ts);
 	old = &sc->last_event_time;
 	ms = ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
 	ms -= old->tv_sec * 1000 + old->tv_nsec / 1000000;
@@ -334,7 +334,7 @@ ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 {
 	struct ath_chanctx *prev, *cur;
-	struct timespec ts;
+	struct timespec64 ts;
 	u32 cur_tsf, prev_tsf, beacon_int;
 	s32 offset;
 
@@ -346,7 +346,7 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 	if (!prev->switch_after_beacon)
 		return;
 
-	getrawmonotonic(&ts);
+	ktime_get_raw_ts64(&ts);
 	cur_tsf = (u32) cur->tsf_val +
 		  ath9k_hw_get_tsf_offset(&cur->tsf_ts, &ts);
 
@@ -1230,7 +1230,7 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_chanctx *old_ctx;
-	struct timespec ts;
+	struct timespec64 ts;
 	bool measure_time = false;
 	bool send_ps = false;
 	bool queues_stopped = false;
@@ -1260,7 +1260,7 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		spin_unlock_bh(&sc->chan_lock);
 
 		if (sc->next_chan == &sc->offchannel.chan) {
-			getrawmonotonic(&ts);
+			ktime_get_raw_ts64(&ts);
 			measure_time = true;
 		}
 
@@ -1277,7 +1277,7 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		spin_lock_bh(&sc->chan_lock);
 
 		if (sc->cur_chan != &sc->offchannel.chan) {
-			getrawmonotonic(&sc->cur_chan->tsf_ts);
+			ktime_get_raw_ts64(&sc->cur_chan->tsf_ts);
 			sc->cur_chan->tsf_val = ath9k_hw_gettsf64(sc->sc_ah);
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e60bea4604e4..e8e1f785bc5c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1835,13 +1835,13 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	return -EINVAL;
 }
 
-u32 ath9k_hw_get_tsf_offset(struct timespec *last, struct timespec *cur)
+u32 ath9k_hw_get_tsf_offset(struct timespec64 *last, struct timespec64 *cur)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	s64 usec;
 
 	if (!cur) {
-		getrawmonotonic(&ts);
+		ktime_get_raw_ts64(&ts);
 		cur = &ts;
 	}
 
@@ -1859,7 +1859,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveLedState;
 	u32 saveDefAntenna;
 	u32 macStaId1;
-	struct timespec tsf_ts;
+	struct timespec64 tsf_ts;
 	u32 tsf_offset;
 	u64 tsf = 0;
 	int r;
@@ -1905,7 +1905,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
 	/* Save TSF before chip reset, a cold reset clears it */
-	getrawmonotonic(&tsf_ts);
+	ktime_get_raw_ts64(&tsf_ts);
 	tsf = ath9k_hw_gettsf64(ah);
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9804a24a2dc0..68956cdc8c9a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1060,7 +1060,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
-u32 ath9k_hw_get_tsf_offset(struct timespec *last, struct timespec *cur);
+u32 ath9k_hw_get_tsf_offset(struct timespec64 *last, struct timespec64 *cur);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b6663c80e7dd..acb681b096d9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1865,7 +1865,7 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 	tsf -= le64_to_cpu(avp->tsf_adjust);
-	getrawmonotonic(&avp->chanctx->tsf_ts);
+	ktime_get_raw_ts64(&avp->chanctx->tsf_ts);
 	if (sc->cur_chan == avp->chanctx)
 		ath9k_hw_settsf64(sc->sc_ah, tsf);
 	avp->chanctx->tsf_val = tsf;
@@ -1881,7 +1881,7 @@ static void ath9k_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mutex_lock(&sc->mutex);
 
 	ath9k_ps_wakeup(sc);
-	getrawmonotonic(&avp->chanctx->tsf_ts);
+	ktime_get_raw_ts64(&avp->chanctx->tsf_ts);
 	if (sc->cur_chan == avp->chanctx)
 		ath9k_hw_reset_tsf(sc->sc_ah);
 	avp->chanctx->tsf_val = 0;
-- 
2.9.0
