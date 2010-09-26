Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57247 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0I0R7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:06 -0400
Received: by bwz11 with SMTP id 11so3540054bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:04 -0700 (PDT)
Message-Id: <11beb52120314e005f5bd60add1cf79aff24cff0.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Sep 2010 01:36:38 +0200
Subject: [PATCH 6/6] carl9170: revamp carl9170_tx_prepare
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller complained about the driver's excessive use
of variables in __packed structs. While I did not fully
agree with his sole "performance" argument on all accounts.
I do see some room for improvement in hot-paths on
architectures without an efficient access to unaligned
elements.

This first patch (dare I say?) optimizes an important tx
hot-path in the driver: carl9170_tx_prepare.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c |  155 +++++++++++++++----------------
 1 files changed, 75 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index e6be5e6..b575c86 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -760,8 +760,8 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	struct carl9170_tx_info *arinfo;
 	unsigned int hw_queue;
 	int i;
-	u16 keytype = 0;
-	u16 len, icv = 0;
+	__le16 mac_tmp;
+	u16 len;
 	bool ampdu, no_ack;
 
 	BUILD_BUG_ON(sizeof(*arinfo) > sizeof(info->rate_driver_data));
@@ -773,6 +773,10 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES < CARL9170_TX_MAX_RATES);
 
+	BUILD_BUG_ON(AR9170_MAX_VIRTUAL_MAC >
+		((CARL9170_TX_SUPER_MISC_VIF_ID >>
+		 CARL9170_TX_SUPER_MISC_VIF_ID_S) + 1));
+
 	hw_queue = ar9170_qmap[carl9170_get_queue(ar, skb)];
 
 	hdr = (void *)skb->data;
@@ -793,20 +797,37 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	txc = (void *)skb_push(skb, sizeof(*txc));
 	memset(txc, 0, sizeof(*txc));
 
-	ampdu = !!(info->flags & IEEE80211_TX_CTL_AMPDU);
+	SET_VAL(CARL9170_TX_SUPER_MISC_QUEUE, txc->s.misc, hw_queue);
+
+	if (likely(cvif))
+		SET_VAL(CARL9170_TX_SUPER_MISC_VIF_ID, txc->s.misc, cvif->id);
+
+	if (unlikely(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM))
+		txc->s.misc |= CARL9170_TX_SUPER_MISC_CAB;
+
+	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control)))
+		txc->s.misc |= CARL9170_TX_SUPER_MISC_FILL_IN_TSF;
+
+	mac_tmp = cpu_to_le16(AR9170_TX_MAC_HW_DURATION |
+			      AR9170_TX_MAC_BACKOFF);
+	mac_tmp |= cpu_to_le16((hw_queue << AR9170_TX_MAC_QOS_S) &&
+			       AR9170_TX_MAC_QOS);
+
 	no_ack = !!(info->flags & IEEE80211_TX_CTL_NO_ACK);
+	if (unlikely(no_ack))
+		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
 
 	if (info->control.hw_key) {
-		icv = info->control.hw_key->icv_len;
+		len += info->control.hw_key->icv_len;
 
 		switch (info->control.hw_key->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
 		case WLAN_CIPHER_SUITE_TKIP:
-			keytype = AR9170_TX_MAC_ENCR_RC4;
+			mac_tmp |= cpu_to_le16(AR9170_TX_MAC_ENCR_RC4);
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
-			keytype = AR9170_TX_MAC_ENCR_AES;
+			mac_tmp |= cpu_to_le16(AR9170_TX_MAC_ENCR_AES);
 			break;
 		default:
 			WARN_ON(1);
@@ -814,48 +835,58 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 		}
 	}
 
-	BUILD_BUG_ON(AR9170_MAX_VIRTUAL_MAC >
-		((CARL9170_TX_SUPER_MISC_VIF_ID >>
-		 CARL9170_TX_SUPER_MISC_VIF_ID_S) + 1));
-
-	txc->s.len = cpu_to_le16(len + sizeof(*txc));
-	txc->f.length = cpu_to_le16(len + icv + 4);
-	SET_VAL(CARL9170_TX_SUPER_MISC_VIF_ID, txc->s.misc,
-		cvif ? cvif->id : 0);
+	ampdu = !!(info->flags & IEEE80211_TX_CTL_AMPDU);
+	if (ampdu) {
+		unsigned int density, factor;
 
-	txc->f.mac_control = cpu_to_le16(AR9170_TX_MAC_HW_DURATION |
-					 AR9170_TX_MAC_BACKOFF);
+		if (unlikely(!sta || !cvif))
+			goto err_out;
 
-	SET_VAL(CARL9170_TX_SUPER_MISC_QUEUE, txc->s.misc, hw_queue);
+		factor = min_t(unsigned int, 1u,
+			 info->control.sta->ht_cap.ampdu_factor);
 
-	txc->f.mac_control |= cpu_to_le16(hw_queue << AR9170_TX_MAC_QOS_S);
-	txc->f.mac_control |= cpu_to_le16(keytype);
-	txc->f.phy_control = cpu_to_le32(0);
+		density = info->control.sta->ht_cap.ampdu_density;
 
-	if (no_ack)
-		txc->f.mac_control |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
+		if (density) {
+			/*
+			 * Watch out!
+			 *
+			 * Otus uses slightly different density values than
+			 * those from the 802.11n spec.
+			 */
 
-	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM)
-		txc->s.misc |= CARL9170_TX_SUPER_MISC_CAB;
+			density = max_t(unsigned int, density + 1, 7u);
+		}
 
