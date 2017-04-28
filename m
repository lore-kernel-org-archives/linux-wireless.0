Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49284 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422978AbdD1Ign (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: separate encoding/bandwidth from flags
Date: Fri, 28 Apr 2017 10:36:24 +0200
Message-Id: <20170428083626.3463-3-johannes@sipsolutions.net> (sfid-20170428_103739_056189_DAE6846F)
In-Reply-To: <20170428083626.3463-1-johannes@sipsolutions.net>
References: <20170428083626.3463-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently use a lot of flags that are mutually incompatible,
separate this out into actual encoding and bandwidth enum values.

Much of this again done with spatch, with manual post-editing,
mostly to add the switch statements and get rid of the conversions.

@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_80MHZ
+status->bw = RATE_INFO_BW_80
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_40MHZ
+status->bw = RATE_INFO_BW_40
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_20MHZ
+status->bw = RATE_INFO_BW_20
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_160MHZ
+status->bw = RATE_INFO_BW_160
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_5MHZ
+status->bw = RATE_INFO_BW_5
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_10MHZ
+status->bw = RATE_INFO_BW_10

@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_VHT
+status->encoding = RX_ENC_VHT
@@
expression status;
@@
-status->enc_flags |= RX_ENC_FLAG_HT
+status->encoding = RX_ENC_HT
@@
expression status;
@@
-status.enc_flags |= RX_ENC_FLAG_VHT
+status.encoding = RX_ENC_VHT
@@
expression status;
@@
-status.enc_flags |= RX_ENC_FLAG_HT
+status.encoding = RX_ENC_HT

@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_HT)
+(status->encoding == RX_ENC_HT)
@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_VHT)
+(status->encoding == RX_ENC_VHT)

@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_5MHZ)
+(status->bw == RATE_INFO_BW_5)
@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_10MHZ)
+(status->bw == RATE_INFO_BW_10)
@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_40MHZ)
+(status->bw == RATE_INFO_BW_40)
@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_80MHZ)
+(status->bw == RATE_INFO_BW_80)
@@
expression status;
@@
-(status->enc_flags & RX_ENC_FLAG_160MHZ)
+(status->bw == RATE_INFO_BW_160)

type=feature

Change-Id: I4762e904f452eb097a6dfba71b3d195aa8232758
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 32 ++++++-------
 drivers/net/wireless/ath/ath5k/base.c              |  4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |  1 +
 drivers/net/wireless/ath/ath9k/common.c            |  8 ++--
 drivers/net/wireless/ath/ath9k/debug_sta.c         |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  3 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  1 +
 drivers/net/wireless/ath/ath9k/mac.h               |  2 +
 drivers/net/wireless/ath/ath9k/recv.c              |  4 +-
 drivers/net/wireless/ath/carl9170/rx.c             |  4 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |  4 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 10 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 10 ++--
 drivers/net/wireless/mac80211_hwsim.c              |  4 +-
 drivers/net/wireless/marvell/mwl8k.c               | 12 ++---
 drivers/net/wireless/mediatek/mt7601u/mac.c        |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h   |  2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  8 ++--
 drivers/net/wireless/st/cw1200/txrx.c              |  2 +-
 drivers/net/wireless/ti/wlcore/rx.c                |  2 +-
 include/net/mac80211.h                             | 37 +++++++--------
 net/mac80211/ibss.c                                |  4 +-
 net/mac80211/ieee80211_i.h                         |  4 +-
 net/mac80211/rx.c                                  | 55 +++++++++++++---------
 net/mac80211/scan.c                                |  8 ++--
 net/mac80211/sta_info.h                            | 29 +++++-------
 net/mac80211/util.c                                | 43 +++++++++--------
 40 files changed, 182 insertions(+), 171 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2c29f8d12bcf..f5ddb83e285f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -632,11 +632,11 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		sgi = (info3 >> 7) & 1;
 
 		status->rate_idx = mcs;
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 		if (sgi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 		if (bw)
-			status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			status->bw = RATE_INFO_BW_40;
 		break;
 	case HTT_RX_VHT:
 	case HTT_RX_VHT_WITH_TXBF:
@@ -700,18 +700,18 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 			break;
 		/* 40MHZ */
 		case 1:
-			status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			status->bw = RATE_INFO_BW_40;
 			break;
 		/* 80MHZ */
 		case 2:
-			status->enc_flags |= RX_ENC_FLAG_80MHZ;
+			status->bw = RATE_INFO_BW_80;
 			break;
 		case 3:
-			status->enc_flags |= RX_ENC_FLAG_160MHZ;
+			status->bw = RATE_INFO_BW_160;
 			break;
 		}
 
