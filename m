Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49296 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967662AbdD1Igj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: clean up rate encoding bits in RX status
Date: Fri, 28 Apr 2017 10:36:23 +0200
Message-Id: <20170428083626.3463-2-johannes@sipsolutions.net> (sfid-20170428_103736_871229_15453780)
In-Reply-To: <20170428083626.3463-1-johannes@sipsolutions.net>
References: <20170428083626.3463-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In preparation for adding support for HE rates, clean up
the driver report encoding for rate/bandwidth reporting
on RX frames.

Much of this patch was done with the following spatch:

@@
expression status;
@@
-status->flag & (RX_FLAG_HT | RX_FLAG_VHT)
+status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_SHORTPRE
+status->enc_flags op RX_ENC_FLAG_SHORTPRE
@@
expression status;
@@
-status->flag & RX_FLAG_SHORTPRE
+status->enc_flags & RX_ENC_FLAG_SHORTPRE

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_HT
+status->enc_flags op RX_ENC_FLAG_HT
@@
expression status;
@@
-status->flag & RX_FLAG_HT
+status->enc_flags & RX_ENC_FLAG_HT

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_40MHZ
+status->enc_flags op RX_ENC_FLAG_40MHZ
@@
expression status;
@@
-status->flag & RX_FLAG_40MHZ
+status->enc_flags & RX_ENC_FLAG_40MHZ

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_SHORT_GI
+status->enc_flags op RX_ENC_FLAG_SHORT_GI
@@
expression status;
@@
-status->flag & RX_FLAG_SHORT_GI
+status->enc_flags & RX_ENC_FLAG_SHORT_GI

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_HT_GF
+status->enc_flags op RX_ENC_FLAG_HT_GF
@@
expression status;
@@
-status->flag & RX_FLAG_HT_GF
+status->enc_flags & RX_ENC_FLAG_HT_GF

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_VHT
+status->enc_flags op RX_ENC_FLAG_VHT
@@
expression status;
@@
-status->flag & RX_FLAG_VHT
+status->enc_flags & RX_ENC_FLAG_VHT

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_STBC_MASK
+status->enc_flags op RX_ENC_FLAG_STBC_MASK
@@
expression status;
@@
-status->flag & RX_FLAG_STBC_MASK
+status->enc_flags & RX_ENC_FLAG_STBC_MASK

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_LDPC
+status->enc_flags op RX_ENC_FLAG_LDPC
@@
expression status;
@@
-status->flag & RX_FLAG_LDPC
+status->enc_flags & RX_ENC_FLAG_LDPC

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_10MHZ
+status->enc_flags op RX_ENC_FLAG_10MHZ
@@
expression status;
@@
-status->flag & RX_FLAG_10MHZ
+status->enc_flags & RX_ENC_FLAG_10MHZ

@@
assignment operator op;
expression status;
@@
-status->flag op RX_FLAG_5MHZ
+status->enc_flags op RX_ENC_FLAG_5MHZ
@@
expression status;
@@
-status->flag & RX_FLAG_5MHZ
+status->enc_flags & RX_ENC_FLAG_5MHZ

@@
assignment operator op;
expression status;
@@
-status->vht_flag op RX_VHT_FLAG_80MHZ
+status->enc_flags op RX_ENC_FLAG_80MHZ
@@
expression status;
@@
-status->vht_flag & RX_VHT_FLAG_80MHZ
+status->enc_flags & RX_ENC_FLAG_80MHZ

@@
assignment operator op;
expression status;
@@
-status->vht_flag op RX_VHT_FLAG_160MHZ
+status->enc_flags op RX_ENC_FLAG_160MHZ
@@
expression status;
@@
-status->vht_flag & RX_VHT_FLAG_160MHZ
+status->enc_flags & RX_ENC_FLAG_160MHZ

@@
assignment operator op;
expression status;
@@
-status->vht_flag op RX_VHT_FLAG_BF
+status->enc_flags op RX_ENC_FLAG_BF
@@
expression status;
@@
-status->vht_flag & RX_VHT_FLAG_BF
+status->enc_flags & RX_ENC_FLAG_BF

@@
assignment operator op;
expression status, STBC;
@@
-status->flag op STBC << RX_FLAG_STBC_SHIFT
+status->enc_flags op STBC << RX_ENC_FLAG_STBC_SHIFT

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_SHORTPRE
+status.enc_flags op RX_ENC_FLAG_SHORTPRE
@@
expression status;
@@
-status.flag & RX_FLAG_SHORTPRE
+status.enc_flags & RX_ENC_FLAG_SHORTPRE

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_HT
+status.enc_flags op RX_ENC_FLAG_HT
@@
expression status;
@@
-status.flag & RX_FLAG_HT
+status.enc_flags & RX_ENC_FLAG_HT

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_40MHZ
+status.enc_flags op RX_ENC_FLAG_40MHZ
@@
expression status;
@@
-status.flag & RX_FLAG_40MHZ
+status.enc_flags & RX_ENC_FLAG_40MHZ

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_SHORT_GI
+status.enc_flags op RX_ENC_FLAG_SHORT_GI
@@
expression status;
@@
-status.flag & RX_FLAG_SHORT_GI
+status.enc_flags & RX_ENC_FLAG_SHORT_GI

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_HT_GF
+status.enc_flags op RX_ENC_FLAG_HT_GF
@@
expression status;
@@
-status.flag & RX_FLAG_HT_GF
+status.enc_flags & RX_ENC_FLAG_HT_GF

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_VHT
+status.enc_flags op RX_ENC_FLAG_VHT
@@
expression status;
@@
-status.flag & RX_FLAG_VHT
+status.enc_flags & RX_ENC_FLAG_VHT

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_STBC_MASK
+status.enc_flags op RX_ENC_FLAG_STBC_MASK
@@
expression status;
@@
-status.flag & RX_FLAG_STBC_MASK
+status.enc_flags & RX_ENC_FLAG_STBC_MASK

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_LDPC
+status.enc_flags op RX_ENC_FLAG_LDPC
@@
expression status;
@@
-status.flag & RX_FLAG_LDPC
+status.enc_flags & RX_ENC_FLAG_LDPC

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_10MHZ
+status.enc_flags op RX_ENC_FLAG_10MHZ
@@
expression status;
@@
-status.flag & RX_FLAG_10MHZ
+status.enc_flags & RX_ENC_FLAG_10MHZ

@@
assignment operator op;
expression status;
@@
-status.flag op RX_FLAG_5MHZ
+status.enc_flags op RX_ENC_FLAG_5MHZ
@@
expression status;
@@
-status.flag & RX_FLAG_5MHZ
+status.enc_flags & RX_ENC_FLAG_5MHZ

@@
assignment operator op;
expression status;
@@
-status.vht_flag op RX_VHT_FLAG_80MHZ
+status.enc_flags op RX_ENC_FLAG_80MHZ
@@
expression status;
@@
-status.vht_flag & RX_VHT_FLAG_80MHZ
+status.enc_flags & RX_ENC_FLAG_80MHZ

@@
assignment operator op;
expression status;
@@
-status.vht_flag op RX_VHT_FLAG_160MHZ
+status.enc_flags op RX_ENC_FLAG_160MHZ
@@
expression status;
@@
-status.vht_flag & RX_VHT_FLAG_160MHZ
+status.enc_flags & RX_ENC_FLAG_160MHZ