-	txrate = &info->control.rates[0];
-	if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
-		txc->f.mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
-	else if (carl9170_tx_cts_check(ar, txrate))
-		txc->f.mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
+		SET_VAL(CARL9170_TX_SUPER_AMPDU_DENSITY,
+			txc->s.ampdu_settings, density);
 
-	SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[0], txrate->count);
-	txc->f.phy_control |= carl9170_tx_physet(ar, info, txrate);
+		SET_VAL(CARL9170_TX_SUPER_AMPDU_FACTOR,
+			txc->s.ampdu_settings, factor);
 
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		for (i = 1; i < CARL9170_TX_MAX_RATES; i++) {
+		for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
 			txrate = &info->control.rates[i];
-			if (txrate->idx >= 0)
+			if (txrate->idx >= 0) {
+				txc->s.ri[i] =
+					CARL9170_TX_SUPER_RI_AMPDU;
+
+				if (WARN_ON(!(txrate->flags &
+					      IEEE80211_TX_RC_MCS))) {
+					/*
+					 * Not sure if it's even possible
+					 * to aggregate non-ht rates with
+					 * this HW.
+					 */
+					goto err_out;
+				}
 				continue;
+			}
 
 			txrate->idx = 0;
 			txrate->count = ar->hw->max_rate_tries;
 		}
+
+		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 	}
 
 	/*
@@ -878,57 +909,21 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_CTS <<
 				CARL9170_TX_SUPER_RI_ERP_PROT_S);
 
-		/*
-		 * unaggregated fallback, in case aggregation
-		 * proves to be unsuccessful and unreliable.
-		 */
-		if (ampdu && i < 3)
-			txc->s.ri[i] |= CARL9170_TX_SUPER_RI_AMPDU;
-
 		txc->s.rr[i - 1] = carl9170_tx_physet(ar, info, txrate);
 	}
 
-	if (ieee80211_is_probe_resp(hdr->frame_control))
-		txc->s.misc |= CARL9170_TX_SUPER_MISC_FILL_IN_TSF;
-
-	if (ampdu) {
-		unsigned int density, factor;
-
-		if (unlikely(!sta || !cvif))
-			goto err_out;
-
-		density = info->control.sta->ht_cap.ampdu_density;
-		factor = info->control.sta->ht_cap.ampdu_factor;
-
-		if (density) {
-			/*
-			 * Watch out!
-			 *
-			 * Otus uses slightly different density values than
-			 * those from the 802.11n spec.
-			 */
-
-			density = max_t(unsigned int, density + 1, 7u);
-		}
-
-		factor = min_t(unsigned int, 1u, factor);
-
-		SET_VAL(CARL9170_TX_SUPER_AMPDU_DENSITY,
-			txc->s.ampdu_settings, density);
+	txrate = &info->control.rates[0];
+	SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[0], txrate->count);
 
-		SET_VAL(CARL9170_TX_SUPER_AMPDU_FACTOR,
-			txc->s.ampdu_settings, factor);
+	if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
+		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
+	else if (carl9170_tx_cts_check(ar, txrate))
+		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
 
-		if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS) {
-			txc->f.mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
-		} else {
-			/*
-			 * Not sure if it's even possible to aggregate
-			 * non-ht rates with this HW.
-			 */
-			WARN_ON_ONCE(1);
-		}
-	}
+	txc->s.len = cpu_to_le16(skb->len);
+	txc->f.length = cpu_to_le16(len + FCS_LEN);
+	txc->f.mac_control = mac_tmp;
+	txc->f.phy_control = carl9170_tx_physet(ar, info, txrate);
 
 	arinfo = (void *)info->rate_driver_data;
 	arinfo->timeout = jiffies;
-- 
1.7.1