-		status->enc_flags |= RX_ENC_FLAG_VHT;
+		status->encoding = RX_ENC_VHT;
 		break;
 	default:
 		break;
@@ -875,11 +875,8 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->freq = 0;
 		status->rate_idx = 0;
 		status->vht_nss = 0;
-		status->enc_flags &= ~(RX_ENC_FLAG_HT |
-				       RX_ENC_FLAG_VHT |
-				       RX_ENC_FLAG_SHORT_GI |
-				       RX_ENC_FLAG_40MHZ |
-				       RX_ENC_FLAG_80MHZ);
+		status->encoding = RX_ENC_LEGACY;
+		status->bw = RATE_INFO_BW_20;
 		status->flag &= ~RX_FLAG_MACTIME_END;
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
@@ -941,13 +938,12 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
 							"mcast" : "ucast",
 		   (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4,
-		   (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)) == 0 ?
-		   "legacy" : "",
-		   status->enc_flags & RX_ENC_FLAG_HT ? "ht" : "",
-		   status->enc_flags & RX_ENC_FLAG_VHT ? "vht" : "",
-		   status->enc_flags & RX_ENC_FLAG_40MHZ ? "40" : "",
-		   status->enc_flags & RX_ENC_FLAG_80MHZ ? "80" : "",
-		   status->enc_flags & RX_ENC_FLAG_160MHZ ? "160" : "",
+		   (status->encoding == RX_ENC_LEGACY) ? "legacy" : "",
+		   (status->encoding == RX_ENC_HT) ? "ht" : "",
+		   (status->encoding == RX_ENC_VHT) ? "vht" : "",
+		   (status->bw == RATE_INFO_BW_40) ? "40" : "",
+		   (status->bw == RATE_INFO_BW_80) ? "80" : "",
+		   (status->bw == RATE_INFO_BW_160) ? "160" : "",
 		   status->enc_flags & RX_ENC_FLAG_SHORT_GI ? "sgi " : "",
 		   status->rate_idx,
 		   status->vht_nss,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index da43469f6b49..527afcf39246 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1414,10 +1414,10 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	rxs->flag |= ath5k_rx_decrypted(ah, skb, rs);
 	switch (ah->ah_bwmode) {
 	case AR5K_BWMODE_5MHZ:
-		rxs->enc_flags |= RX_ENC_FLAG_5MHZ;
+		rxs->bw = RATE_INFO_BW_5;
 		break;
 	case AR5K_BWMODE_10MHZ:
-		rxs->enc_flags |= RX_ENC_FLAG_10MHZ;
+		rxs->bw = RATE_INFO_BW_10;
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 909854de42a1..68fcbe03bce2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -495,6 +495,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
 	rxs->enc_flags = 0;
+	rxs->bw = RATE_INFO_BW_20;
 
 	rxs->rs_datalen = rxsp->status2 & AR_DataLen;
 	rxs->rs_tstamp =  rxsp->status3;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 9ed779b020d3..c67d0e08bd4c 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -181,13 +181,15 @@ int ath9k_cmn_process_rate(struct ath_common *common,
 	sband = hw->wiphy->bands[band];
 
 	if (IS_CHAN_QUARTER_RATE(ah->curchan))
-		rxs->enc_flags |= RX_ENC_FLAG_5MHZ;
+		rxs->bw = RATE_INFO_BW_5;
 	else if (IS_CHAN_HALF_RATE(ah->curchan))
-		rxs->enc_flags |= RX_ENC_FLAG_10MHZ;
+		rxs->bw = RATE_INFO_BW_10;
 
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
-		rxs->enc_flags |= RX_ENC_FLAG_HT | rx_stats->enc_flags;
+		rxs->encoding = RX_ENC_HT;
+		rxs->enc_flags |= rx_stats->enc_flags;
+		rxs->bw = rx_stats->bw;
 		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index f1174c9d94d4..efc692ee67d4 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -116,7 +116,7 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 		if (rxs->rate_idx >= ARRAY_SIZE(rstats->ht_stats))
 			goto exit;
 
-		if (rxs->enc_flags & RX_ENC_FLAG_40MHZ)
+		if ((rxs->bw == RATE_INFO_BW_40))
 			rstats->ht_stats[rxs->rate_idx].ht40_cnt++;
 		else
 			rstats->ht_stats[rxs->rate_idx].ht20_cnt++;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 9f94efd66049..b38a586ea59a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -930,8 +930,9 @@ static inline void convert_htc_flag(struct ath_rx_status *rx_stats,
 				   struct ath_htc_rx_status *rxstatus)
 {
 	rx_stats->enc_flags = 0;
+	rx_stats->bw = RATE_INFO_BW_20;
 	if (rxstatus->rs_flags & ATH9K_RX_2040)
-		rx_stats->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_stats->bw = RATE_INFO_BW_40;
 	if (rxstatus->rs_flags & ATH9K_RX_GI)
 		rx_stats->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c98a563fdd01..6128c2bb23d8 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -536,6 +536,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	rs->rs_status = 0;
 	rs->rs_flags = 0;
 	rs->enc_flags = 0;
+	rs->bw = RATE_INFO_BW_20;
 
 	rs->rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
 	rs->rs_tstamp = ads.AR_RcvTimestamp;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 6bdf83f4ca9a..fd6aa49adadf 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -16,6 +16,7 @@
 
 #ifndef MAC_H
 #define MAC_H
+#include <net/cfg80211.h>
 
 #define set11nTries(_series, _index) \
 	(SM((_series)[_index].Tries, AR_XmitDataTries##_index))
@@ -144,6 +145,7 @@ struct ath_rx_status {
 	u32 evm3;
 	u32 evm4;
 	u16 enc_flags;
+	enum rate_info_bw bw;
 };
 
 struct ath_htc_rx_status {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 65fcc34196f9..2197aee2bb72 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1038,10 +1038,10 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 	rxs = IEEE80211_SKB_RXCB(skb);
 
 	is_sgi = !!(rxs->enc_flags & RX_ENC_FLAG_SHORT_GI);
-	is_40 = !!(rxs->enc_flags & RX_ENC_FLAG_40MHZ);
+	is_40 = !!(rxs->bw == RATE_INFO_BW_40);
 	is_sp = !!(rxs->enc_flags & RX_ENC_FLAG_SHORTPRE);
 
-	if (!!(rxs->enc_flags & RX_ENC_FLAG_HT)) {
+	if (!!(rxs->encoding == RX_ENC_HT)) {
 		/* MCS rates */
 
 		airtime += ath_pkt_duration(sc, rxs->rate_idx, len,
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index c2ffe78b3491..b2166726b05d 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -423,12 +423,12 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
 
 	case AR9170_RX_STATUS_MODULATION_HT:
 		if (head->plcp[3] & 0x80)
-			status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			status->bw = RATE_INFO_BW_40;
 		if (head->plcp[6] & 0x80)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 		status->rate_idx = clamp(0, 75, head->plcp[3] & 0x7f);
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 95386a3757ea..0a14942b8216 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -7092,9 +7092,9 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	rspec = brcms_c_compute_rspec(rxh, plcp);
 	if (is_mcs_rate(rspec)) {
 		rx_status->rate_idx = rspec & RSPEC_RATE_MASK;
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 		if (rspec_is40mhz(rspec))
-			rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			rx_status->bw = RATE_INFO_BW_40;
 	} else {
 		switch (rspec2rate(rspec)) {
 		case BRCM_RATE_1M:
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 34a554b6ac3e..5d5faa3cad24 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -732,7 +732,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 
 	/* Set up the HT phy flags */
 	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.enc_flags |= RX_ENC_FLAG_HT;
+		rx_status.encoding = RX_ENC_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
 		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 70e4fab5a0b8..1ee1ba9931a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -887,7 +887,7 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	/* Set up the HT phy flags */
 	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.enc_flags |= RX_ENC_FLAG_HT;
+		rx_status.encoding = RX_ENC_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
 		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 314a245e249e..93226329e077 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -427,13 +427,13 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	case RATE_MCS_CHAN_WIDTH_20:
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
+		rx_status->bw = RATE_INFO_BW_80;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status->enc_flags |= RX_ENC_FLAG_160MHZ;
+		rx_status->bw = RATE_INFO_BW_160;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
@@ -445,7 +445,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
@@ -455,7 +455,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status->encoding = RX_ENC_VHT;
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->enc_flags |= RX_ENC_FLAG_BF;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 09f21bba6f48..447f030c5c0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -958,13 +958,13 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	case RATE_MCS_CHAN_WIDTH_20:
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
+		rx_status->bw = RATE_INFO_BW_80;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status->enc_flags |= RX_ENC_FLAG_160MHZ;
+		rx_status->bw = RATE_INFO_BW_160;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
@@ -976,7 +976,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
@@ -986,7 +986,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status->encoding = RX_ENC_VHT;
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->enc_flags |= RX_ENC_FLAG_BF;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f6e96a5ee2f0..358f5f8ff6b9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1194,11 +1194,11 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			ieee80211_rate_get_vht_mcs(&info->control.rates[0]);
 		rx_status.vht_nss =
 			ieee80211_rate_get_vht_nss(&info->control.rates[0]);
-		rx_status.enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status.encoding = RX_ENC_VHT;
 	} else {
 		rx_status.rate_idx = info->control.rates[0].idx;
 		if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
-			rx_status.enc_flags |= RX_ENC_FLAG_HT;
+			rx_status.encoding = RX_ENC_HT;
 	}
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 9f6ab746d9fc..e813b2ca740c 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -994,9 +994,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	*noise = -rxd->noise_floor;
 
 	if (rxd->rate & MWL8K_AP_RATE_INFO_MCS_FORMAT) {
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 		if (rxd->rate & MWL8K_AP_RATE_INFO_40MHZ)
-			status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			status->bw = RATE_INFO_BW_40;
 		status->rate_idx = MWL8K_AP_RATE_INFO_RATEID(rxd->rate);
 	} else {
 		int i;
@@ -1011,7 +1011,7 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->enc_flags & RX_ENC_FLAG_HT))
+		if (!(status->encoding == RX_ENC_HT))
 			status->rate_idx -= 5;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
@@ -1111,15 +1111,15 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	if (rate_info & MWL8K_STA_RATE_INFO_SHORTPRE)
 		status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
 	if (rate_info & MWL8K_STA_RATE_INFO_40MHZ)
-		status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		status->bw = RATE_INFO_BW_40;
 	if (rate_info & MWL8K_STA_RATE_INFO_SHORTGI)
 		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_info & MWL8K_STA_RATE_INFO_MCS_FORMAT)
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->enc_flags & RX_ENC_FLAG_HT))
+		if (!(status->encoding == RX_ENC_HT))
 			status->rate_idx -= 5;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index 064cad0f0938..d6dc59bb00df 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -413,7 +413,7 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 		status->enc_flags |= RX_ENC_FLAG_HT_GF;
 		/* fall through */
 	case MT_PHY_TYPE_HT:
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 		status->rate_idx = idx;
 		break;
 	default:
@@ -428,7 +428,7 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 		status->enc_flags |= 1 << RX_ENC_FLAG_STBC_SHIFT;
 
 	if (rate & MT_RXWI_RATE_BW)
-		status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		status->bw = RATE_INFO_BW_40;
 }
 
 static void
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 03d415c553d1..d11c7b210e81 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -892,7 +892,7 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 		rxdesc->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	if (rt2x00_get_field32(word, RXWI_W1_BW))
-		rxdesc->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rxdesc->bw = RATE_INFO_BW_40;
 
 	/*
 	 * Detect RX rate, always use MCS as signal type.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 8a4640d2ead0..357c0941aaad 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -825,7 +825,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rate_idx = rt2x00lib_rxdone_read_signal(rt2x00dev, &rxdesc);
 	if (rxdesc.rate_mode == RATE_MODE_HT_MIX ||
 	    rxdesc.rate_mode == RATE_MODE_HT_GREENFIELD)
-		rxdesc.enc_flags |= RX_ENC_FLAG_HT;
+		rxdesc.encoding = RX_ENC_HT;
 
 	/*
 	 * Check if this is a beacon, and more frames have been
@@ -866,6 +866,8 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rx_status->signal = rxdesc.rssi;
 	rx_status->flag = rxdesc.flags;
 	rx_status->enc_flags = rxdesc.enc_flags;
+	rx_status->encoding = rxdesc.encoding;
+	rx_status->bw = rxdesc.bw;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index a4242e8e202e..6055f36211b9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -185,6 +185,8 @@ struct rxdone_entry_desc {
 	int dev_flags;
 	u16 rate_mode;
 	u16 enc_flags;
+	enum mac80211_rx_encoding encoding;
+	enum rate_info_bw bw;
 	u8 cipher;
 	u8 cipher_status;
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 4aa370aac9f6..39d56313bc94 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5267,10 +5267,10 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		if (rx_desc->crc32)
 			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 		if (rx_desc->bw)
-			rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+			rx_status->bw = RATE_INFO_BW_40;
 
 		if (rx_desc->rxht) {
-			rx_status->enc_flags |= RX_ENC_FLAG_HT;
+			rx_status->encoding = RX_ENC_HT;
 			rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
 		} else {
 			rx_status->rate_idx = rx_desc->rxmcs;
@@ -5337,10 +5337,10 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 	if (rx_desc->crc32)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (rx_desc->bw)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (rx_desc->rxmcs >= DESC_RATE_MCS0) {
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 		rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
 	} else {
 		rx_status->rate_idx = rx_desc->rxmcs;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index c5145c20200a..dd3e12b74447 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -444,10 +444,10 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 16f6c2eb6314..94a4b39437cd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -369,10 +369,10 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (stats->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (stats->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index d80d2838726a..41422e4da8b7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -329,9 +329,9 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	if (!GET_RX_DESC_SWDEC(pdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(pdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 	if (GET_RX_DESC_RX_HT(pdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
@@ -398,9 +398,9 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!GET_RX_DESC_SWDEC(rxdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(rxdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 	if (GET_RX_DESC_RX_HT(rxdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 	/* Data rate */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats.is_ht,
 						   false, stats.rate);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 01d7308cdc9f..86019f654428 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -503,9 +503,9 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	if (!GET_RX_DESC_SWDEC(pdesc))
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (GET_RX_DESC_BW(pdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 	if (GET_RX_DESC_RXHT(pdesc))
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 38ffee1f8838..b1864bb07c2c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -394,10 +394,10 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 12a4a8faedec..a01dbd31d1b4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -289,10 +289,10 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (stats->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (stats->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index b8d0bcae4a71..f713c7249fed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -317,10 +317,10 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 8d35a58bae93..3c6ce994c6aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -373,10 +373,10 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_is40Mhzpacket)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index c4a35bfd4f3e..2182a3ec5b9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -520,13 +520,13 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (status->rx_packet_bw == HT_CHANNEL_WIDTH_20_40)
-		rx_status->enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status->bw = RATE_INFO_BW_40;
 	else if (status->rx_packet_bw == HT_CHANNEL_WIDTH_80)
-		rx_status->enc_flags |= RX_ENC_FLAG_80MHZ;
+		rx_status->bw = RATE_INFO_BW_80;
 	if (status->is_ht)
-		rx_status->enc_flags |= RX_ENC_FLAG_HT;
+		rx_status->encoding = RX_ENC_HT;
 	if (status->is_vht)
-		rx_status->enc_flags |= RX_ENC_FLAG_VHT;
+		rx_status->encoding = RX_ENC_VHT;
 
 	if (status->is_short_gi)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index e8b69dbdfe39..cd63ffef025a 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1085,7 +1085,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 			hdr->band);
 
 	if (arg->rx_rate >= 14) {
-		hdr->enc_flags |= RX_ENC_FLAG_HT;
+		hdr->encoding = RX_ENC_HT;
 		hdr->rate_idx = arg->rx_rate - 14;
 	} else if (arg->rx_rate >= 4) {
 		hdr->rate_idx = arg->rx_rate - 2;
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 5552c763dad5..52a55f9acd80 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -72,7 +72,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 	/* 11n support */
 	if (desc->rate <= wl->hw_min_ht_rate)
-		status->enc_flags |= RX_ENC_FLAG_HT;
+		status->encoding = RX_ENC_HT;
 
 	/*
 	* Read the signal level and antenna diversity indication.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 53b3853d6fd1..c7c1f75a4a48 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1116,8 +1116,6 @@ enum mac80211_rx_flags {
  * enum mac80211_rx_encoding_flags - MCS & bandwidth flags
  *
  * @RX_ENC_FLAG_SHORTPRE: Short preamble was used for this frame
- * @RX_ENC_FLAG_HT: HT MCS was used and rate_idx is MCS index
- * @RX_ENC_FLAG_VHT: VHT MCS was used and rate_index is MCS index
  * @RX_ENC_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_ENC_FLAG_SHORT_GI: Short guard interval was used
  * @RX_ENC_FLAG_HT_GF: This frame was received in a HT-greenfield transmission,
@@ -1126,29 +1124,25 @@ enum mac80211_rx_flags {
  *	to hw.radiotap_mcs_details to advertise that fact
  * @RX_ENC_FLAG_LDPC: LDPC was used
  * @RX_ENC_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
- * @RX_ENC_FLAG_10MHZ: 10 MHz (half channel) was used
- * @RX_ENC_FLAG_5MHZ: 5 MHz (quarter channel) was used
- * @RX_ENC_FLAG_80MHZ: 80 MHz was used
- * @RX_ENC_FLAG_160MHZ: 160 MHz was used
  * @RX_ENC_FLAG_BF: packet was beamformed
  */
 enum mac80211_rx_encoding_flags {
 	RX_ENC_FLAG_SHORTPRE		= BIT(0),
-	RX_ENC_FLAG_HT			= BIT(1),
-	RX_ENC_FLAG_40MHZ		= BIT(2),
-	RX_ENC_FLAG_SHORT_GI		= BIT(3),
-	RX_ENC_FLAG_HT_GF		= BIT(4),
-	RX_ENC_FLAG_VHT			= BIT(5),
-	RX_ENC_FLAG_STBC_MASK		= BIT(6) | BIT(7),
-	RX_ENC_FLAG_LDPC		= BIT(8),
-	RX_ENC_FLAG_10MHZ		= BIT(9),
-	RX_ENC_FLAG_5MHZ		= BIT(10),
-	RX_ENC_FLAG_80MHZ		= BIT(11),
-	RX_ENC_FLAG_160MHZ		= BIT(12),
-	RX_ENC_FLAG_BF			= BIT(13),
+	RX_ENC_FLAG_40MHZ		= BIT(1),
+	RX_ENC_FLAG_SHORT_GI		= BIT(2),
+	RX_ENC_FLAG_HT_GF		= BIT(3),
+	RX_ENC_FLAG_STBC_MASK		= BIT(4) | BIT(5),
+	RX_ENC_FLAG_LDPC		= BIT(6),
+	RX_ENC_FLAG_BF			= BIT(7),
 };
 
-#define RX_ENC_FLAG_STBC_SHIFT		6
+#define RX_ENC_FLAG_STBC_SHIFT		4
+
+enum mac80211_rx_encoding {
+	RX_ENC_LEGACY = 0,
+	RX_ENC_HT,
+	RX_ENC_VHT,
+};
 
 /**
  * struct ieee80211_rx_status - receive status
@@ -1179,6 +1173,8 @@ enum mac80211_rx_encoding_flags {
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
  * @vht_nss: number of streams (VHT only)
  * @flag: %RX_FLAG_\*
+ * @encoding: &enum mac80211_rx_encoding
+ * @bw: &enum rate_info_bw
  * @enc_flags: uses bits from &enum mac80211_rx_encoding_flags
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
@@ -1191,8 +1187,9 @@ struct ieee80211_rx_status {
 	u32 device_timestamp;
 	u32 ampdu_reference;
 	u32 flag;
-	u16 enc_flags;
 	u16 freq;
+	u8 enc_flags;
+	u8 encoding:2, bw:3;
 	u8 rate_idx;
 	u8 vht_nss;
 	u8 rx_flags;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6d9a80982d02..9d0f6100942b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1014,9 +1014,9 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 			prev_rates = sta->sta.supp_rates[band];
 			/* make sure mandatory rates are always added */
 			scan_width = NL80211_BSS_CHAN_WIDTH_20;
-			if (rx_status->enc_flags & RX_ENC_FLAG_5MHZ)
+			if (rx_status->bw == RATE_INFO_BW_5)
 				scan_width = NL80211_BSS_CHAN_WIDTH_5;
-			if (rx_status->enc_flags & RX_ENC_FLAG_10MHZ)
+			else if (rx_status->bw == RATE_INFO_BW_10)
 				scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
 			sta->sta.supp_rates[band] = supp_rates |
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a4ba849ac074..47d709afea25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1530,9 +1530,9 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 		     status->flag & RX_FLAG_MACTIME_END);
 	if (status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END))
 		return true;
-	/* can't handle HT/VHT preamble yet */
+	/* can't handle non-legacy preamble yet */
 	if (status->flag & RX_FLAG_MACTIME_PLCP_START &&
-	    !(status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)))
+	    status->encoding != RX_ENC_LEGACY)
 		return true;
 	return false;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3f7ecde323d7..762e89cf737a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -156,7 +156,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	/* padding for RX_FLAGS if necessary */
 	len = ALIGN(len, 2);
 
-	if (status->enc_flags & RX_ENC_FLAG_HT) /* HT info */
+	if (status->encoding == RX_ENC_HT) /* HT info */
 		len += 3;
 
 	if (status->flag & RX_FLAG_AMPDU_DETAILS) {
@@ -164,7 +164,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len += 8;
 	}
 
-	if (status->enc_flags & RX_ENC_FLAG_VHT) {
+	if (status->encoding == RX_ENC_VHT) {
 		len = ALIGN(len, 2);
 		len += 12;
 	}
@@ -334,7 +334,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (!rate || status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT)) {
+	if (!rate || status->encoding != RX_ENC_LEGACY) {
 		/*
 		 * Without rate information don't add it. If we have,
 		 * MCS information is a separate field in radiotap,
@@ -345,9 +345,9 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	} else {
 		int shift = 0;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
-		if (status->enc_flags & RX_ENC_FLAG_10MHZ)
+		if (status->bw == RATE_INFO_BW_10)
 			shift = 1;
-		else if (status->enc_flags & RX_ENC_FLAG_5MHZ)
+		else if (status->bw == RATE_INFO_BW_5)
 			shift = 2;
 		*pos = DIV_ROUND_UP(rate->bitrate, 5 * (1 << shift));
 	}
@@ -356,14 +356,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_CHANNEL */
 	put_unaligned_le16(status->freq, pos);
 	pos += 2;
-	if (status->enc_flags & RX_ENC_FLAG_10MHZ)
+	if (status->bw == RATE_INFO_BW_10)
 		channel_flags |= IEEE80211_CHAN_HALF;
-	else if (status->enc_flags & RX_ENC_FLAG_5MHZ)
+	else if (status->bw == RATE_INFO_BW_5)
 		channel_flags |= IEEE80211_CHAN_QUARTER;
 
 	if (status->band == NL80211_BAND_5GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
-	else if (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT))
+	else if (status->encoding != RX_ENC_LEGACY)
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
@@ -402,7 +402,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
 
-	if (status->enc_flags & RX_ENC_FLAG_HT) {
+	if (status->encoding == RX_ENC_HT) {
 		unsigned int stbc;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
@@ -410,7 +410,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = 0;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
-		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
+		if (status->bw == RATE_INFO_BW_40)
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
 		if (status->enc_flags & RX_ENC_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
@@ -449,7 +449,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = 0;
 	}
 
-	if (status->enc_flags & RX_ENC_FLAG_VHT) {
+	if (status->encoding == RX_ENC_VHT) {
 		u16 known = local->hw.radiotap_vht_details;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
@@ -465,14 +465,19 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_BEAMFORMED;
 		pos++;
 		/* bandwidth */
-		if (status->enc_flags & RX_ENC_FLAG_80MHZ)
+		switch (status->bw) {
+		case RATE_INFO_BW_80:
 			*pos++ = 4;
-		else if (status->enc_flags & RX_ENC_FLAG_160MHZ)
+			break;
+		case RATE_INFO_BW_160:
 			*pos++ = 11;
-		else if (status->enc_flags & RX_ENC_FLAG_40MHZ)
+			break;
+		case RATE_INFO_BW_40:
 			*pos++ = 1;
-		else /* 20 MHz */
+			break;
+		default:
 			*pos++ = 0;
+		}
 		/* MCS/NSS */
 		*pos = (status->rate_idx << 4) | status->vht_nss;
 		pos += 4;
@@ -3336,8 +3341,8 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
-		if (!(status->enc_flags & RX_ENC_FLAG_HT) &&
-		    !(status->enc_flags & RX_ENC_FLAG_VHT))
+		if (!(status->encoding == RX_ENC_HT) &&
+		    !(status->encoding == RX_ENC_VHT))
 			rate = &sband->bitrates[status->rate_idx];
 
 		ieee80211_rx_cooked_monitor(rx, rate);
@@ -3598,7 +3603,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 			return false;
 		if (!rx->sta) {
 			int rate_idx;
-			if (status->enc_flags & (RX_ENC_FLAG_HT | RX_ENC_FLAG_VHT))
+			if (status->encoding != RX_ENC_LEGACY)
 				rate_idx = 0; /* TODO: HT/VHT rates */
 			else
 				rate_idx = status->rate_idx;
@@ -3618,7 +3623,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 			return false;
 		if (!rx->sta) {
 			int rate_idx;
-			if (status->enc_flags & RX_ENC_FLAG_HT)
+			if (status->encoding != RX_ENC_LEGACY)
 				rate_idx = 0; /* TODO: HT rates */
 			else
 				rate_idx = status->rate_idx;
@@ -4281,7 +4286,8 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 		 * we probably can't have a valid rate here anyway.
 		 */
 
-		if (status->enc_flags & RX_ENC_FLAG_HT) {
+		switch (status->encoding) {
+		case RX_ENC_HT:
 			/*
 			 * rate_idx is MCS index, which can be [0-76]
 			 * as documented on:
@@ -4299,14 +4305,19 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				 status->rate_idx,
 				 status->rate_idx))
 				goto drop;
-		} else if (status->enc_flags & RX_ENC_FLAG_VHT) {
+			break;
+		case RX_ENC_VHT:
 			if (WARN_ONCE(status->rate_idx > 9 ||
 				      !status->vht_nss ||
 				      status->vht_nss > 8,
 				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
 				      status->rate_idx, status->vht_nss))
 				goto drop;
-		} else {
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			/* fall through */
+		case RX_ENC_LEGACY:
 			if (WARN_ON(status->rate_idx >= sband->n_bitrates))
 				goto drop;
 			rate = &sband->bitrates[status->rate_idx];
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f693ca0e0858..0b16e2e8dc9e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -79,9 +79,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss_meta.signal = (rx_status->signal * 100) / local->hw.max_signal;
 
 	bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_20;
-	if (rx_status->enc_flags & RX_ENC_FLAG_5MHZ)
+	if (rx_status->bw == RATE_INFO_BW_5)
 		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_5;
-	if (rx_status->enc_flags & RX_ENC_FLAG_10MHZ)
+	else if (rx_status->bw == RATE_INFO_BW_10)
 		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
 	bss_meta.chan = channel;
@@ -174,8 +174,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (beacon) {
 		struct ieee80211_supported_band *sband =
 			local->hw.wiphy->bands[rx_status->band];
-		if (!(rx_status->enc_flags & RX_ENC_FLAG_HT) &&
-		    !(rx_status->enc_flags & RX_ENC_FLAG_VHT))
+		if (!(rx_status->encoding == RX_ENC_HT) &&
+		    !(rx_status->encoding == RX_ENC_VHT))
 			bss->beacon_rate =
 				&sband->bitrates[rx_status->rate_idx];
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 22b8e0250fc6..c7f259409187 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1,7 +1,7 @@
 /*
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright(c) 2015-2016 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -740,28 +740,25 @@ static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 {
 	u16 r = s->rate_idx;
 
-	if (s->enc_flags & RX_ENC_FLAG_80MHZ)
-		r |= RATE_INFO_BW_80 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->enc_flags & RX_ENC_FLAG_160MHZ)
-		r |= RATE_INFO_BW_160 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->enc_flags & RX_ENC_FLAG_40MHZ)
-		r |= RATE_INFO_BW_40 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->enc_flags & RX_ENC_FLAG_10MHZ)
-		r |= RATE_INFO_BW_10 << STA_STATS_RATE_BW_SHIFT;
-	else if (s->enc_flags & RX_ENC_FLAG_5MHZ)
-		r |= RATE_INFO_BW_5 << STA_STATS_RATE_BW_SHIFT;
-	else
-		r |= RATE_INFO_BW_20 << STA_STATS_RATE_BW_SHIFT;
+	r |= s->bw << STA_STATS_RATE_BW_SHIFT;
 
 	if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
 		r |= STA_STATS_RATE_SGI;
 
-	if (s->enc_flags & RX_ENC_FLAG_VHT)
+	switch (s->encoding) {
+	case RX_ENC_VHT:
 		r |= STA_STATS_RATE_TYPE_VHT | (s->vht_nss << 4);
-	else if (s->enc_flags & RX_ENC_FLAG_HT)
+		break;
+	case RX_ENC_HT:
 		r |= STA_STATS_RATE_TYPE_HT;
-	else
+		break;
+	default:
+		WARN_ON(1);
+		/* fall through */
+	case RX_ENC_LEGACY:
 		r |= STA_STATS_RATE_TYPE_LEGACY | (s->band << 4);
+		break;
+	}
 
 	return r;
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ca198d153d72..e9c28904998b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015-2016	Intel Deutschland GmbH
+ * Copyright (C) 2015-2017	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2715,42 +2715,39 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	memset(&ri, 0, sizeof(ri));
 
 	/* Fill cfg80211 rate info */
-	if (status->enc_flags & RX_ENC_FLAG_HT) {
+	switch (status->encoding) {
+	case RX_ENC_HT:
 		ri.mcs = status->rate_idx;
 		ri.flags |= RATE_INFO_FLAGS_MCS;
-		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
-			ri.bw = RATE_INFO_BW_40;
-		else
-			ri.bw = RATE_INFO_BW_20;
+		ri.bw = status->bw;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	} else if (status->enc_flags & RX_ENC_FLAG_VHT) {
+		break;
+	case RX_ENC_VHT:
 		ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
 		ri.mcs = status->rate_idx;
 		ri.nss = status->vht_nss;
-		if (status->enc_flags & RX_ENC_FLAG_40MHZ)
-			ri.bw = RATE_INFO_BW_40;
-		else if (status->enc_flags & RX_ENC_FLAG_80MHZ)
-			ri.bw = RATE_INFO_BW_80;
-		else if (status->enc_flags & RX_ENC_FLAG_160MHZ)
-			ri.bw = RATE_INFO_BW_160;
-		else
-			ri.bw = RATE_INFO_BW_20;
+		ri.bw = status->bw;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	} else {
+		break;
+	default:
+		WARN_ON(1);
+		/* fall through */
+	case RX_ENC_LEGACY: {
 		struct ieee80211_supported_band *sband;
 		int shift = 0;
 		int bitrate;
 
-		if (status->enc_flags & RX_ENC_FLAG_10MHZ) {
+		ri.bw = status->bw;
+
+		switch (status->bw) {
+		case RATE_INFO_BW_10:
 			shift = 1;
-			ri.bw = RATE_INFO_BW_10;
-		} else if (status->enc_flags & RX_ENC_FLAG_5MHZ) {
+			break;
+		case RATE_INFO_BW_5:
 			shift = 2;
-			ri.bw = RATE_INFO_BW_5;
-		} else {
-			ri.bw = RATE_INFO_BW_20;
+			break;
 		}
 
 		sband = local->hw.wiphy->bands[status->band];
@@ -2768,6 +2765,8 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 				ts += 192;
 			}
 		}
+		break;
+		}
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
-- 
2.11.0
