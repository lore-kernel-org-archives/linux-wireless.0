Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52068 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbaKTNbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 08:31:47 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so3707052wgh.17
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 05:31:45 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 3/3] ath9k: add TPC capability to TX descriptor path
Date: Thu, 20 Nov 2014 14:31:40 +0100
Message-Id: <1416490300-6451-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141120_143154_831287_D7E18F63)
In-Reply-To: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add TPC capability to TX descriptor path. Cap per-packet TX power according to
TX power per-rate per-chain tables. Currently TPC is supported just by AR9003
based chips

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |  8 +++---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  8 +++---
 drivers/net/wireless/ath/ath9k/ath9k.h      |  1 +
 drivers/net/wireless/ath/ath9k/beacon.c     |  5 ++--
 drivers/net/wireless/ath/ath9k/mac.h        |  2 +-
 drivers/net/wireless/ath/ath9k/xmit.c       | 41 ++++++++++++++++++++++++++++-
 6 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 2a93519..f816909 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -281,7 +281,7 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 
 	ACCESS_ONCE(ads->ds_ctl0) = (i->pkt_len & AR_FrameLen)
 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
-		| SM(i->txpower, AR_XmitPower0)
+		| SM(i->txpower[0], AR_XmitPower0)
 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
 		| (i->flags & ATH9K_TXDESC_INTREQ ? AR_TxIntrReq : 0)
 		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
@@ -307,9 +307,9 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 		| set11nRateFlags(i->rates, 3)
 		| SM(i->rtscts_rate, AR_RTSCTSRate);
 
-	ACCESS_ONCE(ads->ds_ctl9) = SM(i->txpower, AR_XmitPower1);
-	ACCESS_ONCE(ads->ds_ctl10) = SM(i->txpower, AR_XmitPower2);
-	ACCESS_ONCE(ads->ds_ctl11) = SM(i->txpower, AR_XmitPower3);
+	ACCESS_ONCE(ads->ds_ctl9) = SM(i->txpower[1], AR_XmitPower1);
+	ACCESS_ONCE(ads->ds_ctl10) = SM(i->txpower[2], AR_XmitPower2);
+	ACCESS_ONCE(ads->ds_ctl11) = SM(i->txpower[3], AR_XmitPower3);
 }
 
 static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 057b165..da84b70 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -101,7 +101,7 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 
 	ACCESS_ONCE(ads->ctl11) = (i->pkt_len & AR_FrameLen)
 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
-		| SM(i->txpower, AR_XmitPower0)
+		| SM(i->txpower[0], AR_XmitPower0)
 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
 		| (i->keyix != ATH9K_TXKEYIX_INVALID ? AR_DestIdxValid : 0)
 		| (i->flags & ATH9K_TXDESC_LOWRXCHAIN ? AR_LowRxChain : 0)
@@ -152,9 +152,9 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 
 	ACCESS_ONCE(ads->ctl19) = AR_Not_Sounding;
 
-	ACCESS_ONCE(ads->ctl20) = SM(i->txpower, AR_XmitPower1);
-	ACCESS_ONCE(ads->ctl21) = SM(i->txpower, AR_XmitPower2);
-	ACCESS_ONCE(ads->ctl22) = SM(i->txpower, AR_XmitPower3);
+	ACCESS_ONCE(ads->ctl20) = SM(i->txpower[1], AR_XmitPower1);
+	ACCESS_ONCE(ads->ctl21) = SM(i->txpower[2], AR_XmitPower2);
+	ACCESS_ONCE(ads->ctl22) = SM(i->txpower[3], AR_XmitPower3);
 }
 
 static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index abe8bd6..1a9fe09 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -189,6 +189,7 @@ struct ath_frame_info {
 	u8 rtscts_rate;
 	u8 retries : 7;
 	u8 baw_tracked : 1;
+	u8 tx_power;
 };
 
 struct ath_rxbuf {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index ecb783b..cb366ad 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -78,7 +78,7 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_tx_info info;
 	struct ieee80211_supported_band *sband;
 	u8 chainmask = ah->txchainmask;
-	u8 rate = 0;
+	u8 i, rate = 0;
 
 	sband = &common->sbands[sc->cur_chandef.chan->band];
 	rate = sband->bitrates[rateidx].hw_value;
@@ -88,7 +88,8 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	memset(&info, 0, sizeof(info));
 	info.pkt_len = skb->len + FCS_LEN;
 	info.type = ATH9K_PKT_TYPE_BEACON;
-	info.txpower = MAX_RATE_POWER;
+	for (i = 0; i < 4; i++)
+		info.txpower[i] = MAX_RATE_POWER;
 	info.keyix = ATH9K_TXKEYIX_INVALID;
 	info.keytype = ATH9K_KEY_TYPE_CLEAR;
 	info.flags = ATH9K_TXDESC_NOACK | ATH9K_TXDESC_CLRDMASK;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index aa69cea..e55fa11 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -704,7 +704,7 @@ struct ath_tx_info {
 	enum ath9k_pkt_type type;
 	enum ath9k_key_type keytype;
 	u8 keyix;
-	u8 txpower;
+	u8 txpower[4];
 };
 
 struct ath_hw;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d6e54a3..f0e18d9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1096,6 +1096,39 @@ void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop)
 	}
 }
 
+static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
+			       u8 rateidx, u8 chainmask)
+{
+	u8 max_power;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (sc->tx99_state)
+		return MAX_RATE_POWER;
+
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+		/* ar9002 is not sipported for the moment */
+		return MAX_RATE_POWER;
+	}
+
+	if (!bf->bf_state.bfs_paprd) {
+		struct sk_buff *skb = bf->bf_mpdu;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ath_frame_info *fi = get_frame_info(skb);
+		u8 nchain = ar5416_get_ntxchains(chainmask);
+
+		if (rateidx < 8 && (info->flags & IEEE80211_TX_CTL_STBC))
+			max_power = min(ah->tx_power_stbc[rateidx][nchain - 1],
+					fi->tx_power);
+		else
+			max_power = min(ah->tx_power[rateidx][nchain - 1],
+					fi->tx_power);
+	} else {
+		max_power = ah->paprd_training_power;
+	}
+
+	return max_power;
+}
+
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_info *info, int len, bool rts)
 {
@@ -1166,6 +1199,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
 				info->rates[i].RateFlags |= ATH9K_RATESERIES_STBC;
+
+			info->txpower[i] = ath_get_rate_txpower(sc, bf, rix,
+							info->rates[i].ChSel);
 			continue;
 		}
 
@@ -1193,6 +1229,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 		info->rates[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
 			phy, rate->bitrate * 100, len, rix, is_sp);
+
+		info->txpower[i] = ath_get_rate_txpower(sc, bf, rix,
+							info->rates[i].ChSel);
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
@@ -1239,7 +1278,6 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 	memset(&info, 0, sizeof(info));
 	info.is_first = true;
 	info.is_last = true;
-	info.txpower = MAX_RATE_POWER;
 	info.qcu = txq->axq_qnum;
 
 	while (bf) {
@@ -2063,6 +2101,7 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
+	fi->tx_power = MAX_RATE_POWER;
 
 	if (!rate)
 		return;
-- 
2.1.0