@@
assignment operator op;
expression status;
@@
-status.vht_flag op RX_VHT_FLAG_BF
+status.enc_flags op RX_ENC_FLAG_BF
@@
expression status;
@@
-status.vht_flag & RX_VHT_FLAG_BF
+status.enc_flags & RX_ENC_FLAG_BF

@@
assignment operator op;
expression status, STBC;
@@
-status.flag op STBC << RX_FLAG_STBC_SHIFT
+status.enc_flags op STBC << RX_ENC_FLAG_STBC_SHIFT

@@
@@
-RX_FLAG_STBC_SHIFT
+RX_ENC_FLAG_STBC_SHIFT

type=cleanup

Change-Id: I8dc4849bc790d400ba7843219bb9cc6481c9b195
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  46 ++++-----
 drivers/net/wireless/ath/ath5k/base.c              |   6 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   6 +-
 drivers/net/wireless/ath/ath9k/common.c            |   9 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c         |   6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   6 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  14 +--
 drivers/net/wireless/ath/ath9k/mac.h               |   2 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   8 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   8 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   2 +-
 drivers/net/wireless/broadcom/b43/xmit.c           |   2 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |  10 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  24 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  24 ++---
 drivers/net/wireless/intersil/p54/txrx.c           |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   8 +-
 drivers/net/wireless/marvell/mwl8k.c               |  16 +--
 drivers/net/wireless/mediatek/mt7601u/mac.c        |  12 +--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |   3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h   |   1 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  10 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/net/wireless/ti/wl1251/rx.c                |   2 +-
 drivers/net/wireless/ti/wlcore/rx.c                |   2 +-
 include/net/mac80211.h                             | 108 ++++++++++-----------
 net/mac80211/ibss.c                                |   4 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/rx.c                                  |  58 +++++------
 net/mac80211/scan.c                                |   8 +-
 net/mac80211/sta_info.h                            |  16 +--
 net/mac80211/util.c                                |  22 ++---
 47 files changed, 261 insertions(+), 262 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3448a3ce5919..2c29f8d12bcf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -632,11 +632,11 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		sgi = (info3 >> 7) & 1;
 
 		status->rate_idx = mcs;
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 		if (sgi)
-			status->flag |= RX_FLAG_SHORT_GI;
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 		if (bw)
-			status->flag |= RX_FLAG_40MHZ;
+			status->enc_flags |= RX_ENC_FLAG_40MHZ;
 		break;
 	case HTT_RX_VHT:
 	case HTT_RX_VHT_WITH_TXBF:
@@ -692,7 +692,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		status->vht_nss = nss;
 
 		if (sgi)
-			status->flag |= RX_FLAG_SHORT_GI;
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 		switch (bw) {
 		/* 20MHZ */
@@ -700,18 +700,18 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 			break;
 		/* 40MHZ */
 		case 1:
-			status->flag |= RX_FLAG_40MHZ;
+			status->enc_flags |= RX_ENC_FLAG_40MHZ;
 			break;
 		/* 80MHZ */
 		case 2:
-			status->vht_flag |= RX_VHT_FLAG_80MHZ;
+			status->enc_flags |= RX_ENC_FLAG_80MHZ;
 			break;
 		case 3:
-			status->vht_flag |= RX_VHT_FLAG_160MHZ;
+			status->enc_flags |= RX_ENC_FLAG_160MHZ;
 			break;
 		}
 
-		status->flag |= RX_FLAG_VHT;
+		status->enc_flags |= RX_ENC_FLAG_VHT;
 		break;
 	default:
 		break;
@@ -875,12 +875,12 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->freq = 0;
 		status->rate_idx = 0;
 		status->vht_nss = 0;
-		status->vht_flag &= ~RX_VHT_FLAG_80MHZ;
-		status->flag &= ~(RX_FLAG_HT |
-				  RX_FLAG_VHT |
-				  RX_FLAG_SHORT_GI |
-				  RX_FLAG_40MHZ |
-				  RX_FLAG_MACTIME_END);
+		status->enc_flags &= ~(RX_ENC_FLAG_HT |
+				       RX_ENC_FLAG_VHT |
+				       RX_ENC_FLAG_SHORT_GI |
+				       RX_ENC_FLAG_40MHZ |
+				       RX_ENC_FLAG_80MHZ);
+		status->flag &= ~RX_FLAG_MACTIME_END;
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 		ath10k_htt_rx_h_signal(ar, status, rxd);
@@ -933,7 +933,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	*status = *rx_status;
 
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
-		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
 		   ieee80211_get_SA(hdr),
