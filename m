Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25227 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaFKKuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:01 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 20/28] ath9k: Adjust AP beacon tsf based on station context
Date: Wed, 11 Jun 2014 16:18:08 +0530
Message-ID: <1402483696-2498-21-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_125026_330784_C93684CD)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

In multi channel context (AP + STA case), adjust the TSF time of
the AP chanctx to keep its beacons at half beacon interval offset
relative to the STA chanctx.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 ++
 drivers/net/wireless/ath/ath9k/channel.c | 48 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c    |  5 ++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 02f3098..a4646a0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -335,6 +335,7 @@ struct ath_chanctx {
 	struct ath9k_hw_cal_data caldata;
 	struct timespec tsf_ts;
 	u64 tsf_val;
+	u32 last_beacon;
 
 	u16 txpower;
 	bool offchannel;
@@ -348,6 +349,7 @@ enum ath_chanctx_event {
 	ATH_CHANCTX_EVENT_BEACON_PREPARE,
 	ATH_CHANCTX_EVENT_BEACON_SENT,
 	ATH_CHANCTX_EVENT_TSF_TIMER,
+	ATH_CHANCTX_EVENT_BEACON_RECEIVED,
 };
 
 enum ath_chanctx_state {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 4793de0..6ea806c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -382,10 +382,51 @@ void ath_chanctx_offchan_switch(struct ath_softc *sc,
 	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
 }
 
+static struct ath_chanctx *
+ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
+{
+	int idx = ctx - &sc->chanctx[0];
+
+	return &sc->chanctx[!idx];
+}
+
+static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
+{
+	struct ath_chanctx *prev, *cur;
+	struct timespec ts;
+	u32 cur_tsf, prev_tsf, beacon_int;
+	s32 offset;
+
+	beacon_int = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+
+	cur = sc->cur_chan;
+	prev = ath_chanctx_get_next(sc, cur);
+
+	getrawmonotonic(&ts);
+	cur_tsf = (u32) cur->tsf_val +
+		  ath9k_hw_get_tsf_offset(&cur->tsf_ts, &ts);
+
+	prev_tsf = prev->last_beacon - (u32) prev->tsf_val + cur_tsf;
+	prev_tsf -= ath9k_hw_get_tsf_offset(&prev->tsf_ts, &ts);
+
+	/* Adjust the TSF time of the AP chanctx to keep its beacons
+	 * at half beacon interval offset relative to the STA chanctx.
+	 */
+	offset = cur_tsf - prev_tsf;
+
+	/* Ignore stale data or spurious timestamps */
+	if (offset < 0 || offset > 3 * beacon_int)
+		return;
+
+	offset = beacon_int / 2 - (offset % beacon_int);
+	prev->tsf_val += offset;
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = NULL;
 	u32 tsf_time;
 	bool noa_changed = false;
@@ -410,6 +451,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		tsf_time = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
 		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
 		sc->sched.switch_start_time = tsf_time;
+		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
 
 		if (sc->sched.offchannel_duration) {
 			noa_changed = true;
@@ -441,6 +483,12 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.state = ATH_CHANCTX_STATE_SWITCH;
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
+	case ATH_CHANCTX_EVENT_BEACON_RECEIVED:
+		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+			break;
+
+		ath_chanctx_adjust_tbtt_delta(sc);
+		break;
 	}
 
 	spin_unlock_bh(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7b9c7e5..74ab1d0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -892,6 +892,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 	}
 
+	if (rx_stats->is_mybeacon) {
+		sc->sched.next_tbtt = rx_stats->rs_tstamp;
+		ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_BEACON_RECEIVED);
+	}
+
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->band = ah->curchan->chan->band;
-- 
2.0.0

