Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53268 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFKKuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:19 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 23/28] ath9k: Add periodic NoA support
Date: Wed, 11 Jun 2014 16:18:11 +0530
Message-ID: <1402483696-2498-24-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130501_692223_868EDA3C)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +++
 drivers/net/wireless/ath/ath9k/beacon.c  | 25 ++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/channel.c | 24 +++++++++++++++++++++---
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0bc63bd..a5afd4a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -489,6 +489,9 @@ struct ath_vif {
 	u8 noa_index;
 	u32 offchannel_start;
 	u32 offchannel_duration;
+
+	u32 periodic_noa_start;
+	u32 periodic_noa_duration;
 };
 
 struct ath9k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 85a40d7..eaf8f05 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -122,12 +122,15 @@ static void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 	};
 
 	struct ieee80211_p2p_noa_attr *noa;
-	int noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc);
+	int noa_len, noa_desc, i = 0;
 	u8 *hdr;
 
-	if (!avp->offchannel_duration)
+	if (!avp->offchannel_duration && !avp->periodic_noa_duration)
 		return;
 
+	noa_desc = !!avp->offchannel_duration + !!avp->periodic_noa_duration;
+	noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc) * noa_desc;
+
 	hdr = skb_put(skb, sizeof(noa_ie_hdr));
 	memcpy(hdr, noa_ie_hdr, sizeof(noa_ie_hdr));
 	hdr[1] = sizeof(noa_ie_hdr) + noa_len - 2;
@@ -137,9 +140,21 @@ static void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 	memset(noa, 0, noa_len);
 
 	noa->index = avp->noa_index;
-	noa->desc[0].count = 1;
-	noa->desc[0].duration = cpu_to_le32(avp->offchannel_duration);
-	noa->desc[0].start_time = cpu_to_le32(avp->offchannel_start);
+	if (avp->periodic_noa_duration) {
+		u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+
+		noa->desc[i].count = 255;
+		noa->desc[i].start_time = cpu_to_le32(avp->periodic_noa_start);
+		noa->desc[i].duration = cpu_to_le32(avp->periodic_noa_duration);
+		noa->desc[i].interval = cpu_to_le32(interval);
+		i++;
+	}
+
+	if (avp->offchannel_duration) {
+		noa->desc[i].count = 1;
+		noa->desc[i].start_time = cpu_to_le32(avp->offchannel_start);
+		noa->desc[i].duration = cpu_to_le32(avp->offchannel_duration);
+	}
 }
 
 static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1cb2909..3d9776c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -474,6 +474,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_beacon_config *cur_conf;
 	struct ath_vif *avp = NULL;
 	struct ath_chanctx *ctx;
 	u32 tsf_time;
@@ -514,12 +515,29 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.beacon_pending = true;
 		sc->sched.next_tbtt = REG_READ(ah, AR_NEXT_TBTT_TIMER);
 
+		cur_conf = &sc->cur_chan->beacon;
 		/* defer channel switch by a quarter beacon interval */
-		tsf_time = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+		tsf_time = TU_TO_USEC(cur_conf->beacon_interval);
 		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
 		sc->sched.switch_start_time = tsf_time;
 		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
 
+		/* Prevent wrap-around issues */
+		if (avp->periodic_noa_duration &&
+		    tsf_time - avp->periodic_noa_start > BIT(30))
+			avp->periodic_noa_duration = 0;
+
+		if (ctx->active && !avp->periodic_noa_duration) {
+			avp->periodic_noa_start = tsf_time;
+			avp->periodic_noa_duration =
+				TU_TO_USEC(cur_conf->beacon_interval) / 2 -
+				sc->sched.channel_switch_time;
+			noa_changed = true;
+		} else if (!ctx->active && avp->periodic_noa_duration) {
+			avp->periodic_noa_duration = 0;
+			noa_changed = true;
+		}
+
 		if (sc->sched.offchannel_duration) {
 			noa_changed = true;
 			avp->offchannel_start = tsf_time;
@@ -575,11 +593,11 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		 * beacon period (minus channel switch time)
 		 */
 		sc->next_chan = ath_chanctx_get_next(sc, sc->cur_chan);
+		cur_conf = &sc->cur_chan->beacon;
 
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
 		tsf_time = ath9k_hw_gettsf32(sc->sc_ah);
-		tsf_time +=
-			TU_TO_USEC(sc->cur_chan->beacon.beacon_interval) / 2;
+		tsf_time += TU_TO_USEC(cur_conf->beacon_interval) / 2;
 		tsf_time -= sc->sched.channel_switch_time;
 		sc->sched.switch_start_time = tsf_time;
 
-- 
2.0.0

