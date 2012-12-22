Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43530 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:53:42 -0500
Received: by mail-wg0-f49.google.com with SMTP id 15so2675581wgd.16
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:53:41 -0800 (PST)
Message-Id: <cb7272cf1a47b747467aec3c907fff99dae012e4.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155345_018866_D34F4EEA)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 22 Dec 2012 15:05:26 +0100
Subject: [PATCH 8/8] carl9170: refactor carl9170_update_beacon
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves parts of carl9170_update_beacon
into separate subroutines, so the parts become
more manageable.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |  133 +++++++++++++++++++-------------
 1 file changed, 80 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index ef4ec0d..9c0b150 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1520,35 +1520,92 @@ void carl9170_tx_scheduler(struct ar9170 *ar)
 		carl9170_tx(ar);
 }
 
-int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
+/* caller has to take rcu_read_lock */
+static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
 {
-	struct sk_buff *skb = NULL;
 	struct carl9170_vif_info *cvif;
+	int i = 1;
+
+	/* The AR9170 hardware has no fancy beacon queue or some
+	 * other scheduling mechanism. So, the driver has to make
+	 * due by setting the two beacon timers (pretbtt and tbtt)
+	 * once and then swapping the beacon address in the HW's
+	 * register file each time the pretbtt fires.
+	 */
+
+	cvif = rcu_dereference(ar->beacon_iter);
+	if (ar->vifs > 0 && cvif) {
+		do {
+			list_for_each_entry_continue_rcu(cvif, &ar->vif_list,
+							 list) {
+				if (cvif->active && cvif->enable_beacon)
+					goto out;
+			}
+		} while (ar->beacon_enabled && i--);
+	}
+
+out:
+	rcu_assign_pointer(ar->beacon_iter, cvif);
+	return cvif;
+}
+
+static bool carl9170_tx_beacon_physet(struct ar9170 *ar, struct sk_buff *skb,
+				      u32 *ht1, u32 *plcp)
+{
 	struct ieee80211_tx_info *txinfo;
 	struct ieee80211_tx_rate *rate;
-	__le32 *data, *old = NULL;
-	unsigned int plcp, power, chains;
-	u32 word, ht1, off, addr, len;
-	int i = 0, err = 0;
+	unsigned int power, chains;
+	bool ht_rate;
 
-	rcu_read_lock();
-	cvif = rcu_dereference(ar->beacon_iter);
-retry:
-	if (ar->vifs == 0 || !cvif)
-		goto out_unlock;
+	txinfo = IEEE80211_SKB_CB(skb);
+	rate = &txinfo->control.rates[0];
+	ht_rate = !!(txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS);
+	carl9170_tx_rate_tpc_chains(ar, txinfo, rate, plcp, &power, &chains);
 
-	list_for_each_entry_continue_rcu(cvif, &ar->vif_list, list) {
-		if (cvif->active && cvif->enable_beacon)
-			goto found;
+	*ht1 = AR9170_MAC_BCN_HT1_TX_ANT0;
+	if (chains == AR9170_TX_PHY_TXCHAIN_2)
+		*ht1 |= AR9170_MAC_BCN_HT1_TX_ANT1;
+	SET_VAL(AR9170_MAC_BCN_HT1_PWR_CTRL, *ht1, 7);
+	SET_VAL(AR9170_MAC_BCN_HT1_TPC, *ht1, power);
+	SET_VAL(AR9170_MAC_BCN_HT1_CHAIN_MASK, *ht1, chains);
+
+	if (ht_rate) {
+		*ht1 |= AR9170_MAC_BCN_HT1_HT_EN;
+		if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+			*plcp |= AR9170_MAC_BCN_HT2_SGI;
+
+		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
+			*ht1 |= AR9170_MAC_BCN_HT1_BWC_40M_SHARED;
+			*plcp |= AR9170_MAC_BCN_HT2_BW40;
+		} else if (rate->flags & IEEE80211_TX_RC_DUP_DATA) {
+			*ht1 |= AR9170_MAC_BCN_HT1_BWC_40M_DUP;
+			*plcp |= AR9170_MAC_BCN_HT2_BW40;
+		}
+
+		SET_VAL(AR9170_MAC_BCN_HT2_LEN, *plcp, skb->len + FCS_LEN);
+	} else {
+		if (*plcp <= AR9170_TX_PHY_RATE_CCK_11M)
+			*plcp |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
+		else
+			*plcp |= ((skb->len + FCS_LEN) << 16) + 0x0010;
 	}
 
-	if (!ar->beacon_enabled || i++)
-		goto out_unlock;
+	return ht_rate;
+}
 
