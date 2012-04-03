Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37091 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2DCQTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:19:18 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath9k:  Add more recv stats.
Date: Tue,  3 Apr 2012 09:18:59 -0700
Message-Id: <1333469939-26213-1-git-send-email-greearb@candelatech.com> (sfid-20120403_181921_768166_B05FE4E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This adds counters in various places that can drop packets on
rx without otherwise incrementing a counter.  It also counts
some non-error cases, such as becons and fragments received.

Should help with figuring out where packets are (and are not)
dropped.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 9078279... 244723a... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 d1c132f... 56a7053... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 1c4583c... ad2b2b6... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/debug.c |   23 +++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/debug.h |   18 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c  |   35 +++++++++++++++++++++++--------
 3 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9078279..244723a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -916,6 +916,21 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, size - len,
 			"%22s : %10u\n", "DECRYPT BUSY ERR",
 			sc->debug.stats.rxstats.decrypt_busy_err);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-LENGTH-ERR",
+			sc->debug.stats.rxstats.rx_len_err);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-OOM-ERR",
+			sc->debug.stats.rxstats.rx_oom_err);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-RATE-ERR",
+			sc->debug.stats.rxstats.rx_rate_err);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-DROP-RXFLUSH",
+			sc->debug.stats.rxstats.rx_drop_rxflush);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-TOO-MANY-FRAGS",
+			sc->debug.stats.rxstats.rx_too_many_frags_err);
 
 	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
 	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
@@ -950,6 +965,12 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, size - len,
 			"%22s : %10u\n", "RX-Bytes-All",
 			sc->debug.stats.rxstats.rx_bytes_all);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-Beacons",
+			sc->debug.stats.rxstats.rx_beacons);
+	len += snprintf(buf + len, size - len,
+			"%22s : %10u\n", "RX-Frags",
+			sc->debug.stats.rxstats.rx_frags);
 
 	if (len > size)
 		len = size;
@@ -964,7 +985,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
-#define RX_STAT_INC(c) sc->debug.stats.rxstats.c++
 #define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
 #define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
 			[sc->debug.rsidx].c)
@@ -1010,7 +1030,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 #endif
 
-#undef RX_STAT_INC
 #undef RX_PHY_ERR_INC
 #undef RX_SAMP_DBG
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index d1c132f..56a7053 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -139,6 +139,8 @@ struct ath_tx_stats {
 	u32 txfailed;
 };
 
+#define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
+
 /**
  * struct ath_rx_stats - RX Statistics
  * @rx_pkts_all:  No. of total frames received, including ones that
@@ -155,6 +157,13 @@ struct ath_tx_stats {
  * @post_delim_crc_err: Post-Frame delimiter CRC error detections
  * @decrypt_busy_err: Decryption interruptions counter
  * @phy_err_stats: Individual PHY error statistics
+ * @rx_len_err:  No. of frames discarded due to bad length.
+ * @rx_oom_err:  No. of frames dropped due to OOM issues.
+ * @rx_rate_err:  No. of frames dropped due to rate errors.
+ * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
+ * @rx_drop_rxflush: No. of frames dropped due to RX-FLUSH.
+ * @rx_beacons:  No. of beacons received.
+ * @rx_frags:  No. of rx-fragements received.
  */
 struct ath_rx_stats {
 	u32 rx_pkts_all;
@@ -167,6 +176,13 @@ struct ath_rx_stats {
 	u32 post_delim_crc_err;
 	u32 decrypt_busy_err;
 	u32 phy_err_stats[ATH9K_PHYERR_MAX];
+	u32 rx_len_err;
+	u32 rx_oom_err;
+	u32 rx_rate_err;
+	u32 rx_too_many_frags_err;
+	u32 rx_drop_rxflush;
+	u32 rx_beacons;
+	u32 rx_frags;
 };
 
 enum ath_reset_type {
@@ -249,6 +265,8 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #else
 
+#define RX_STAT_INC(c) /* NOP */
+
 static inline int ath9k_init_debug(struct ath_hw *ah)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1c4583c..ad2b2b6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -824,15 +824,20 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
-	if (!rx_stats->rs_datalen)
+	if (!rx_stats->rs_datalen) {
+		RX_STAT_INC(rx_len_err);
 		return false;
+	}
+
         /*
          * rs_status follows rs_datalen so if rs_datalen is too large
          * we can take a hint that hardware corrupted it, so ignore
          * those frames.
          */
-	if (rx_stats->rs_datalen > (common->rx_bufsize - rx_status_len))
+	if (rx_stats->rs_datalen > (common->rx_bufsize - rx_status_len)) {
+		RX_STAT_INC(rx_len_err);
 		return false;
+	}
 
 	/* Only use error bits from the last fragment */
 	if (rx_stats->rs_more)
@@ -902,6 +907,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band;
 	unsigned int i = 0;
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
 	band = hw->conf.channel->band;
 	sband = hw->wiphy->bands[band];
@@ -936,7 +942,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	ath_dbg(common, ANY,
 		"unsupported hw bitrate detected 0x%02x using 1 Mbit\n",
 		rx_stats->rs_rate);
-
+	RX_STAT_INC(rx_rate_err);
 	return -EINVAL;
 }
 
@@ -1823,10 +1829,14 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		hdr = (struct ieee80211_hdr *) (hdr_skb->data + rx_status_len);
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
-		if (ieee80211_is_beacon(hdr->frame_control) &&
-		    !is_zero_ether_addr(common->curbssid) &&
-		    !compare_ether_addr(hdr->addr3, common->curbssid))
-			rs.is_mybeacon = true;
+		if (ieee80211_is_beacon(hdr->frame_control)) {
+			RX_STAT_INC(rx_beacons);
+			if (!is_zero_ether_addr(common->curbssid) &&
+			    !compare_ether_addr(hdr->addr3, common->curbssid))
+				rs.is_mybeacon = true;
+			else
+				rs.is_mybeacon = false;
+		}
 		else
 			rs.is_mybeacon = false;
 
@@ -1836,8 +1846,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		 * If we're asked to flush receive queue, directly
 		 * chain it back at the queue without processing it.
 		 */
-		if (sc->sc_flags & SC_OP_RXFLUSH)
+		if (sc->sc_flags & SC_OP_RXFLUSH) {
+			RX_STAT_INC(rx_drop_rxflush);
 			goto requeue_drop_frag;
+		}
 
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
@@ -1863,8 +1875,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		 * tell hardware it can give us a new frame using the old
 		 * skb and put it at the tail of the sc->rx.rxbuf list for
 		 * processing. */
-		if (!requeue_skb)
+		if (!requeue_skb) {
+			RX_STAT_INC(rx_oom_err);
 			goto requeue_drop_frag;
+		}
 
 		/* Unmap the frame */
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
@@ -1895,6 +1909,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		}
 
 		if (rs.rs_more) {
+			RX_STAT_INC(rx_frags);
 			/*
 			 * rs_more indicates chained descriptors which can be
 			 * used to link buffers together for a sort of
@@ -1904,6 +1919,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 				/* too many fragments - cannot handle frame */
 				dev_kfree_skb_any(sc->rx.frag);
 				dev_kfree_skb_any(skb);
+				RX_STAT_INC(rx_too_many_frags_err);
 				skb = NULL;
 			}
 			sc->rx.frag = skb;
@@ -1915,6 +1931,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 			if (pskb_expand_head(hdr_skb, 0, space, GFP_ATOMIC) < 0) {
 				dev_kfree_skb(skb);
+				RX_STAT_INC(rx_oom_err);
 				goto requeue_drop_frag;
 			}
 
-- 
1.7.3.4

