Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/29] ath9k: move RX check code into helper ath9k_rx_accept()
Date: Sat,  7 Nov 2009 15:18:50 -0500
Message-Id: <1257625146-17971-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This does sanity checking on the skb and RX status descriptor
prior to processing.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   63 +++++++++++++++++++++-----------
 1 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fa78914..6e00eaf 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -86,28 +86,19 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 	sc->rx.rxotherant = 0;
 }
 
-/*
- * For Decrypt or Demic errors, we only mark packet status here and always push
- * up the frame up to let mac80211 handle the actual error case, be it no
- * decryption key or real decryption error. This let us keep statistics there.
- */
-static int ath_rx_prepare(struct ath_common *common,
-			  struct ieee80211_hw *hw,
-			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
-			  struct ieee80211_rx_status *rx_status,
-			  bool *decrypt_error)
+/* Assumes you've already done the endian to CPU conversion */
+static bool ath9k_rx_accept(struct ath_common *common,
+			    struct sk_buff *skb,
+			    struct ieee80211_rx_status *rxs,
+			    struct ath_rx_status *rx_stats,
+			    bool *decrypt_error)
 {
 	struct ath_hw *ah = common->ah;
 	struct ieee80211_hdr *hdr;
-	u8 ratecode;
 	__le16 fc;
-	struct ieee80211_sta *sta;
-	struct ath_node *an;
-	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
 	if (rx_stats->rs_more) {
 		/*
@@ -117,12 +108,12 @@ static int ath_rx_prepare(struct ath_common *common,
 		 * error frames in Monitor mode.
 		 */
 		if (ah->opmode != NL80211_IFTYPE_MONITOR)
-			goto rx_next;
+			return false;
 	} else if (rx_stats->rs_status != 0) {
 		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
-			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
 		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
-			goto rx_next;
+			return false;
 
 		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
 			*decrypt_error = true;
@@ -135,7 +126,7 @@ static int ath_rx_prepare(struct ath_common *common,
 				 */
 				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
 			else
-				rx_status->flag |= RX_FLAG_MMIC_ERROR;
+				rxs->flag |= RX_FLAG_MMIC_ERROR;
 		}
 		/*
 		 * Reject error frames with the exception of
@@ -146,14 +137,42 @@ static int ath_rx_prepare(struct ath_common *common,
 			if (rx_stats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
-				goto rx_next;
+				return false;
 		} else {
 			if (rx_stats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-				goto rx_next;
+				return false;
 			}
 		}
 	}
+	return true;
+}
+
+/*
+ * For Decrypt or Demic errors, we only mark packet status here and always push
+ * up the frame up to let mac80211 handle the actual error case, be it no
+ * decryption key or real decryption error. This let us keep statistics there.
+ */
+static int ath_rx_prepare(struct ath_common *common,
+			  struct ieee80211_hw *hw,
+			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
+			  struct ieee80211_rx_status *rx_status,
+			  bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	u8 ratecode;
+	__le16 fc;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
+	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
+		goto rx_next;
 
 	ratecode = rx_stats->rs_rate;
 
-- 
1.6.5.2.143.g8cc62