-	goto retry;
+int carl9170_update_beacon(struct ar9170 *ar, const bool submit)
+{
+	struct sk_buff *skb = NULL;
+	struct carl9170_vif_info *cvif;
+	__le32 *data, *old = NULL;
+	u32 word, ht1, plcp, off, addr, len;
+	int i = 0, err = 0;
+	bool ht_rate;
 
-found:
-	rcu_assign_pointer(ar->beacon_iter, cvif);
+	rcu_read_lock();
+	cvif = carl9170_pick_beaconing_vif(ar);
+	if (!cvif)
+		goto out_unlock;
 
 	skb = ieee80211_beacon_get_tim(ar->hw, carl9170_get_vif(cvif),
 		NULL, NULL);
@@ -1558,7 +1615,6 @@ found:
 		goto err_free;
 	}
 
-	txinfo = IEEE80211_SKB_CB(skb);
 	spin_lock_bh(&ar->beacon_lock);
 	data = (__le32 *)skb->data;
 	if (cvif->beacon)
@@ -1588,43 +1644,14 @@ found:
 		goto err_unlock;
 	}
 
-	ht1 = AR9170_MAC_BCN_HT1_TX_ANT0;
-	rate = &txinfo->control.rates[0];
-	carl9170_tx_rate_tpc_chains(ar, txinfo, rate, &plcp, &power, &chains);
-	if (!(txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
-		if (plcp <= AR9170_TX_PHY_RATE_CCK_11M)
-			plcp |= ((skb->len + FCS_LEN) << (3 + 16)) + 0x0400;
-		else
-			plcp |= ((skb->len + FCS_LEN) << 16) + 0x0010;
-	} else {
-		ht1 |= AR9170_MAC_BCN_HT1_HT_EN;
-		if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
-			plcp |= AR9170_MAC_BCN_HT2_SGI;
-
-		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
-			ht1 |= AR9170_MAC_BCN_HT1_BWC_40M_SHARED;
-			plcp |= AR9170_MAC_BCN_HT2_BW40;
-		}
-		if (rate->flags & IEEE80211_TX_RC_DUP_DATA) {
-			ht1 |= AR9170_MAC_BCN_HT1_BWC_40M_DUP;
-			plcp |= AR9170_MAC_BCN_HT2_BW40;
-		}
-
-		SET_VAL(AR9170_MAC_BCN_HT2_LEN, plcp, skb->len + FCS_LEN);
-	}
-
-	SET_VAL(AR9170_MAC_BCN_HT1_PWR_CTRL, ht1, 7);
-	SET_VAL(AR9170_MAC_BCN_HT1_TPC, ht1, power);
-	SET_VAL(AR9170_MAC_BCN_HT1_CHAIN_MASK, ht1, chains);
-	if (chains == AR9170_TX_PHY_TXCHAIN_2)
-		ht1 |= AR9170_MAC_BCN_HT1_TX_ANT1;
+	ht_rate = carl9170_tx_beacon_physet(ar, skb, &ht1, &plcp);
 
 	carl9170_async_regwrite_begin(ar);
 	carl9170_async_regwrite(AR9170_MAC_REG_BCN_HT1, ht1);
-	if (!(txinfo->control.rates[0].flags & IEEE80211_TX_RC_MCS))
-		carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, plcp);
-	else
+	if (ht_rate)
 		carl9170_async_regwrite(AR9170_MAC_REG_BCN_HT2, plcp);
+	else
+		carl9170_async_regwrite(AR9170_MAC_REG_BCN_PLCP, plcp);
 
 	for (i = 0; i < DIV_ROUND_UP(skb->len, 4); i++) {
 		/*
-- 
1.7.10.4

