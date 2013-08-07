Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38328 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3HGH2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:28:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 2/2] ath9k: Run the LNA combining algorithm properly
Date: Wed,  7 Aug 2013 12:54:30 +0530
Message-Id: <1375860270-5839-1-git-send-email-sujith@msujith.org> (sfid-20130807_092809_175916_6EFCBCD6)
In-Reply-To: <1375858768-24655-3-git-send-email-sujith@msujith.org>
References: <1375858768-24655-3-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The LNA combining algorithm has to be run for cards
that support the required diversity features, make
sure that that correct conditions are met before
enabing this algorithm.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2 : Fix a misplaced semicolon

 drivers/net/wireless/ath/ath9k/recv.c | 44 ++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 865e043..62dff97 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1157,6 +1157,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct sk_buff *skb = NULL, *requeue_skb, *hdr_skb;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
@@ -1328,11 +1329,30 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			skb = hdr_skb;
 		}
 
+		if (rxs->flag & RX_FLAG_MMIC_STRIPPED)
+			skb_trim(skb, skb->len - 8);
 
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
+		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
+				     PS_WAIT_FOR_CAB |
+				     PS_WAIT_FOR_PSPOLL_DATA)) ||
+		    ath9k_check_auto_sleep(sc))
+			ath_rx_ps(sc, skb, rs.is_mybeacon);
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
+		/*
+		 * Run the LNA combining algorithm only in these cases:
+		 *
+		 * Standalone WLAN cards with both LNA/Antenna diversity
+		 * enabled in the EEPROM.
+		 *
+		 * WLAN+BT cards which are in the supported card list
+		 * in ath_pci_id_table and the user has loaded the
+		 * driver with "bt_ant_diversity" set to true.
+		 */
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
 			/*
-			 * change the default rx antenna if rx diversity
+			 * Change the default rx antenna if rx diversity
 			 * chooses the other antenna 3 times in a row.
 			 */
 			if (sc->rx.defant != rs.rs_antenna) {
@@ -1342,22 +1362,14 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 				sc->rx.rxotherant = 0;
 			}
 
+			if (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV) {
+				if (common->bt_ant_diversity)
+					ath_ant_comb_scan(sc, &rs);
+			} else {
+				ath_ant_comb_scan(sc, &rs);
+			}
 		}
 
-		if (rxs->flag & RX_FLAG_MMIC_STRIPPED)
-			skb_trim(skb, skb->len - 8);
-
-		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
-				     PS_WAIT_FOR_CAB |
-				     PS_WAIT_FOR_PSPOLL_DATA)) ||
-		    ath9k_check_auto_sleep(sc))
-			ath_rx_ps(sc, skb, rs.is_mybeacon);
-		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-
-		if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
-			ath_ant_comb_scan(sc, &rs);
-
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 
 		ieee80211_rx(hw, skb);
-- 
1.8.3.4

