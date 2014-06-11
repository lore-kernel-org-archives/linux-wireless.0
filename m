Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25195 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaFKKtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:49 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 18/28] ath9k: Add p2p go NoA attribute
Date: Wed, 11 Jun 2014 16:18:06 +0530
Message-ID: <1402483696-2498-19-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124952_713859_0967369A)
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
 drivers/net/wireless/ath/ath9k/ath9k.h   |  7 ++++++
 drivers/net/wireless/ath/ath9k/beacon.c  | 37 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/channel.c | 39 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/init.c    |  2 ++
 4 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6487c47..02f3098 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -362,6 +362,8 @@ struct ath_chanctx_sched {
 	enum ath_chanctx_state state;
 
 	u32 next_tbtt;
+	u32 switch_start_time;
+	unsigned int offchannel_duration;
 	unsigned int channel_switch_time;
 };
 
@@ -472,6 +474,11 @@ struct ath_vif {
 
 	/* P2P Client */
 	struct ieee80211_noa_data noa;
+
+	/* P2P GO */
+	u8 noa_index;
+	u32 offchannel_start;
+	u32 offchannel_duration;
 };
 
 struct ath9k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 5b1689c..85a40d7 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -108,6 +108,40 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 }
 
+static void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
+				 struct sk_buff *skb)
+{
+	static const u8 noa_ie_hdr[] = {
+		WLAN_EID_VENDOR_SPECIFIC,	/* type */
+		0,				/* length */
+		0x50, 0x6f, 0x9a,		/* WFA OUI */
+		0x09,				/* P2P subtype */
+		0x0c,				/* Notice of Absence */
+		0x00,				/* LSB of little-endian len */
+		0x00,				/* MSB of little-endian len */
+	};
+
+	struct ieee80211_p2p_noa_attr *noa;
+	int noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc);
+	u8 *hdr;
+
+	if (!avp->offchannel_duration)
+		return;
+
+	hdr = skb_put(skb, sizeof(noa_ie_hdr));
+	memcpy(hdr, noa_ie_hdr, sizeof(noa_ie_hdr));
+	hdr[1] = sizeof(noa_ie_hdr) + noa_len - 2;
+	hdr[7] = noa_len;
+
+	noa = (void *) skb_put(skb, noa_len);
+	memset(noa, 0, noa_len);
+
+	noa->index = avp->noa_index;
+	noa->desc[0].count = 1;
+	noa->desc[0].duration = cpu_to_le32(avp->offchannel_duration);
+	noa->desc[0].start_time = cpu_to_le32(avp->offchannel_start);
+}
+
 static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 					     struct ieee80211_vif *vif)
 {
@@ -155,6 +189,9 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
+	if (vif->p2p)
+		ath9k_beacon_add_noa(sc, avp, skb);
+
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 					 skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 503b776..364a555 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -270,6 +270,8 @@ void ath_chanctx_work(struct work_struct *work)
 	sc->cur_chan->stopped = false;
 	sc->next_chan = NULL;
 	sc->sched.state = ATH_CHANCTX_STATE_IDLE;
+	sc->sched.offchannel_duration = 0;
+
 	spin_unlock_bh(&sc->chan_lock);
 
 	if (sc->sc_ah->chip_fullsleep ||
@@ -326,6 +328,12 @@ void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 	sc->next_chan = ctx;
 	if (chandef)
 		ctx->chandef = *chandef;
+
+	if (sc->next_chan == &sc->offchannel.chan) {
+		sc->sched.offchannel_duration =
+			TU_TO_USEC(sc->offchannel.duration) +
+			sc->sched.channel_switch_time;
+	}
 	spin_unlock_bh(&sc->chan_lock);
 	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 }
@@ -377,17 +385,40 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_vif *avp = NULL;
 	u32 tsf_time;
+	bool noa_changed = false;
+
+	if (vif)
+		avp = (struct ath_vif *) vif->drv_priv;
 
 	spin_lock_bh(&sc->chan_lock);
 
 	switch (ev) {
 	case ATH_CHANCTX_EVENT_BEACON_PREPARE:
+		if (avp->offchannel_duration)
+			avp->offchannel_duration = 0;
+
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
 		sc->sched.beacon_pending = true;
 		sc->sched.next_tbtt = REG_READ(ah, AR_NEXT_TBTT_TIMER);
+
+		/* defer channel switch by a quarter beacon interval */
+		tsf_time = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
+		sc->sched.switch_start_time = tsf_time;
+
+		if (sc->sched.offchannel_duration) {
+			noa_changed = true;
+			avp->offchannel_start = tsf_time;
+			avp->offchannel_duration =
+				sc->sched.offchannel_duration;
+		}
+
+		if (noa_changed)
+			avp->noa_index++;
 		break;
 	case ATH_CHANCTX_EVENT_BEACON_SENT:
 		if (!sc->sched.beacon_pending)
@@ -397,12 +428,10 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
-		/* defer channel switch by a quarter beacon interval */
-		tsf_time = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
-		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
-		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time,
-				1000000);
+		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
+					 sc->sched.switch_start_time,
+					 1000000);
 		break;
 	case ATH_CHANCTX_EVENT_TSF_TIMER:
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1ff1a75..66a9dc3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -754,6 +754,8 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 			hw->wiphy->max_remain_on_channel_duration = 10000;
 			hw->chanctx_data_size = sizeof(void *);
+			hw->extra_beacon_tailroom =
+				sizeof(struct ieee80211_p2p_noa_attr) + 9;
 		}
 	}
 
-- 
2.0.0

