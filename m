Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51966 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0LMHlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 02:41:08 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	vasanth@atheros.com, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 3/7] ath9k: fix PA predistortion thermal measurement handling
Date: Mon, 13 Dec 2010 08:40:52 +0100
Message-Id: <1292226056-56008-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292226056-56008-2-git-send-email-nbd@openwrt.org>
References: <1292226056-56008-1-git-send-email-nbd@openwrt.org>
 <1292226056-56008-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be able to measure the thermal values correctly for PAPRD, we need
to send training frames before setting up the gain table for the measurement,
and then again afterwards for the actual training.

For further improvement, send training frames at MCS0 instead of 54 MBit/s
legacy. That way we can use the No-ACK flag for the transmission, which
speeds up PAPRD training in general, as the hardware won't have to
retransmit and wait for ACK timeout (was previously set to 4 * 6
transmission attempts).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   74 +++++++++++++++++++-------------
 1 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index daa3c9f..bcadf9c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -320,6 +320,42 @@ static void ath_paprd_activate(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
+static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int chain)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_control txctl;
+	int time_left;
+
+	memset(&txctl, 0, sizeof(txctl));
+	txctl.txq = sc->tx.txq_map[WME_AC_BE];
+
+	memset(tx_info, 0, sizeof(*tx_info));
+	tx_info->band = hw->conf.channel->band;
+	tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	tx_info->control.rates[0].idx = 0;
+	tx_info->control.rates[0].count = 1;
+	tx_info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
+	tx_info->control.rates[1].idx = -1;
+
+	init_completion(&sc->paprd_complete);
+	sc->paprd_pending = true;
+	txctl.paprd = BIT(chain);
+	if (ath_tx_start(hw, skb, &txctl) != 0)
+		return false;
+
+	time_left = wait_for_completion_timeout(&sc->paprd_complete,
+			msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
+	sc->paprd_pending = false;
+
+	if (!time_left)
+		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CALIBRATE,
+			"Timeout waiting for paprd training on TX chain %d\n",
+			chain);
+
+	return !!time_left;
+}
+
 void ath_paprd_calibrate(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, paprd_work);
@@ -327,18 +363,12 @@ void ath_paprd_calibrate(struct work_struct *work)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = NULL;
-	struct ieee80211_tx_info *tx_info;
-	int band = hw->conf.channel->band;
-	struct ieee80211_supported_band *sband = &sc->sbands[band];
-	struct ath_tx_control txctl;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int ftype;
 	int chain_ok = 0;
 	int chain;
 	int len = 1800;
-	int time_left;
-	int i;
 
 	if (!caldata)
 		return;
@@ -347,8 +377,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	if (!skb)
 		return;
 
-	tx_info = IEEE80211_SKB_CB(skb);
-
 	skb_put(skb, len);
 	memset(skb->data, 0, len);
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -359,9 +387,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	memset(&txctl, 0, sizeof(txctl));
-	txctl.txq = sc->tx.txq_map[WME_AC_BE];
-
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_init_table(ah);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
@@ -369,30 +394,19 @@ void ath_paprd_calibrate(struct work_struct *work)
 			continue;
 
 		chain_ok = 0;
-		memset(tx_info, 0, sizeof(*tx_info));
-		tx_info->band = band;
 
-		for (i = 0; i < 4; i++) {
-			tx_info->control.rates[i].idx = sband->n_bitrates - 1;
-			tx_info->control.rates[i].count = 6;
-		}
+		ath_dbg(common, ATH_DBG_CALIBRATE,
+			"Sending PAPRD frame for thermal measurement "
+			"on chain %d\n", chain);
+		if (!ath_paprd_send_frame(sc, skb, chain))
+			goto fail_paprd;
 
-		init_completion(&sc->paprd_complete);
-		sc->paprd_pending = true;
 		ar9003_paprd_setup_gain_table(ah, chain);
-		txctl.paprd = BIT(chain);
-		if (ath_tx_start(hw, skb, &txctl) != 0)
-			break;
 
-		time_left = wait_for_completion_timeout(&sc->paprd_complete,
-				msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
-		sc->paprd_pending = false;
-		if (!time_left) {
-			ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-				"Timeout waiting for paprd training on TX chain %d\n",
-				chain);
+		ath_dbg(common, ATH_DBG_CALIBRATE,
+			"Sending PAPRD training frame on chain %d\n", chain);
+		if (!ath_paprd_send_frame(sc, skb, chain))
 			goto fail_paprd;
-		}
 
 		if (!ar9003_paprd_is_done(ah))
 			break;
-- 
1.7.3.2

