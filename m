Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41767 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3HGHDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:03:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/2] ath9k: Run the LNA combining algorithm properly
Date: Wed,  7 Aug 2013 12:29:28 +0530
Message-Id: <1375858768-24655-3-git-send-email-sujith@msujith.org> (sfid-20130807_090315_166597_BDDC66DB)
In-Reply-To: <1375858768-24655-1-git-send-email-sujith@msujith.org>
References: <1375858768-24655-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The LNA combining algorithm has to be run for cards
that support the required diversity features, make
sure that that correct conditions are met before
enabing this algorithm.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 46 ++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 865e043..e359557 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1156,7 +1156,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct ath_buf *bf;
 	struct sk_buff *skb = NULL, *requeue_skb, *hdr_skb;
 	struct ieee80211_rx_status *rxs;
-	struct ath_hw *ah = sc->sc_ah;
+	struct ath_hw *ah = sc->sc_ah
+;	struct ath9k_hw_capabilities *pCap = &ah->caps;
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

