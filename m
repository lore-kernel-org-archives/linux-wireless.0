Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34966 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbKLNQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:13 -0500
Received: by lfdo63 with SMTP id o63so33638635lfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:11 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 01/12] ath9k: add debug messages to aggr/chanctx funcs
Date: Thu, 12 Nov 2015 14:15:38 +0100
Message-Id: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141617_183325_B22A9FBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add/extend debug messages when chanctx used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 11 ++++++++---
 drivers/net/wireless/ath/ath9k/hw.c      |  8 ++++----
 drivers/net/wireless/ath/ath9k/xmit.c    | 15 +++++++++++++++
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 90f5773..35802c9 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -403,7 +403,7 @@ static void ath_chanctx_offchannel_noa(struct ath_softc *sc,
 	avp->offchannel_duration = sc->sched.offchannel_duration;
 
 	ath_dbg(common, CHAN_CTX,
-		"offchannel noa_duration: %d, noa_start: %d, noa_index: %d\n",
+		"offchannel noa_duration: %d, noa_start: %u, noa_index: %d\n",
 		avp->offchannel_duration,
 		avp->offchannel_start,
 		avp->noa_index);
@@ -443,7 +443,7 @@ static void ath_chanctx_set_periodic_noa(struct ath_softc *sc,
 		avp->periodic_noa = true;
 
 	ath_dbg(common, CHAN_CTX,
-		"noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
+		"noa_duration: %d, noa_start: %u, noa_index: %d, periodic: %d\n",
 		avp->noa_duration,
 		avp->noa_start,
 		avp->noa_index,
@@ -464,7 +464,7 @@ static void ath_chanctx_set_oneshot_noa(struct ath_softc *sc,
 	avp->noa_duration = duration + sc->sched.channel_switch_time;
 
 	ath_dbg(common, CHAN_CTX,
-		"oneshot noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
+		"oneshot noa_duration: %d, noa_start: %u, noa_index: %d, periodic: %d\n",
 		avp->noa_duration,
 		avp->noa_start,
 		avp->noa_index,
@@ -1401,6 +1401,7 @@ void ath9k_chanctx_wake_queues(struct ath_softc *sc, struct ath_chanctx *ctx)
 
 static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
 	s32 tsf, target_tsf;
 
@@ -1418,6 +1419,10 @@ static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 	if (target_tsf - tsf < ATH_P2P_PS_STOP_TIME)
 		target_tsf = tsf + ATH_P2P_PS_STOP_TIME;
 
+	ath_dbg(common, CHAN_CTX, "%s absent %d tsf 0x%08X next_tsf 0x%08X (%dms)\n",
+		__func__, avp->noa.absent, tsf, target_tsf,
+		(target_tsf - tsf) / 1000);
+
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, (u32) target_tsf, 1000000);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bdfff46..4af19e4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2299,10 +2299,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	else
 		nextTbtt = bs->bs_nexttbtt;
 
-	ath_dbg(common, BEACON, "next DTIM %d\n", bs->bs_nextdtim);
-	ath_dbg(common, BEACON, "next beacon %d\n", nextTbtt);
-	ath_dbg(common, BEACON, "beacon period %d\n", beaconintval);
-	ath_dbg(common, BEACON, "DTIM period %d\n", dtimperiod);
+	ath_dbg(common, BEACON, "next DTIM %u\n", bs->bs_nextdtim);
+	ath_dbg(common, BEACON, "next beacon %u\n", nextTbtt);
+	ath_dbg(common, BEACON, "beacon period %u\n", beaconintval);
+	ath_dbg(common, BEACON, "DTIM period %u\n", dtimperiod);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3e3dac3..26698a6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1473,11 +1473,14 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *txtid;
 	struct ath_txq *txq;
 	struct ath_node *an;
 	u8 density;
 
+	ath_dbg(common, XMIT, "%s called\n", __func__);
+
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
 	txq = txtid->txq;
@@ -1512,10 +1515,13 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = txtid->txq;
 
+	ath_dbg(common, XMIT, "%s called\n", __func__);
+
 	ath_txq_lock(sc, txq);
 	txtid->active = false;
 	ath_tx_flush_tid(sc, txtid);
@@ -1526,11 +1532,14 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 		       struct ath_node *an)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	bool buffered;
 	int tidno;
 
+	ath_dbg(common, XMIT, "%s called\n", __func__);
+
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
@@ -1555,10 +1564,13 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 	int tidno;
 
+	ath_dbg(common, XMIT, "%s called\n", __func__);
+
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
@@ -1579,10 +1591,13 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 			u16 tidno)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
 	struct ath_node *an;
 	struct ath_txq *txq;
 
+	ath_dbg(common, XMIT, "%s called\n", __func__);
+
 	an = (struct ath_node *)sta->drv_priv;
 	tid = ATH_AN_2_TID(an, tidno);
 	txq = tid->txq;
-- 
1.9.1

