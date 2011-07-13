Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37016 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab1GMPf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 11:35:29 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	senthilb@qca.qualcomm.com
Subject: [PATCH v3] ath9k: improve reliability of MIC error detection
Date: Wed, 13 Jul 2011 23:35:05 +0800
Message-Id: <1310571305-1363-1-git-send-email-nbd@openwrt.org> (sfid-20110713_173537_503557_98B7498C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For unicast the hardware sometimes reports MIC errors even though the
frame that it received actually contains a valid MIC - on some chips this
can happen frequently enough to trigger TKIP countermeasures.
Fix this issue by not reporting MIC errors for unicast frames with a
valid key, letting mac80211 validate the MIC instead.

Additionally, strip the MIC for all frames that the hardware considers
valid to avoid wasting CPU cycles re-validating it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   53 ++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 80bb04f..d32e82f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -814,16 +814,19 @@ static bool ath9k_rx_accept(struct ath_common *common,
 			    struct ath_rx_status *rx_stats,
 			    bool *decrypt_error)
 {
-#define is_mc_or_valid_tkip_keyix ((is_mc ||			\
-		(rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID && \
-		test_bit(rx_stats->rs_keyix, common->tkip_keymap))))
-
+	bool is_mc, is_valid_tkip, strip_mic, mic_error;
 	struct ath_hw *ah = common->ah;
 	__le16 fc;
 	u8 rx_status_len = ah->caps.rx_status_len;
 
 	fc = hdr->frame_control;
 
+	is_mc = !!is_multicast_ether_addr(hdr->addr1);
+	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
+		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
+	strip_mic = is_valid_tkip && !(rx_stats->rs_status &
+		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC));
+
 	if (!rx_stats->rs_datalen)
 		return false;
         /*
@@ -838,6 +841,11 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	if (rx_stats->rs_more)
 		return true;
 
+	mic_error = is_valid_tkip && !ieee80211_is_ctl(fc) &&
+		!ieee80211_has_morefrags(fc) &&
+		!(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
+		(rx_stats->rs_status & ATH9K_RXERR_MIC);
+
 	/*
 	 * The rx_stats->rs_status will not be set until the end of the
 	 * chained descriptors so it can be ignored if rs_more is set. The
@@ -845,30 +853,18 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	 * descriptors.
 	 */
 	if (rx_stats->rs_status != 0) {
-		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
+		if (rx_stats->rs_status & ATH9K_RXERR_CRC) {
 			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
+			mic_error = false;
+		}
 		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
 			return false;
 
 		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
 			*decrypt_error = true;
-		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
-			bool is_mc;
-			/*
-			 * The MIC error bit is only valid if the frame
-			 * is not a control frame or fragment, and it was
-			 * decrypted using a valid TKIP key.
-			 */
-			is_mc = !!is_multicast_ether_addr(hdr->addr1);
-
-			if (!ieee80211_is_ctl(fc) &&
-			    !ieee80211_has_morefrags(fc) &&
-			    !(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
-			    is_mc_or_valid_tkip_keyix)
-				rxs->flag |= RX_FLAG_MMIC_ERROR;
-			else
-				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
+			mic_error = false;
 		}
+
 		/*
 		 * Reject error frames with the exception of
 		 * decryption and MIC failures. For monitor mode,
@@ -886,6 +882,18 @@ static bool ath9k_rx_accept(struct ath_common *common,
 			}
 		}
 	}
+
+	/*
+	 * For unicast frames the MIC error bit can have false positives,
+	 * so all MIC error reports need to be validated in software.
+	 * False negatives are not common, so skip software verification
+	 * if the hardware considers the MIC valid.
+	 */
+	if (strip_mic)
+		rxs->flag |= RX_FLAG_MMIC_STRIPPED;
+	else if (is_mc && mic_error)
+		rxs->flag |= RX_FLAG_MMIC_ERROR;
+
 	return true;
 }
 
@@ -1938,6 +1946,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.rxotherant = 0;
 		}
 
+		if (rxs->flag & RX_FLAG_MMIC_STRIPPED)
+			skb_trim(skb, skb->len - 8);
+
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
 
 		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
-- 
1.7.3.2

