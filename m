Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39807 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2BUJW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:22:56 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25188.459551.766850@gargle.gargle.HOWL> (sfid-20120221_102301_181483_F40CAABA)
Date: Tue, 21 Feb 2012 14:52:44 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 07/22] ath9k: Calculate ampdu limit using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   19 +++++++++----------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index acf5372..23145ce 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -461,6 +461,7 @@ void ath9k_stop_btcoex(struct ath_softc *sc);
 void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
+u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
 
 /********************/
 /*   LED Control    */
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index a24aa67..e870251 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -318,6 +318,20 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	btcoex->hw_timer_enabled = false;
 }
 
+u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
+{
+	struct ath_mci_profile *mci = &sc->btcoex.mci;
+	u16 aggr_limit = 0;
+
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && mci->aggr_limit)
+		aggr_limit = (max_4ms_framelen * mci->aggr_limit) >> 4;
+	else if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
+		aggr_limit = min((max_4ms_framelen * 3) / 8,
+				 (u32)ATH_AMPDU_LIMIT_MAX);
+
+	return aggr_limit;
+}
+
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status)
 {
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3182408..5dd27d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -647,9 +647,8 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
-	struct ath_mci_profile *mci = &sc->btcoex.mci;
 	u32 max_4ms_framelen, frmlen;
-	u16 aggr_limit, legacy = 0;
+	u16 aggr_limit, bt_aggr_limit, legacy = 0;
 	int i;
 
 	skb = bf->bf_mpdu;
@@ -694,14 +693,14 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE || legacy)
 		return 0;
 
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && mci->aggr_limit)
-		aggr_limit = (max_4ms_framelen * mci->aggr_limit) >> 4;
-	else if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
-		aggr_limit = min((max_4ms_framelen * 3) / 8,
-				 (u32)ATH_AMPDU_LIMIT_MAX);
-	else
-		aggr_limit = min(max_4ms_framelen,
-				 (u32)ATH_AMPDU_LIMIT_MAX);
+	aggr_limit = min(max_4ms_framelen, (u32)ATH_AMPDU_LIMIT_MAX);
+
+	/*
+	 * Override the default aggregation limit for BTCOEX.
+	 */
+	bt_aggr_limit = ath9k_btcoex_aggr_limit(sc, max_4ms_framelen);
+	if (bt_aggr_limit)
+		aggr_limit = bt_aggr_limit;
 
 	/*
 	 * h/w can accept aggregates up to 16 bit lengths (65535).
-- 
1.7.9.1

