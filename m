Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48979 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3LNRD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 02/11] ath9k: add support for reporting per-chain signal strength
Date: Sat, 14 Dec 2013 18:03:36 +0100
Message-Id: <1387040625-38114-2-git-send-email-nbd@openwrt.org> (sfid-20131214_180420_188845_920F6C52)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/antenna.c    |  8 ++++----
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 12 ++++++------
 drivers/net/wireless/ath/ath9k/dfs.c        |  4 ++--
 drivers/net/wireless/ath/ath9k/mac.c        | 24 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/mac.h        |  8 ++------
 drivers/net/wireless/ath/ath9k/recv.c       | 25 ++++++++++++++++++++-----
 6 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index bd048cc..a366843 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -724,14 +724,14 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	struct ath_ant_comb *antcomb = &sc->ant_comb;
 	int alt_ratio = 0, alt_rssi_avg = 0, main_rssi_avg = 0, curr_alt_set;
 	int curr_main_set;
-	int main_rssi = rs->rs_rssi_ctl0;
-	int alt_rssi = rs->rs_rssi_ctl1;
+	int main_rssi = rs->rs_rssi_ctl[0];
+	int alt_rssi = rs->rs_rssi_ctl[1];
 	int rx_ant_conf,  main_ant_conf;
 	bool short_scan = false, ret;
 
-	rx_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_CURRENT_SHIFT) &
+	rx_ant_conf = (rs->rs_rssi_ctl[2] >> ATH_ANT_RX_CURRENT_SHIFT) &
 		       ATH_ANT_RX_MASK;
-	main_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_MAIN_SHIFT) &
+	main_ant_conf = (rs->rs_rssi_ctl[2] >> ATH_ANT_RX_MAIN_SHIFT) &
 			 ATH_ANT_RX_MASK;
 
 	if (alt_rssi >= antcomb->low_rssi_thresh) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index f6c5c1b..6eb8657 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -476,12 +476,12 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 
 	/* XXX: Keycache */
 	rxs->rs_rssi = MS(rxsp->status5, AR_RxRSSICombined);
-	rxs->rs_rssi_ctl0 = MS(rxsp->status1, AR_RxRSSIAnt00);
-	rxs->rs_rssi_ctl1 = MS(rxsp->status1, AR_RxRSSIAnt01);
-	rxs->rs_rssi_ctl2 = MS(rxsp->status1, AR_RxRSSIAnt02);
-	rxs->rs_rssi_ext0 = MS(rxsp->status5, AR_RxRSSIAnt10);
-	rxs->rs_rssi_ext1 = MS(rxsp->status5, AR_RxRSSIAnt11);
-	rxs->rs_rssi_ext2 = MS(rxsp->status5, AR_RxRSSIAnt12);
+	rxs->rs_rssi_ctl[0] = MS(rxsp->status1, AR_RxRSSIAnt00);
+	rxs->rs_rssi_ctl[1] = MS(rxsp->status1, AR_RxRSSIAnt01);
+	rxs->rs_rssi_ctl[2] = MS(rxsp->status1, AR_RxRSSIAnt02);
+	rxs->rs_rssi_ext[0] = MS(rxsp->status5, AR_RxRSSIAnt10);
+	rxs->rs_rssi_ext[1] = MS(rxsp->status5, AR_RxRSSIAnt11);
+	rxs->rs_rssi_ext[2] = MS(rxsp->status5, AR_RxRSSIAnt12);
 
 	if (rxsp->status11 & AR_RxKeyIdxValid)
 		rxs->rs_keyix = MS(rxsp->status11, AR_KeyIdx);
diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 7187d36..857bb28 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -158,8 +158,8 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 		return;
 	}
 
-	ard.rssi = rs->rs_rssi_ctl0;
-	ard.ext_rssi = rs->rs_rssi_ext0;
+	ard.rssi = rs->rs_rssi_ctl[0];
+	ard.ext_rssi = rs->rs_rssi_ext[0];
 
 	/*
 	 * hardware stores this as 8 bit signed value.
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 6a18f9d..a850482 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -550,25 +550,25 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	if (ads.ds_rxstatus8 & AR_PostDelimCRCErr) {
 		rs->rs_rssi = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ctl0 = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ctl1 = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ctl2 = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ext0 = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ext1 = ATH9K_RSSI_BAD;
-		rs->rs_rssi_ext2 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl[0] = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl[1] = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl[2] = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext[0] = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext[1] = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext[2] = ATH9K_RSSI_BAD;
 	} else {
 		rs->rs_rssi = MS(ads.ds_rxstatus4, AR_RxRSSICombined);
-		rs->rs_rssi_ctl0 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi_ctl[0] = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt00);
-		rs->rs_rssi_ctl1 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi_ctl[1] = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt01);
-		rs->rs_rssi_ctl2 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi_ctl[2] = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt02);
-		rs->rs_rssi_ext0 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext[0] = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt10);
-		rs->rs_rssi_ext1 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext[1] = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt11);
-		rs->rs_rssi_ext2 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext[2] = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt12);
 	}
 	if (ads.ds_rxstatus8 & AR_RxKeyIdxValid)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index e3eed81..1027137 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -133,12 +133,8 @@ struct ath_rx_status {
 	u8 rs_rate;
 	u8 rs_antenna;
 	u8 rs_more;
-	int8_t rs_rssi_ctl0;
-	int8_t rs_rssi_ctl1;
-	int8_t rs_rssi_ctl2;
-	int8_t rs_rssi_ext0;
-	int8_t rs_rssi_ext1;
-	int8_t rs_rssi_ext2;
+	int8_t rs_rssi_ctl[3];
+	int8_t rs_rssi_ext[3];
 	u8 rs_isaggr;
 	u8 rs_firstaggr;
 	u8 rs_moreaggr;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 95ddca5..2410224 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -906,6 +906,7 @@ static void ath9k_process_rssi(struct ath_common *common,
 	struct ath_hw *ah = common->ah;
 	int last_rssi;
 	int rssi = rx_stats->rs_rssi;
+	int i, j;
 
 	/*
 	 * RSSI is not available for subframes in an A-MPDU.
@@ -924,6 +925,20 @@ static void ath9k_process_rssi(struct ath_common *common,
 		return;
 	}
 
+	for (i = 0, j = 0; i < ARRAY_SIZE(rx_stats->rs_rssi_ctl); i++) {
+		s8 rssi;
+
+		if (!(ah->rxchainmask & BIT(i)))
+			continue;
+
+		rssi = rx_stats->rs_rssi_ctl[i];
+		if (rssi != ATH9K_RSSI_BAD) {
+		    rxs->chains |= BIT(j);
+		    rxs->chain_signal[j] = ah->noise + rssi;
+		}
+		j++;
+	}
+
 	/*
 	 * Update Beacon RSSI, this is used by ANI.
 	 */
@@ -1073,14 +1088,14 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		fft_sample_40.channel_type = chan_type;
 
 		if (chan_type == NL80211_CHAN_HT40PLUS) {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext0);
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
 
 			fft_sample_40.lower_noise = ah->noise;
 			fft_sample_40.upper_noise = ext_nf;
 		} else {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext0);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
 
 			fft_sample_40.lower_noise = ext_nf;
 			fft_sample_40.upper_noise = ah->noise;
@@ -1116,7 +1131,7 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		fft_sample_20.tlv.length = __cpu_to_be16(length);
 		fft_sample_20.freq = __cpu_to_be16(freq);
 
-		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
 		fft_sample_20.noise = ah->noise;
 
 		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
-- 
1.8.3.4 (Apple Git-47)

