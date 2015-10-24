Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53364 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbJXSvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 14:51:04 -0400
From: Olav Haugan <ohaugan@codeaurora.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, kvalo@codeaurora.org,
	ath9k-devel@qca.qualcomm.com, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH 2/2] ath9k: implement set_coalesce callback
Date: Sat, 24 Oct 2015 11:50:52 -0700
Message-Id: <1445712652-19327-2-git-send-email-ohaugan@codeaurora.org> (sfid-20151024_205108_956106_F7DC59BE)
In-Reply-To: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

implement set_coalesce ieee80211_ops callback. Add default
wiphy_coalesce_support rules for 9k. These rules are not being used by 9k
since 9k can just toggle coalesce as on/off.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 57f95f2..10637f5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -86,6 +86,24 @@ static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
 };
 #endif
 
+/* 9k coalesce is binary (on/off) the below rules are
+ * not being used. Only there to give default values to
+ * wiphy_coalesce_support struct fields
+ */
+#define ATH9K_COALESCE_MAX_RULES     1
+#define ATH9K_COALESCE_MAX_FILTERS   1
+#define ATH9K_MAX_COALESCING_DELAY   1     /* in msecs */
+#define ATH9K_MAX_PATTERN_LEN        1
+#define ATH9K_MAX_OFFSET_LEN         1
+static const struct wiphy_coalesce_support ath9k_coalesce_support = {
+	.n_rules = ATH9K_COALESCE_MAX_RULES,
+	.max_delay = ATH9K_MAX_COALESCING_DELAY,
+	.n_patterns = ATH9K_COALESCE_MAX_FILTERS,
+	.pattern_min_len = 1,
+	.pattern_max_len = ATH9K_MAX_PATTERN_LEN,
+	.max_pkt_offset = ATH9K_MAX_OFFSET_LEN,
+};
+
 static void ath9k_deinit_softc(struct ath_softc *sc);
 
 static void ath9k_op_ps_wakeup(struct ath_common *common)
@@ -898,6 +916,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&common->sbands[IEEE80211_BAND_5GHZ];
 
+	hw->wiphy->coalesce = &ath9k_coalesce_support;
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	ath9k_set_mcc_capab(sc, hw);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c27143b..7595d5d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2611,6 +2611,24 @@ static int ath9k_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 
+/* ath9k coalesce support */
+static int ath9k_set_coalesce(struct ieee80211_hw *hw,
+			      struct cfg80211_coalesce *coalesce)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (!coalesce) {
+		ah->config.rx_intr_mitigation = false;
+		ath9k_hw_set_interrupts(ah);
+	} else {
+		ah->config.rx_intr_mitigation = true;
+		ath9k_hw_set_interrupts(ah);
+	}
+
+	return 0;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2639,6 +2657,7 @@ struct ieee80211_ops ath9k_ops = {
 	.get_stats	    = ath9k_get_stats,
 	.set_antenna	    = ath9k_set_antenna,
 	.get_antenna	    = ath9k_get_antenna,
+	.set_coalesce       = ath9k_set_coalesce,
 
 #ifdef CONFIG_ATH9K_WOW
 	.suspend	    = ath9k_suspend,
-- 
2.6.1

