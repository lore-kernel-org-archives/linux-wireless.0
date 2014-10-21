Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40534 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbaJUNwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 09:52:33 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Enable HW queue control only for MCC
Date: Tue, 21 Oct 2014 19:23:02 +0530
Message-Id: <1413899582-5770-1-git-send-email-sujith@msujith.org> (sfid-20141021_155237_408074_200F0584)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Enabling HW queue control for normal (non-mcc) mode
causes problems with queue management, resulting
in traffic stall. Since it is mainly required for
fairness in MCC mode, disable it for the general case.

Bug: https://dev.openwrt.org/ticket/18164

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 55 +++++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/main.c |  3 ++
 drivers/net/wireless/ath/ath9k/xmit.c | 10 +++++--
 3 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 156a944..3bd0304 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -734,6 +734,32 @@ static const struct ieee80211_iface_combination if_comb[] = {
 #endif
 };
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+static void ath9k_set_mcc_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!ath9k_is_chanctx_enabled())
+		return;
+
+	hw->flags |= IEEE80211_HW_QUEUE_CONTROL;
+	hw->queues = ATH9K_NUM_TX_QUEUES;
+	hw->offchannel_tx_hw_queue = hw->queues - 1;
+	hw->wiphy->interface_modes &= ~ BIT(NL80211_IFTYPE_WDS);
+	hw->wiphy->iface_combinations = if_comb_multi;
+	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb_multi);
+	hw->wiphy->max_scan_ssids = 255;
+	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+	hw->wiphy->max_remain_on_channel_duration = 10000;
+	hw->chanctx_data_size = sizeof(void *);
+	hw->extra_beacon_tailroom =
+		sizeof(struct ieee80211_p2p_noa_attr) + 9;
+
+	ath_dbg(common, CHAN_CTX, "Use channel contexts\n");
+}
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
+
 static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -746,7 +772,6 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SUPPORTS_RC_TABLE |
-		IEEE80211_HW_QUEUE_CONTROL |
 		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
 	if (ath9k_ps_enable)
@@ -781,24 +806,6 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 	}
 
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
-
-	if (ath9k_is_chanctx_enabled()) {
-		hw->wiphy->interface_modes &= ~ BIT(NL80211_IFTYPE_WDS);
-		hw->wiphy->iface_combinations = if_comb_multi;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb_multi);
-		hw->wiphy->max_scan_ssids = 255;
-		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-		hw->wiphy->max_remain_on_channel_duration = 10000;
-		hw->chanctx_data_size = sizeof(void *);
-		hw->extra_beacon_tailroom =
-			sizeof(struct ieee80211_p2p_noa_attr) + 9;
-
-		ath_dbg(common, CHAN_CTX, "Use channel contexts\n");
-	}
-
-#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
-
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
@@ -808,12 +815,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
-	/* allow 4 queues per channel context +
-	 * 1 cab queue + 1 offchannel tx queue
-	 */
-	hw->queues = ATH9K_NUM_TX_QUEUES;
-	/* last queue for offchannel */
-	hw->offchannel_tx_hw_queue = hw->queues - 1;
+	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 10;
@@ -837,6 +839,9 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&common->sbands[IEEE80211_BAND_5GHZ];
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+	ath9k_set_mcc_capab(sc, hw);
+#endif
 	ath9k_init_wow(hw);
 	ath9k_cmn_reload_chainmask(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 68c5670..5122dea 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1182,6 +1182,9 @@ static void ath9k_assign_hw_queues(struct ieee80211_hw *hw,
 {
 	int i;
 
+	if (!ath9k_is_chanctx_enabled())
+		return;
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++)
 		vif->hw_queue[i] = i;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 493a183..d6e54a3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -169,7 +169,10 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 
 	if (txq->stopped &&
 	    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-		ieee80211_wake_queue(sc->hw, info->hw_queue);
+		if (ath9k_is_chanctx_enabled())
+			ieee80211_wake_queue(sc->hw, info->hw_queue);
+		else
+			ieee80211_wake_queue(sc->hw, q);
 		txq->stopped = false;
 	}
 }
@@ -2247,7 +2250,10 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		fi->txq = q;
 		if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
 		    !txq->stopped) {
-			ieee80211_stop_queue(sc->hw, info->hw_queue);
+			if (ath9k_is_chanctx_enabled())
+				ieee80211_stop_queue(sc->hw, info->hw_queue);
+			else
+				ieee80211_stop_queue(sc->hw, q);
 			txq->stopped = true;
 		}
 	}
-- 
2.1.2

