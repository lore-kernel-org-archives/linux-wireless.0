Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39915 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab3HNPti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:49:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Optimize LNA check
Date: Wed, 14 Aug 2013 21:15:56 +0530
Message-Id: <1376495157-18983-3-git-send-email-sujith@msujith.org> (sfid-20130814_174946_597380_52B6AC70)
In-Reply-To: <1376495157-18983-1-git-send-email-sujith@msujith.org>
References: <1376495157-18983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The documentation for antenna diversity says:

"The decision of diversity is done at 802.11 preamble. So, for
11G/11B, for every MAC packet hardware will do a decision. But in
11N with aggregation, the decision is made only at the preamble and
all other MPDUs will use the same LNA as the first MPDU."

Make use of rs_firstaggr to avoid needlessly scanning for LNA
changes.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 77 +++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6ad7d61..6161d14 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1238,6 +1238,52 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
+/*
+ * Run the LNA combining algorithm only in these cases:
+ *
+ * Standalone WLAN cards with both LNA/Antenna diversity
+ * enabled in the EEPROM.
+ *
+ * WLAN+BT cards which are in the supported card list
+ * in ath_pci_id_table and the user has loaded the
+ * driver with "bt_ant_diversity" set to true.
+ */
+static void ath9k_antenna_check(struct ath_softc *sc,
+				struct ath_rx_status *rs)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB))
+		return;
+
+	/*
+	 * All MPDUs in an aggregate will use the same LNA
+	 * as the first MPDU.
+	 */
+	if (rs->rs_isaggr && !rs->rs_firstaggr)
+		return;
+
+	/*
+	 * Change the default rx antenna if rx diversity
+	 * chooses the other antenna 3 times in a row.
+	 */
+	if (sc->rx.defant != rs->rs_antenna) {
+		if (++sc->rx.rxotherant >= 3)
+			ath_setdefantenna(sc, rs->rs_antenna);
+	} else {
+		sc->rx.rxotherant = 0;
+	}
+
+	if (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV) {
+		if (common->bt_ant_diversity)
+			ath_ant_comb_scan(sc, rs);
+	} else {
+		ath_ant_comb_scan(sc, rs);
+	}
+}
+
 static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	struct ath_rx_status *rs, struct ieee80211_rx_status *rxs)
 {
@@ -1262,7 +1308,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct sk_buff *skb = NULL, *requeue_skb, *hdr_skb;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hw *hw = sc->hw;
 	int retval;
@@ -1398,35 +1443,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			ath_rx_ps(sc, skb, rs.is_mybeacon);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-		/*
-		 * Run the LNA combining algorithm only in these cases:
-		 *
-		 * Standalone WLAN cards with both LNA/Antenna diversity
-		 * enabled in the EEPROM.
-		 *
-		 * WLAN+BT cards which are in the supported card list
-		 * in ath_pci_id_table and the user has loaded the
-		 * driver with "bt_ant_diversity" set to true.
-		 */
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
-			/*
-			 * Change the default rx antenna if rx diversity
-			 * chooses the other antenna 3 times in a row.
-			 */
-			if (sc->rx.defant != rs.rs_antenna) {
-				if (++sc->rx.rxotherant >= 3)
-					ath_setdefantenna(sc, rs.rs_antenna);
-			} else {
-				sc->rx.rxotherant = 0;
-			}
-
-			if (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV) {
-				if (common->bt_ant_diversity)
-					ath_ant_comb_scan(sc, &rs);
-			} else {
-				ath_ant_comb_scan(sc, &rs);
-			}
-		}
+		ath9k_antenna_check(sc, &rs);
 
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 
-- 
1.8.3.4

