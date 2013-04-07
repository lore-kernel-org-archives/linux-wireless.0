Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58781 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934413Ab3DGWET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 5/7] ath9k: fix handling of broken descriptors
Date: Mon,  8 Apr 2013 00:04:11 +0200
Message-Id: <1365372253-32782-5-git-send-email-nbd@openwrt.org> (sfid-20130408_000429_224601_102E5091)
In-Reply-To: <1365372253-32782-4-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
 <1365372253-32782-2-git-send-email-nbd@openwrt.org>
 <1365372253-32782-3-git-send-email-nbd@openwrt.org>
 <1365372253-32782-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the comment in ath_get_next_rx_buf indicates, if a descriptor with
the done bit set follows one with the done bit cleared, both descriptors
should be discarded, however the driver is not doing that yet.

To fix this, use the rs->rs_more flag as an indicator that the following
frame should be discarded. This also helps with the split buffer case:
if the first part of the frame is discarded, the following parts need to
be discarded as well, since they contain no valid header or usable data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/recv.c  | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a56b241..86d3572 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -311,6 +311,7 @@ struct ath_rx_edma {
 struct ath_rx {
 	u8 defant;
 	u8 rxotherant;
+	bool discard_next;
 	u32 *rxlink;
 	u32 num_pkts;
 	unsigned int rxfilter;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1bc8030..0c6dc28 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -723,6 +723,13 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 		ret = ath9k_hw_rxprocdesc(ah, tds, &trs);
 		if (ret == -EINPROGRESS)
 			return NULL;
+
+		/*
+		 * mark descriptor as zero-length and set the 'more'
+		 * flag to ensure that both buffers get discarded
+		 */
+		rs->rs_datalen = 0;
+		rs->rs_more = true;
 	}
 
 	list_del(&bf->list);
@@ -929,14 +936,20 @@ static void ath9k_process_rssi(struct ath_common *common,
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
  */
-static int ath9k_rx_skb_preprocess(struct ath_common *common,
-				   struct ieee80211_hw *hw,
+static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 				   struct ieee80211_hdr *hdr,
 				   struct ath_rx_status *rx_stats,
 				   struct ieee80211_rx_status *rx_status,
 				   bool *decrypt_error)
 {
-	struct ath_hw *ah = common->ah;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	bool discard_current = sc->rx.discard_next;
+
+	sc->rx.discard_next = rx_stats->rs_more;
+	if (discard_current)
+		return -EINVAL;
 
 	/*
 	 * everything but the rate is checked here, the rate check is done
@@ -962,6 +975,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	if (rx_stats->rs_moreaggr)
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
+	sc->rx.discard_next = false;
 	return 0;
 }
 
@@ -1236,8 +1250,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			}
 		}
 
-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
+		retval = ath9k_rx_skb_preprocess(sc, hdr, &rs, rxs,
+						 &decrypt_error);
 		if (retval)
 			goto requeue_drop_frag;
 
-- 
1.8.0.2

