Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:54876 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab3AWQiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 11:38:25 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, sven@open-mesh.com,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/4] ath9k: drop spectral packets after processing them
Date: Wed, 23 Jan 2013 17:38:05 +0100
Message-Id: <1358959087-24897-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130123_173832_941289_394C6133)
In-Reply-To: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spectral packets are "bogus" packets and should not be further evaluated
by the RX path.

Statistics are added to keep track of these packets.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/debug.c |    1 +
 drivers/net/wireless/ath/ath9k/debug.h |    2 ++
 drivers/net/wireless/ath/ath9k/recv.c  |   37 +++++++++++++++++++-------------
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 012446d..2bbdcf8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -895,6 +895,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("RX-Bytes-All", rx_bytes_all);
 	RXS_ERR("RX-Beacons", rx_beacons);
 	RXS_ERR("RX-Frags", rx_frags);
+	RXS_ERR("RX-Spectral", rx_spectral);
 
 	if (len > size)
 		len = size;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a22c0d7..410d6d8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -219,6 +219,7 @@ struct ath_tx_stats {
  * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
  * @rx_beacons:  No. of beacons received.
  * @rx_frags:  No. of rx-fragements received.
+ * @rx_spectral: No of spectral packets received.
  */
 struct ath_rx_stats {
 	u32 rx_pkts_all;
@@ -237,6 +238,7 @@ struct ath_rx_stats {
 	u32 rx_too_many_frags_err;
 	u32 rx_beacons;
 	u32 rx_frags;
+	u32 rx_spectral;
 };
 
 struct ath_stats {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d7c129b..13ee37b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1023,9 +1023,9 @@ static s8 fix_rssi_inv_only(u8 rssi_val)
 	return (s8) rssi_val;
 }
 
-
-static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
-			    struct ath_rx_status *rs, u64 tsf)
+/* returns 1 if this was a spectral frame, even if not handled. */
+static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+			   struct ath_rx_status *rs, u64 tsf)
 {
 #ifdef CONFIG_ATH_DEBUG
 	struct ath_hw *ah = sc->sc_ah;
@@ -1044,7 +1044,14 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
 	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
 	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
-		return;
+		return 0;
+
+	/* check if spectral scan bit is set. This does not have to be checked
+	 * if received through a SPECTRAL phy error, but shouldn't hurt.
+	 */
+	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
+	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
+		return 0;
 
 	/* Variation in the data length is possible and will be fixed later.
 	 * Note that we only support HT20 for now.
@@ -1053,14 +1060,7 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	 */
 	if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
 	    (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
-		return;
-
-	/* check if spectral scan bit is set. This does not have to be checked
-	 * if received through a SPECTRAL phy error, but shouldn't hurt.
-	 */
-	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
-	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
-		return;
+		return 1;
 
 	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
 	fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
@@ -1093,7 +1093,7 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
 		break;
 	default:
-		return;
+		return 1;
 	}
 
 	/* DC value (value in the middle) is the blind spot of the spectral
@@ -1115,6 +1115,9 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	fft_sample.tsf = tsf;
 
 	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
+	return 1;
+#else
+	return 0;
 #endif
 }
 
@@ -1202,8 +1205,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
-		if ((rs.rs_status & ATH9K_RXERR_PHY))
-			ath_process_fft(sc, hdr, &rs, rxs->mactime);
+		if (rs.rs_status & ATH9K_RXERR_PHY) {
+			if (ath_process_fft(sc, hdr, &rs, rxs->mactime)) {
+				RX_STAT_INC(rx_spectral);
+				goto requeue_drop_frag;
+			}
+		}
 
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
-- 
1.7.10.4