@@ -941,14 +941,14 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
 							"mcast" : "ucast",
 		   (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4,
-		   (status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) == 0 ?
-							"legacy" : "",
-		   status->flag & RX_FLAG_HT ? "ht" : "",
-		   status->flag & RX_FLAG_VHT ? "vht" : "",
-		   status->flag & RX_FLAG_40MHZ ? "40" : "",
-		   status->vht_flag & RX_VHT_FLAG_80MHZ ? "80" : "",
-		   status->vht_flag & RX_VHT_FLAG_160MHZ ? "160" : "",
-		   status->flag & RX_FLAG_SHORT_GI ? "sgi " : "",
+		   (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)) == 0 ?
+		   "legacy" : "",
+		   status->enc_flags & RX_ENC_FLAG_HT ? "ht" : "",
+		   status->enc_flags & RX_ENC_FLAG_VHT ? "vht" : "",
+		   status->enc_flags & RX_ENC_FLAG_40MHZ ? "40" : "",
+		   status->enc_flags & RX_ENC_FLAG_80MHZ ? "80" : "",
+		   status->enc_flags & RX_ENC_FLAG_160MHZ ? "160" : "",
+		   status->enc_flags & RX_ENC_FLAG_SHORT_GI ? "sgi " : "",
 		   status->rate_idx,
 		   status->vht_nss,
 		   status->freq,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 92ece64fd455..da43469f6b49 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1414,10 +1414,10 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	rxs->flag |= ath5k_rx_decrypted(ah, skb, rs);
 	switch (ah->ah_bwmode) {
 	case AR5K_BWMODE_5MHZ:
-		rxs->flag |= RX_FLAG_5MHZ;
+		rxs->enc_flags |= RX_ENC_FLAG_5MHZ;
 		break;
 	case AR5K_BWMODE_10MHZ:
-		rxs->flag |= RX_FLAG_10MHZ;
+		rxs->enc_flags |= RX_ENC_FLAG_10MHZ;
 		break;
 	default:
 		break;
@@ -1425,7 +1425,7 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 
 	if (rs->rs_rate ==
 	    ah->sbands[ah->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
-		rxs->flag |= RX_FLAG_SHORTPRE;
+		rxs->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	trace_ath5k_rx(ah, skb);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index cc5bb0a76baf..909854de42a1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -494,7 +494,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
-	rxs->flag =  0;
+	rxs->enc_flags = 0;
 
 	rxs->rs_datalen = rxsp->status2 & AR_DataLen;
 	rxs->rs_tstamp =  rxsp->status3;
@@ -520,8 +520,8 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_isaggr = (rxsp->status11 & AR_RxAggr) ? 1 : 0;
 	rxs->rs_moreaggr = (rxsp->status11 & AR_RxMoreAggr) ? 1 : 0;
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
-	rxs->flag  |= (rxsp->status4 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
-	rxs->flag  |= (rxsp->status4 & AR_2040) ? RX_FLAG_40MHZ : 0;
+	rxs->enc_flags |= (rxsp->status4 & AR_GI) ? RX_ENC_FLAG_SHORT_GI : 0;
+	rxs->enc_flags |= (rxsp->status4 & AR_2040) ? RX_ENC_FLAG_40MHZ : 0;
 
 	rxs->evm0 = rxsp->status6;
 	rxs->evm1 = rxsp->status7;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index b80e08b13b74..9ed779b020d3 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -181,14 +181,13 @@ int ath9k_cmn_process_rate(struct ath_common *common,
 	sband = hw->wiphy->bands[band];
 
 	if (IS_CHAN_QUARTER_RATE(ah->curchan))
-		rxs->flag |= RX_FLAG_5MHZ;
+		rxs->enc_flags |= RX_ENC_FLAG_5MHZ;
 	else if (IS_CHAN_HALF_RATE(ah->curchan))
-		rxs->flag |= RX_FLAG_10MHZ;
+		rxs->enc_flags |= RX_ENC_FLAG_10MHZ;
 
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		rxs->flag |= rx_stats->flag;
+		rxs->enc_flags |= RX_ENC_FLAG_HT | rx_stats->enc_flags;
 		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
 		return 0;
 	}
@@ -199,7 +198,7 @@ int ath9k_cmn_process_rate(struct ath_common *common,
 			return 0;
 		}
 		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
+			rxs->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 			rxs->rate_idx = i;
 			return 0;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 524cbf13ca9c..f1174c9d94d4 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -116,12 +116,12 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 		if (rxs->rate_idx >= ARRAY_SIZE(rstats->ht_stats))
 			goto exit;
 
-		if (rxs->flag & RX_FLAG_40MHZ)
+		if (rxs->enc_flags & RX_ENC_FLAG_40MHZ)
 			rstats->ht_stats[rxs->rate_idx].ht40_cnt++;
 		else
 			rstats->ht_stats[rxs->rate_idx].ht20_cnt++;
 
-		if (rxs->flag & RX_FLAG_SHORT_GI)
+		if (rxs->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			rstats->ht_stats[rxs->rate_idx].sgi_cnt++;
 		else
 			rstats->ht_stats[rxs->rate_idx].lgi_cnt++;
@@ -130,7 +130,7 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 	}
 
 	if (IS_CCK_RATE(rs->rs_rate)) {
-		if (rxs->flag & RX_FLAG_SHORTPRE)
+		if (rxs->enc_flags & RX_ENC_FLAG_SHORTPRE)
 			rstats->cck_stats[rxs->rate_idx].cck_sp_cnt++;
 		else
 			rstats->cck_stats[rxs->rate_idx].cck_lp_cnt++;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index f333ef1e3e7b..9f94efd66049 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -929,11 +929,11 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 static inline void convert_htc_flag(struct ath_rx_status *rx_stats,
 				   struct ath_htc_rx_status *rxstatus)
 {
-	rx_stats->flag = 0;
+	rx_stats->enc_flags = 0;
 	if (rxstatus->rs_flags & ATH9K_RX_2040)
-		rx_stats->flag |= RX_FLAG_40MHZ;
+		rx_stats->enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rxstatus->rs_flags & ATH9K_RX_GI)
-		rx_stats->flag |= RX_FLAG_SHORT_GI;
+		rx_stats->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 }
 
 static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index d937c39b3a0b..c98a563fdd01 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -535,7 +535,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	rs->rs_status = 0;
 	rs->rs_flags = 0;
-	rs->flag = 0;
+	rs->enc_flags = 0;
 
 	rs->rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
 	rs->rs_tstamp = ads.AR_RcvTimestamp;
@@ -577,15 +577,15 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	rs->rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
 
 	/* directly mapped flags for ieee80211_rx_status */
-	rs->flag |=
-		(ads.ds_rxstatus3 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
-	rs->flag |=
-		(ads.ds_rxstatus3 & AR_2040) ? RX_FLAG_40MHZ : 0;
+	rs->enc_flags |=
+		(ads.ds_rxstatus3 & AR_GI) ? RX_ENC_FLAG_SHORT_GI : 0;
+	rs->enc_flags |=
+		(ads.ds_rxstatus3 & AR_2040) ? RX_ENC_FLAG_40MHZ : 0;
 	if (AR_SREV_9280_20_OR_LATER(ah))
-		rs->flag |=
+		rs->enc_flags |=
 			(ads.ds_rxstatus3 & AR_STBC) ?
 				/* we can only Nss=1 STBC */
-				(1 << RX_FLAG_STBC_SHIFT) : 0;
+				(1 << RX_ENC_FLAG_STBC_SHIFT) : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 770fc11b41d1..6bdf83f4ca9a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -143,7 +143,7 @@ struct ath_rx_status {
 	u32 evm2;
 	u32 evm3;
 	u32 evm4;
-	u32 flag; /* see enum mac80211_rx_flags */
+	u16 enc_flags;
 };
 
 struct ath_htc_rx_status {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d79837fe333f..65fcc34196f9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1037,11 +1037,11 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 
 	rxs = IEEE80211_SKB_RXCB(skb);
 
-	is_sgi = !!(rxs->flag & RX_FLAG_SHORT_GI);
-	is_40 = !!(rxs->flag & RX_FLAG_40MHZ);
-	is_sp = !!(rxs->flag & RX_FLAG_SHORTPRE);
+	is_sgi = !!(rxs->enc_flags & RX_ENC_FLAG_SHORT_GI);
+	is_40 = !!(rxs->enc_flags & RX_ENC_FLAG_40MHZ);
+	is_sp = !!(rxs->enc_flags & RX_ENC_FLAG_SHORTPRE);
 
-	if (!!(rxs->flag & RX_FLAG_HT)) {
+	if (!!(rxs->enc_flags & RX_ENC_FLAG_HT)) {
 		/* MCS rates */
 
 		airtime += ath_pkt_duration(sc, rxs->rate_idx, len,
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 0c34c8729dc6..c2ffe78b3491 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -358,7 +358,7 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
 	switch (mac->status & AR9170_RX_STATUS_MODULATION) {
 	case AR9170_RX_STATUS_MODULATION_CCK:
 		if (mac->status & AR9170_RX_STATUS_SHORT_PREAMBLE)
-			status->flag |= RX_FLAG_SHORTPRE;
+			status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 		switch (head->plcp[0]) {
 		case AR9170_RX_PHY_RATE_CCK_1M:
 			status->rate_idx = 0;
@@ -423,12 +423,12 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
 
 	case AR9170_RX_STATUS_MODULATION_HT:
 		if (head->plcp[3] & 0x80)
-			status->flag |= RX_FLAG_40MHZ;
+			status->enc_flags |= RX_ENC_FLAG_40MHZ;
 		if (head->plcp[6] & 0x80)
-			status->flag |= RX_FLAG_SHORT_GI;
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 		status->rate_idx = clamp(0, 75, head->plcp[3] & 0x7f);
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 8c387a0a3c09..22304edc5948 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -68,7 +68,7 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		       RX_FLAG_MMIC_STRIPPED |
 		       RX_FLAG_DECRYPTED;
 
-	wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%llx\n", status.flag);
+	wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%x\n", status.flag);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index b068d5aeee24..1b9c191e2a22 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -694,7 +694,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	if (unlikely(phystat0 & (B43_RX_PHYST0_PLCPHCF | B43_RX_PHYST0_PLCPFV)))
 		status.flag |= RX_FLAG_FAILED_PLCP_CRC;
 	if (phystat0 & B43_RX_PHYST0_SHORTPRMBL)
-		status.flag |= RX_FLAG_SHORTPRE;
+		status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 	if (macstat & B43_RX_MAC_DECERR) {
 		/* Decryption with the given key failed.
 		 * Drop the packet. We also won't be able to decrypt it with
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index c2a938b59044..95386a3757ea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -7092,9 +7092,9 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	rspec = brcms_c_compute_rspec(rxh, plcp);
 	if (is_mcs_rate(rspec)) {
 		rx_status->rate_idx = rspec & RSPEC_RATE_MASK;
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 		if (rspec_is40mhz(rspec))
-			rx_status->flag |= RX_FLAG_40MHZ;
+			rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	} else {
 		switch (rspec2rate(rspec)) {
 		case BRCM_RATE_1M:
@@ -7149,9 +7149,9 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		/* Determine short preamble and rate_idx */
 		if (is_cck_rate(rspec)) {
 			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
-				rx_status->flag |= RX_FLAG_SHORTPRE;
+				rx_status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 		} else if (is_ofdm_rate(rspec)) {
-			rx_status->flag |= RX_FLAG_SHORTPRE;
+			rx_status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 		} else {
 			brcms_err(wlc->hw->d11core, "%s: Unknown modulation\n",
 				  __func__);
@@ -7159,7 +7159,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	}
 
 	if (plcp3_issgi(plcp[3]))
-		rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (rxh->RxStatus1 & RXS_DECERR) {
 		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index 4db327a95414..080ea8155b90 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -570,7 +570,7 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/* set the preamble flag if appropriate */
 	if (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
 		D_DROP("dsp size out of range [0,20]: %d\n",
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 7eda525e3f4f..34a554b6ac3e 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -728,15 +728,15 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/* set the preamble flag if appropriate */
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	/* Set up the HT phy flags */
 	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.flag |= RX_FLAG_HT;
+		rx_status.enc_flags |= RX_ENC_FLAG_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.flag |= RX_FLAG_40MHZ;
+		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_AGG_MSK) {
 		/* We know which subframes of an A-MPDU belong
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index dfa2041cfdac..70e4fab5a0b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -873,7 +873,7 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	/* set the preamble flag if appropriate */
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_AGG_MSK) {
 		/*
@@ -887,13 +887,13 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	/* Set up the HT phy flags */
 	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.flag |= RX_FLAG_HT;
+		rx_status.enc_flags |= RX_ENC_FLAG_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.flag |= RX_FLAG_40MHZ;
+		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
-		rx_status.flag |= RX_FLAG_HT_GF;
+		rx_status.enc_flags |= RX_ENC_FLAG_HT_GF;
 
 	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d4c0ca7ccb34..314a245e249e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -410,7 +410,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	/* set the preamble flag if appropriate */
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_SHORT_PREAMBLE))
-		rx_status->flag |= RX_FLAG_SHORTPRE;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_AGG)) {
 		/*
@@ -427,27 +427,27 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	case RATE_MCS_CHAN_WIDTH_20:
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status->vht_flag |= RX_VHT_FLAG_160MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_160MHZ;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
-		rx_status->flag |= RX_FLAG_HT_GF;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT_GF;
 	if (rate_n_flags & RATE_MCS_LDPC_MSK)
-		rx_status->flag |= RX_FLAG_LDPC;
+		rx_status->enc_flags |= RX_ENC_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
-		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
@@ -455,10 +455,10 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status->flag |= RX_FLAG_VHT;
-		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
-			rx_status->vht_flag |= RX_VHT_FLAG_BF;
+			rx_status->enc_flags |= RX_ENC_FLAG_BF;
 	} else {
 		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
 							       rx_status->band);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 24c4fbe139a3..09f21bba6f48 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -824,7 +824,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	}
 	/* set the preamble flag if appropriate */
 	if (phy_info & IWL_RX_MPDU_PHY_SHORT_PREAMBLE)
-		rx_status->flag |= RX_FLAG_SHORTPRE;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 
 	if (likely(!(phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD))) {
 		rx_status->mactime = le64_to_cpu(desc->tsf_on_air_rise);
@@ -958,27 +958,27 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	case RATE_MCS_CHAN_WIDTH_20:
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status->vht_flag |= RX_VHT_FLAG_160MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_160MHZ;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
-		rx_status->flag |= RX_FLAG_HT_GF;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT_GF;
 	if (rate_n_flags & RATE_MCS_LDPC_MSK)
-		rx_status->flag |= RX_FLAG_LDPC;
+		rx_status->enc_flags |= RX_ENC_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
-		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
@@ -986,10 +986,10 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status->flag |= RX_FLAG_VHT;
-		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
-			rx_status->vht_flag |= RX_VHT_FLAG_BF;
+			rx_status->enc_flags |= RX_ENC_FLAG_BF;
 	} else {
 		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
 							       rx_status->band);
diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 1af7da0b386e..5e1c91a80c58 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -352,7 +352,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 
 	rx_status->signal = p54_rssi_to_dbm(priv, hdr->rssi);
 	if (hdr->rate & 0x10)
-		rx_status->flag |= RX_FLAG_SHORTPRE;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 	if (priv->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ)
 		rx_status->rate_idx = (rate < 4) ? 0 : rate - 4;
 	else
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0cab122669c8..f6e96a5ee2f0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1194,16 +1194,16 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			ieee80211_rate_get_vht_mcs(&info->control.rates[0]);
 		rx_status.vht_nss =
 			ieee80211_rate_get_vht_nss(&info->control.rates[0]);
-		rx_status.flag |= RX_FLAG_VHT;
+		rx_status.enc_flags |= RX_ENC_FLAG_VHT;
 	} else {
 		rx_status.rate_idx = info->control.rates[0].idx;
 		if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
-			rx_status.flag |= RX_FLAG_HT;
+			rx_status.enc_flags |= RX_ENC_FLAG_HT;
 	}
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		rx_status.flag |= RX_FLAG_40MHZ;
+		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	/* TODO: simulate real signal strength (and optional packet loss) */
 	rx_status.signal = -50;
 	if (info->control.vif)
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index c295a4c6e5cd..9f6ab746d9fc 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -994,9 +994,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	*noise = -rxd->noise_floor;
 
 	if (rxd->rate & MWL8K_AP_RATE_INFO_MCS_FORMAT) {
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 		if (rxd->rate & MWL8K_AP_RATE_INFO_40MHZ)
-			status->flag |= RX_FLAG_40MHZ;
+			status->enc_flags |= RX_ENC_FLAG_40MHZ;
 		status->rate_idx = MWL8K_AP_RATE_INFO_RATEID(rxd->rate);
 	} else {
 		int i;
@@ -1011,7 +1011,7 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
+		if (!(status->enc_flags & RX_ENC_FLAG_HT))
 			status->rate_idx -= 5;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
@@ -1109,17 +1109,17 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	status->rate_idx = MWL8K_STA_RATE_INFO_RATEID(rate_info);
 
 	if (rate_info & MWL8K_STA_RATE_INFO_SHORTPRE)
-		status->flag |= RX_FLAG_SHORTPRE;
+		status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 	if (rate_info & MWL8K_STA_RATE_INFO_40MHZ)
-		status->flag |= RX_FLAG_40MHZ;
+		status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rate_info & MWL8K_STA_RATE_INFO_SHORTGI)
-		status->flag |= RX_FLAG_SHORT_GI;
+		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_info & MWL8K_STA_RATE_INFO_MCS_FORMAT)
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->flag & RX_FLAG_HT))
+		if (!(status->enc_flags & RX_ENC_FLAG_HT))
 			status->rate_idx -= 5;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index 3c576392ed89..064cad0f0938 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -401,7 +401,7 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 	case MT_PHY_TYPE_CCK:
 		if (idx >= 8) {
 			idx -= 8;
-			status->flag |= RX_FLAG_SHORTPRE;
+			status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 		}
 
 		if (WARN_ON(idx >= 4))
@@ -410,10 +410,10 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 		status->rate_idx = idx;
 		return;
 	case MT_PHY_TYPE_HT_GF:
-		status->flag |= RX_FLAG_HT_GF;
+		status->enc_flags |= RX_ENC_FLAG_HT_GF;
 		/* fall through */
 	case MT_PHY_TYPE_HT:
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 		status->rate_idx = idx;
 		break;
 	default:
@@ -422,13 +422,13 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 	}
 
 	if (rate & MT_RXWI_RATE_SGI)
-		status->flag |= RX_FLAG_SHORT_GI;
+		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (rate & MT_RXWI_RATE_STBC)
-		status->flag |= 1 << RX_FLAG_STBC_SHIFT;
+		status->enc_flags |= 1 << RX_ENC_FLAG_STBC_SHIFT;
 
 	if (rate & MT_RXWI_RATE_BW)
-		status->flag |= RX_FLAG_40MHZ;
+		status->enc_flags |= RX_ENC_FLAG_40MHZ;
 }
 
 static void
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8585cdc3de53..03d415c553d1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -889,10 +889,10 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 	rt2x00_desc_read(rxwi, 1, &word);
 
 	if (rt2x00_get_field32(word, RXWI_W1_SHORT_GI))
-		rxdesc->flags |= RX_FLAG_SHORT_GI;
+		rxdesc->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (rt2x00_get_field32(word, RXWI_W1_BW))
-		rxdesc->flags |= RX_FLAG_40MHZ;
+		rxdesc->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	/*
 	 * Detect RX rate, always use MCS as signal type.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 5f9fa97b6088..8a4640d2ead0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -825,7 +825,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rate_idx = rt2x00lib_rxdone_read_signal(rt2x00dev, &rxdesc);
 	if (rxdesc.rate_mode == RATE_MODE_HT_MIX ||
 	    rxdesc.rate_mode == RATE_MODE_HT_GREENFIELD)
-		rxdesc.flags |= RX_FLAG_HT;
+		rxdesc.enc_flags |= RX_ENC_FLAG_HT;
 
 	/*
 	 * Check if this is a beacon, and more frames have been
@@ -865,6 +865,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rx_status->rate_idx = rate_idx;
 	rx_status->signal = rxdesc.rssi;
 	rx_status->flag = rxdesc.flags;
+	rx_status->enc_flags = rxdesc.enc_flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index c78fb8c8838a..a4242e8e202e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -184,6 +184,7 @@ struct rxdone_entry_desc {
 	int flags;
 	int dev_flags;
 	u16 rate_mode;
+	u16 enc_flags;
 	u8 cipher;
 	u8 cipher_status;
 
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index e387dec82d3d..225c1c8851cc 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -315,7 +315,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.mactime = tsft;
 			rx_status.flag |= RX_FLAG_MACTIME_START;
 			if (flags & RTL818X_RX_DESC_FLAG_SPLCP)
-				rx_status.flag |= RX_FLAG_SHORTPRE;
+				rx_status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 7dd18896d35a..35fe991dcc56 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -389,7 +389,7 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rx_status.band = dev->conf.chandef.chan->band;
 	rx_status.flag |= RX_FLAG_MACTIME_START;
 	if (flags & RTL818X_RX_DESC_FLAG_SPLCP)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status.enc_flags |= RX_ENC_FLAG_SHORTPRE;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9b4a9a00be64..4aa370aac9f6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5041,7 +5041,7 @@ static void rtl8xxxu_rx_parse_phystats(struct rtl8xxxu_priv *priv,
 				       u32 rxmcs)
 {
 	if (phy_stats->sgi_en)
-		rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (rxmcs < DESC_RATE_6M) {
 		/*
@@ -5267,10 +5267,10 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		if (rx_desc->crc32)
 			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 		if (rx_desc->bw)
-			rx_status->flag |= RX_FLAG_40MHZ;
+			rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 		if (rx_desc->rxht) {
-			rx_status->flag |= RX_FLAG_HT;
+			rx_status->enc_flags |= RX_ENC_FLAG_HT;
 			rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
 		} else {
 			rx_status->rate_idx = rx_desc->rxmcs;
@@ -5337,10 +5337,10 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 	if (rx_desc->crc32)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (rx_desc->bw)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (rx_desc->rxmcs >= DESC_RATE_MCS0) {
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 		rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
 	} else {
 		rx_status->rate_idx = rx_desc->rxmcs;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 09c908d4cf91..c5145c20200a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -444,10 +444,10 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (status->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 3616ba21959d..16f6c2eb6314 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -369,10 +369,10 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (stats->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (stats->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 1611e42479d9..d80d2838726a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -329,9 +329,9 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	if (!GET_RX_DESC_SWDEC(pdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(pdesc))
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (GET_RX_DESC_RX_HT(pdesc))
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
@@ -398,9 +398,9 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!GET_RX_DESC_SWDEC(rxdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(rxdesc))
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (GET_RX_DESC_RX_HT(rxdesc))
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 	/* Data rate */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats.is_ht,
 						   false, stats.rate);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 5c9c8741134f..01d7308cdc9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -503,9 +503,9 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	if (!GET_RX_DESC_SWDEC(pdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(pdesc))
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (GET_RX_DESC_RXHT(pdesc))
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 07440e9a8ca2..38ffee1f8838 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -394,10 +394,10 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (status->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 12cef01e593b..12a4a8faedec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -289,10 +289,10 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (stats->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (stats->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index c9838f52a7ea..b8d0bcae4a71 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -317,10 +317,10 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (status->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 6f65003a895a..8d35a58bae93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -373,10 +373,10 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 
 	if (status->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 108098152cf3..c4a35bfd4f3e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -520,16 +520,16 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_packet_bw == HT_CHANNEL_WIDTH_20_40)
-		rx_status->flag |= RX_FLAG_40MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
 	else if (status->rx_packet_bw == HT_CHANNEL_WIDTH_80)
-		rx_status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
 	if (status->is_ht)
-		rx_status->flag |= RX_FLAG_HT;
+		rx_status->enc_flags |= RX_ENC_FLAG_HT;
 	if (status->is_vht)
-		rx_status->flag |= RX_FLAG_VHT;
+		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
 
 	if (status->is_short_gi)
-		rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	rx_status->vht_nss = status->vht_nss;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index 3d170287cd0b..e8b69dbdfe39 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1085,7 +1085,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 			hdr->band);
 
 	if (arg->rx_rate >= 14) {
-		hdr->flag |= RX_FLAG_HT;
+		hdr->enc_flags |= RX_ENC_FLAG_HT;
 		hdr->rate_idx = arg->rx_rate - 14;
 	} else if (arg->rx_rate >= 4) {
 		hdr->rate_idx = arg->rx_rate - 2;
diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
index a27d4c22b6e8..50fb2a4a5259 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -141,7 +141,7 @@ static void wl1251_rx_status(struct wl1251 *wl,
 	}
 
 	if (desc->mod_pre & SHORT_PREAMBLE_BIT)
-		status->flag |= RX_FLAG_SHORTPRE;
+		status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 }
 
 static void wl1251_rx_body(struct wl1251 *wl,
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index b9e14045195f..5552c763dad5 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -72,7 +72,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 	/* 11n support */
 	if (desc->rate <= wl->hw_min_ht_rate)
-		status->flag |= RX_FLAG_HT;
+		status->enc_flags |= RX_ENC_FLAG_HT;
 
 	/*
 	* Read the signal level and antenna diversity indication.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b1ac872dc88a..53b3853d6fd1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1045,16 +1045,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	(including FCS) was received.
  * @RX_FLAG_MACTIME_PLCP_START: The timestamp passed in the RX status (@mactime
  *	field) is valid and contains the time the SYNC preamble was received.
- * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
- * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
- * @RX_FLAG_VHT: VHT MCS was used and rate_index is MCS index
- * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
- * @RX_FLAG_SHORT_GI: Short guard interval was used
  * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
  *	Valid only for data frames (mainly A-MPDU)
- * @RX_FLAG_HT_GF: This frame was received in a HT-greenfield transmission, if
- *	the driver fills this value it should add %IEEE80211_RADIOTAP_MCS_HAVE_FMT
- *	to hw.radiotap_mcs_details to advertise that fact
  * @RX_FLAG_AMPDU_DETAILS: A-MPDU details are known, in particular the reference
  *	number (@ampdu_reference) must be populated and be a distinct number for
  *	each A-MPDU
@@ -1067,7 +1059,6 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	is stored in the @ampdu_delimiter_crc field)
  * @RX_FLAG_MIC_STRIPPED: The mic was stripped of this packet. Decryption was
  *	done by the hardware
- * @RX_FLAG_LDPC: LDPC was used
  * @RX_FLAG_ONLY_MONITOR: Report frame only to monitor interfaces without
  *	processing it in any regular way.
  *	This is useful if drivers offload some frames but still want to report
@@ -1076,9 +1067,6 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	monitor interfaces.
  *	This is useful if drivers offload some frames but still want to report
  *	them for sniffing purposes.
- * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
- * @RX_FLAG_10MHZ: 10 MHz (half channel) was used
- * @RX_FLAG_5MHZ: 5 MHz (quarter channel) was used
  * @RX_FLAG_AMSDU_MORE: Some drivers may prefer to report separate A-MSDU
  *	subframes instead of a one huge frame for performance reasons.
  *	All, but the last MSDU from an A-MSDU should have this flag set. E.g.
@@ -1106,52 +1094,62 @@ enum mac80211_rx_flags {
 	RX_FLAG_FAILED_FCS_CRC		= BIT(5),
 	RX_FLAG_FAILED_PLCP_CRC 	= BIT(6),
 	RX_FLAG_MACTIME_START		= BIT(7),
-	RX_FLAG_SHORTPRE		= BIT(8),
-	RX_FLAG_HT			= BIT(9),
-	RX_FLAG_40MHZ			= BIT(10),
-	RX_FLAG_SHORT_GI		= BIT(11),
-	RX_FLAG_NO_SIGNAL_VAL		= BIT(12),
-	RX_FLAG_HT_GF			= BIT(13),
-	RX_FLAG_AMPDU_DETAILS		= BIT(14),
-	RX_FLAG_PN_VALIDATED		= BIT(15),
-	RX_FLAG_DUP_VALIDATED		= BIT(16),
-	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(17),
-	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
-	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
-	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
-	RX_FLAG_MACTIME_END		= BIT(21),
-	RX_FLAG_VHT			= BIT(22),
-	RX_FLAG_LDPC			= BIT(23),
-	RX_FLAG_ONLY_MONITOR		= BIT(24),
-	RX_FLAG_SKIP_MONITOR		= BIT(25),
-	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
-	RX_FLAG_10MHZ			= BIT(28),
-	RX_FLAG_5MHZ			= BIT(29),
-	RX_FLAG_AMSDU_MORE		= BIT(30),
-	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(31),
-	RX_FLAG_MIC_STRIPPED		= BIT_ULL(32),
-	RX_FLAG_ALLOW_SAME_PN		= BIT_ULL(33),
-	RX_FLAG_ICV_STRIPPED		= BIT_ULL(34),
+	RX_FLAG_NO_SIGNAL_VAL		= BIT(8),
+	RX_FLAG_AMPDU_DETAILS		= BIT(9),
+	RX_FLAG_PN_VALIDATED		= BIT(10),
+	RX_FLAG_DUP_VALIDATED		= BIT(11),
+	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(12),
+	RX_FLAG_AMPDU_IS_LAST		= BIT(13),
+	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(14),
+	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(15),
+	RX_FLAG_MACTIME_END		= BIT(16),
+	RX_FLAG_ONLY_MONITOR		= BIT(17),
+	RX_FLAG_SKIP_MONITOR		= BIT(18),
+	RX_FLAG_AMSDU_MORE		= BIT(19),
+	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(20),
+	RX_FLAG_MIC_STRIPPED		= BIT(21),
+	RX_FLAG_ALLOW_SAME_PN		= BIT(22),
+	RX_FLAG_ICV_STRIPPED		= BIT(23),
 };
 
-#define RX_FLAG_STBC_SHIFT		26
-
 /**
- * enum mac80211_rx_vht_flags - receive VHT flags
+ * enum mac80211_rx_encoding_flags - MCS & bandwidth flags
  *
- * These flags are used with the @vht_flag member of
- *	&struct ieee80211_rx_status.
- * @RX_VHT_FLAG_80MHZ: 80 MHz was used
- * @RX_VHT_FLAG_160MHZ: 160 MHz was used
- * @RX_VHT_FLAG_BF: packet was beamformed
- */
-
-enum mac80211_rx_vht_flags {
-	RX_VHT_FLAG_80MHZ		= BIT(0),
-	RX_VHT_FLAG_160MHZ		= BIT(1),
-	RX_VHT_FLAG_BF			= BIT(2),
+ * @RX_ENC_FLAG_SHORTPRE: Short preamble was used for this frame
+ * @RX_ENC_FLAG_HT: HT MCS was used and rate_idx is MCS index
+ * @RX_ENC_FLAG_VHT: VHT MCS was used and rate_index is MCS index
+ * @RX_ENC_FLAG_40MHZ: HT40 (40 MHz) was used
+ * @RX_ENC_FLAG_SHORT_GI: Short guard interval was used
+ * @RX_ENC_FLAG_HT_GF: This frame was received in a HT-greenfield transmission,
+ *	if the driver fills this value it should add
+ *	%IEEE80211_RADIOTAP_MCS_HAVE_FMT
+ *	to hw.radiotap_mcs_details to advertise that fact
+ * @RX_ENC_FLAG_LDPC: LDPC was used
+ * @RX_ENC_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
+ * @RX_ENC_FLAG_10MHZ: 10 MHz (half channel) was used
+ * @RX_ENC_FLAG_5MHZ: 5 MHz (quarter channel) was used
+ * @RX_ENC_FLAG_80MHZ: 80 MHz was used
+ * @RX_ENC_FLAG_160MHZ: 160 MHz was used
+ * @RX_ENC_FLAG_BF: packet was beamformed
+ */
+enum mac80211_rx_encoding_flags {
+	RX_ENC_FLAG_SHORTPRE		= BIT(0),
+	RX_ENC_FLAG_HT			= BIT(1),
+	RX_ENC_FLAG_40MHZ		= BIT(2),
+	RX_ENC_FLAG_SHORT_GI		= BIT(3),
+	RX_ENC_FLAG_HT_GF		= BIT(4),
+	RX_ENC_FLAG_VHT			= BIT(5),
+	RX_ENC_FLAG_STBC_MASK		= BIT(6) | BIT(7),
+	RX_ENC_FLAG_LDPC		= BIT(8),
+	RX_ENC_FLAG_10MHZ		= BIT(9),
+	RX_ENC_FLAG_5MHZ		= BIT(10),
+	RX_ENC_FLAG_80MHZ		= BIT(11),
+	RX_ENC_FLAG_160MHZ		= BIT(12),
+	RX_ENC_FLAG_BF			= BIT(13),
 };
 
+#define RX_ENC_FLAG_STBC_SHIFT		6
+
 /**
  * struct ieee80211_rx_status - receive status
  *
@@ -1181,7 +1179,7 @@ enum mac80211_rx_vht_flags {
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
  * @vht_nss: number of streams (VHT only)
  * @flag: %RX_FLAG_\*
- * @vht_flag: %RX_VHT_FLAG_\*
+ * @enc_flags: uses bits from &enum mac80211_rx_encoding_flags
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
@@ -1192,9 +1190,9 @@ struct ieee80211_rx_status {
 	u64 boottime_ns;
 	u32 device_timestamp;
 	u32 ampdu_reference;
-	u64 flag;
+	u32 flag;
+	u16 enc_flags;
 	u16 freq;
-	u8 vht_flag;
 	u8 rate_idx;
 	u8 vht_nss;
 	u8 rx_flags;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e957351976a2..6d9a80982d02 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1014,9 +1014,9 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 			prev_rates = sta->sta.supp_rates[band];
 			/* make sure mandatory rates are always added */
 			scan_width = NL80211_BSS_CHAN_WIDTH_20;
-			if (rx_status->flag & RX_FLAG_5MHZ)
+			if (rx_status->enc_flags & RX_ENC_FLAG_5MHZ)
 				scan_width = NL80211_BSS_CHAN_WIDTH_5;
-			if (rx_status->flag & RX_FLAG_10MHZ)
+			if (rx_status->enc_flags & RX_ENC_FLAG_10MHZ)
 				scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
 			sta->sta.supp_rates[band] = supp_rates |
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf6d5abb65a3..a4ba849ac074 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1532,7 +1532,7 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 		return true;
 	/* can't handle HT/VHT preamble yet */
 	if (status->flag & RX_FLAG_MACTIME_PLCP_START &&
-	    !(status->flag & (RX_FLAG_HT | RX_FLAG_VHT)))
+	    !(status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)))
 		return true;
 	return false;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fe6a760aa1ee..3f7ecde323d7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -156,7 +156,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	/* padding for RX_FLAGS if necessary */
 	len = ALIGN(len, 2);
 
-	if (status->flag & RX_FLAG_HT) /* HT info */
+	if (status->enc_flags & RX_ENC_FLAG_HT) /* HT info */
 		len += 3;
 
 	if (status->flag & RX_FLAG_AMPDU_DETAILS) {
@@ -164,7 +164,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len += 8;
 	}
 
-	if (status->flag & RX_FLAG_VHT) {
+	if (status->enc_flags & RX_ENC_FLAG_VHT) {
 		len = ALIGN(len, 2);
 		len += 12;
 	}
@@ -329,12 +329,12 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		*pos |= IEEE80211_RADIOTAP_F_BADFCS;
-	if (status->flag & RX_FLAG_SHORTPRE)
+	if (status->enc_flags & RX_ENC_FLAG_SHORTPRE)
 		*pos |= IEEE80211_RADIOTAP_F_SHORTPRE;
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (!rate || status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) {
+	if (!rate || status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)) {
 		/*
 		 * Without rate information don't add it. If we have,
 		 * MCS information is a separate field in radiotap,
@@ -345,9 +345,9 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	} else {
 		int shift = 0;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		if (status->flag & RX_FLAG_10MHZ)
+		if (status->enc_flags & RX_ENC_FLAG_10MHZ)
 			shift = 1;
-		else if (status->flag & RX_FLAG_5MHZ)
+		else if (status->enc_flags & RX_ENC_FLAG_5MHZ)
 			shift = 2;
 		*pos = DIV_ROUND_UP(rate->bitrate, 5 * (1 << shift));
 	}
@@ -356,14 +356,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_CHANNEL */
 	put_unaligned_le16(status->freq, pos);
 	pos += 2;
-	if (status->flag & RX_FLAG_10MHZ)
+	if (status->enc_flags & RX_ENC_FLAG_10MHZ)
 		channel_flags |= IEEE80211_CHAN_HALF;
-	else if (status->flag & RX_FLAG_5MHZ)
+	else if (status->enc_flags & RX_ENC_FLAG_5MHZ)
 		channel_flags |= IEEE80211_CHAN_QUARTER;
 
 	if (status->band == NL80211_BAND_5GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
-	else if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
+	else if (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT))
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
@@ -402,21 +402,21 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
 
-	if (status->flag & RX_FLAG_HT) {
+	if (status->enc_flags & RX_ENC_FLAG_HT) {
 		unsigned int stbc;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		*pos++ = local->hw.radiotap_mcs_details;
 		*pos = 0;
-		if (status->flag & RX_FLAG_SHORT_GI)
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
-		if (status->flag & RX_FLAG_40MHZ)
+		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
-		if (status->flag & RX_FLAG_HT_GF)
+		if (status->enc_flags & RX_ENC_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
-		if (status->flag & RX_FLAG_LDPC)
+		if (status->enc_flags & RX_ENC_FLAG_LDPC)
 			*pos |= IEEE80211_RADIOTAP_MCS_FEC_LDPC;
-		stbc = (status->flag & RX_FLAG_STBC_MASK) >> RX_FLAG_STBC_SHIFT;
+		stbc = (status->enc_flags & RX_ENC_FLAG_STBC_MASK) >> RX_ENC_FLAG_STBC_SHIFT;
 		*pos |= stbc << IEEE80211_RADIOTAP_MCS_STBC_SHIFT;
 		pos++;
 		*pos++ = status->rate_idx;
@@ -449,27 +449,27 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = 0;
 	}
 
-	if (status->flag & RX_FLAG_VHT) {
+	if (status->enc_flags & RX_ENC_FLAG_VHT) {
 		u16 known = local->hw.radiotap_vht_details;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
 		put_unaligned_le16(known, pos);
 		pos += 2;
 		/* flags */
-		if (status->flag & RX_FLAG_SHORT_GI)
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_SGI;
 		/* in VHT, STBC is binary */
-		if (status->flag & RX_FLAG_STBC_MASK)
+		if (status->enc_flags & RX_ENC_FLAG_STBC_MASK)
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_STBC;
-		if (status->vht_flag & RX_VHT_FLAG_BF)
+		if (status->enc_flags & RX_ENC_FLAG_BF)
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_BEAMFORMED;
 		pos++;
 		/* bandwidth */
-		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
+		if (status->enc_flags & RX_ENC_FLAG_80MHZ)
 			*pos++ = 4;
-		else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
+		else if (status->enc_flags & RX_ENC_FLAG_160MHZ)
 			*pos++ = 11;
-		else if (status->flag & RX_FLAG_40MHZ)
+		else if (status->enc_flags & RX_ENC_FLAG_40MHZ)
 			*pos++ = 1;
 		else /* 20 MHz */
 			*pos++ = 0;
@@ -477,7 +477,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = (status->rate_idx << 4) | status->vht_nss;
 		pos += 4;
 		/* coding field */
-		if (status->flag & RX_FLAG_LDPC)
+		if (status->enc_flags & RX_ENC_FLAG_LDPC)
 			*pos |= IEEE80211_RADIOTAP_CODING_LDPC_USER0;
 		pos++;
 		/* group ID */
@@ -3336,8 +3336,8 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
-		if (!(status->flag & RX_FLAG_HT) &&
-		    !(status->flag & RX_FLAG_VHT))
+		if (!(status->enc_flags & RX_ENC_FLAG_HT) &&
+		    !(status->enc_flags & RX_ENC_FLAG_VHT))
 			rate = &sband->bitrates[status->rate_idx];
 
 		ieee80211_rx_cooked_monitor(rx, rate);
@@ -3598,7 +3598,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 			return false;
 		if (!rx->sta) {
 			int rate_idx;
-			if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
+			if (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT))
 				rate_idx = 0; /* TODO: HT/VHT rates */
 			else
 				rate_idx = status->rate_idx;
@@ -3618,7 +3618,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 			return false;
 		if (!rx->sta) {
 			int rate_idx;
-			if (status->flag & RX_FLAG_HT)
+			if (status->enc_flags & RX_ENC_FLAG_HT)
 				rate_idx = 0; /* TODO: HT rates */
 			else
 				rate_idx = status->rate_idx;
@@ -4281,7 +4281,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 		 * we probably can't have a valid rate here anyway.
 		 */
 
-		if (status->flag & RX_FLAG_HT) {
+		if (status->enc_flags & RX_ENC_FLAG_HT) {
 			/*
 			 * rate_idx is MCS index, which can be [0-76]
 			 * as documented on:
@@ -4299,7 +4299,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				 status->rate_idx,
 				 status->rate_idx))
 				goto drop;
-		} else if (status->flag & RX_FLAG_VHT) {
+		} else if (status->enc_flags & RX_ENC_FLAG_VHT) {
 			if (WARN_ONCE(status->rate_idx > 9 ||
 				      !status->vht_nss ||
 				      status->vht_nss > 8,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index faab3c490d2b..f693ca0e0858 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -79,9 +79,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss_meta.signal = (rx_status->signal * 100) / local->hw.max_signal;
 
 	bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_20;
-	if (rx_status->flag & RX_FLAG_5MHZ)
+	if (rx_status->enc_flags & RX_ENC_FLAG_5MHZ)
 		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_5;
-	if (rx_status->flag & RX_FLAG_10MHZ)
+	if (rx_status->enc_flags & RX_ENC_FLAG_10MHZ)
 		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
 	bss_meta.chan = channel;
@@ -174,8 +174,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (beacon) {
 		struct ieee80211_supported_band *sband =
 			local->hw.wiphy->bands[rx_status->band];
-		if (!(rx_status->flag & RX_FLAG_HT) &&
-		    !(rx_status->flag & RX_FLAG_VHT))
+		if (!(rx_status->enc_flags & RX_ENC_FLAG_HT) &&
+		    !(rx_status->enc_flags & RX_ENC_FLAG_VHT))
 			bss->beacon_rate =
 				&sband->bitrates[rx_status->rate_idx];
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8949266d7bc3..22b8e0250fc6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -740,25 +740,25 @@ static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 {
 	u16 r = s->rate_idx;
 
-	if (s->vht_flag & RX_VHT_FLAG_80MHZ)
+	if (s->enc_flags & RX_ENC_FLAG_80MHZ)
 		r |= RATE_INFO_BW_80 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->vht_flag & RX_VHT_FLAG_160MHZ)
+	else if (s->enc_flags & RX_ENC_FLAG_160MHZ)
 		r |= RATE_INFO_BW_160 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->flag & RX_FLAG_40MHZ)
+	else if (s->enc_flags & RX_ENC_FLAG_40MHZ)
 		r |= RATE_INFO_BW_40 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->flag & RX_FLAG_10MHZ)
+	else if (s->enc_flags & RX_ENC_FLAG_10MHZ)
 		r |= RATE_INFO_BW_10 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->flag & RX_FLAG_5MHZ)
+	else if (s->enc_flags & RX_ENC_FLAG_5MHZ)
 		r |= RATE_INFO_BW_5 << STA_STATS_RATE_BW_SHIFT;
 	else
 		r |= RATE_INFO_BW_20 << STA_STATS_RATE_BW_SHIFT;
 
-	if (s->flag & RX_FLAG_SHORT_GI)
+	if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
 		r |= STA_STATS_RATE_SGI;
 
-	if (s->flag & RX_FLAG_VHT)
+	if (s->enc_flags & RX_ENC_FLAG_VHT)
 		r |= STA_STATS_RATE_TYPE_VHT | (s->vht_nss << 4);
-	else if (s->flag & RX_FLAG_HT)
+	else if (s->enc_flags & RX_ENC_FLAG_HT)
 		r |= STA_STATS_RATE_TYPE_HT;
 	else
 		r |= STA_STATS_RATE_TYPE_LEGACY | (s->band << 4);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 37dad3dd6bac..ca198d153d72 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2715,38 +2715,38 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	memset(&ri, 0, sizeof(ri));
 
 	/* Fill cfg80211 rate info */
-	if (status->flag & RX_FLAG_HT) {
+	if (status->enc_flags & RX_ENC_FLAG_HT) {
 		ri.mcs = status->rate_idx;
 		ri.flags |= RATE_INFO_FLAGS_MCS;
-		if (status->flag & RX_FLAG_40MHZ)
+		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
 			ri.bw = RATE_INFO_BW_40;
 		else
 			ri.bw = RATE_INFO_BW_20;
-		if (status->flag & RX_FLAG_SHORT_GI)
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	} else if (status->flag & RX_FLAG_VHT) {
+	} else if (status->enc_flags & RX_ENC_FLAG_VHT) {
 		ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
 		ri.mcs = status->rate_idx;
 		ri.nss = status->vht_nss;
-		if (status->flag & RX_FLAG_40MHZ)
+		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
 			ri.bw = RATE_INFO_BW_40;
-		else if (status->vht_flag & RX_VHT_FLAG_80MHZ)
+		else if (status->enc_flags & RX_ENC_FLAG_80MHZ)
 			ri.bw = RATE_INFO_BW_80;
-		else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
+		else if (status->enc_flags & RX_ENC_FLAG_160MHZ)
 			ri.bw = RATE_INFO_BW_160;
 		else
 			ri.bw = RATE_INFO_BW_20;
-		if (status->flag & RX_FLAG_SHORT_GI)
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else {
 		struct ieee80211_supported_band *sband;
 		int shift = 0;
 		int bitrate;
 
-		if (status->flag & RX_FLAG_10MHZ) {
+		if (status->enc_flags & RX_ENC_FLAG_10MHZ) {
 			shift = 1;
 			ri.bw = RATE_INFO_BW_10;
-		} else if (status->flag & RX_FLAG_5MHZ) {
+		} else if (status->enc_flags & RX_ENC_FLAG_5MHZ) {
 			shift = 2;
 			ri.bw = RATE_INFO_BW_5;
 		} else {
@@ -2762,7 +2762,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 			if (status->band == NL80211_BAND_5GHZ) {
 				ts += 20 << shift;
 				mpdu_offset += 2;
-			} else if (status->flag & RX_FLAG_SHORTPRE) {
+			} else if (status->enc_flags & RX_ENC_FLAG_SHORTPRE) {
 				ts += 96;
 			} else {
 				ts += 192;
-- 
2.11.0
