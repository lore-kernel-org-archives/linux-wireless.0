Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36547 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3DWChj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 22:37:39 -0400
Received: by mail-bk0-f46.google.com with SMTP id je9so46594bkc.33
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 19:37:37 -0700 (PDT)
Subject: [RFC/RFT] carl9170: add support for the new rate control API
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 23 Apr 2013 04:37:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201304230437.31850.chunkeey@googlemail.com> (sfid-20130423_043751_188599_A6D5CDDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new rate control API, the driver can now apply the
tx rate to outgoing frames just before they are uploaded to
the device. This is important because the rate control now
reacts to fading or improving link conditions "much" faster.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Hello,

It's been a while since I had the chance to write something even
remotely useful. So, let's see if this feature works as intended.
Then again, having some actual throughput/latency numbers would
be nice. So, if someone has an AR9170 device and can verify or
falsify the "claims" I made, I would like to hear from you ;-).

Regards,
	Christian 
---
 drivers/net/wireless/ath/carl9170/main.c |    1 +
 drivers/net/wireless/ath/carl9170/tx.c   |  218 ++++++++++++++++++------------
 2 files changed, 135 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index e9010a4..df16c6e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1857,6 +1857,7 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
+		     IEEE80211_HW_SUPPORTS_RC_TABLE |
 		     IEEE80211_HW_SIGNAL_DBM;
 
 	if (!modparam_noht) {
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index c61cafa..5a3b19e 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -105,12 +105,10 @@ static void carl9170_tx_accounting(struct ar9170 *ar, struct sk_buff *skb)
 }
 
 /* needs rcu_read_lock */
-static struct ieee80211_sta *__carl9170_get_tx_sta(struct ar9170 *ar,
+static struct ieee80211_vif *__carl9170_get_tx_vif(struct ar9170 *ar,
 						   struct sk_buff *skb)
 {
 	struct _carl9170_tx_superframe *super = (void *) skb->data;
-	struct ieee80211_hdr *hdr = (void *) super->frame_data;
-	struct ieee80211_vif *vif;
 	unsigned int vif_id;
 
 	vif_id = (super->s.misc & CARL9170_TX_SUPER_MISC_VIF_ID) >>
@@ -119,12 +117,18 @@ static struct ieee80211_sta *__carl9170_get_tx_sta(struct ar9170 *ar,
 	if (WARN_ON_ONCE(vif_id >= AR9170_MAX_VIRTUAL_MAC))
 		return NULL;
 
-	vif = rcu_dereference(ar->vif_priv[vif_id].vif);
-	if (unlikely(!vif))
-		return NULL;
+	return rcu_dereference(ar->vif_priv[vif_id].vif);
+}
 
-	/*
-	 * Normally we should use wrappers like ieee80211_get_DA to get
+/* needs rcu_read_lock */
+static struct ieee80211_sta *___carl9170_get_tx_sta(struct ar9170 *ar,
+						    struct ieee80211_vif *vif,
+						    struct sk_buff *skb)
+{
+	struct _carl9170_tx_superframe *super = (void *) skb->data;
+	struct ieee80211_hdr *hdr = (void *) super->frame_data;
+
+	/* Normally we should use wrappers like ieee80211_get_DA to get
 	 * the correct peer ieee80211_sta.
 	 *
 	 * But there is a problem with indirect traffic (broadcasts, or
@@ -136,6 +140,18 @@ static struct ieee80211_sta *__carl9170_get_tx_sta(struct ar9170 *ar,
 	return ieee80211_find_sta(vif, hdr->addr1);
 }
 
+/* needs rcu_read_lock */
+static struct ieee80211_sta *__carl9170_get_tx_sta(struct ar9170 *ar,
+						   struct sk_buff *skb)
+{
+	struct ieee80211_vif *vif = __carl9170_get_tx_vif(ar, skb);
+
+	if (unlikely(!vif))
+		return NULL;
+
+	return ___carl9170_get_tx_sta(ar, vif, skb);
+}
+
 static void carl9170_tx_ps_unblock(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_sta *sta;
@@ -866,6 +882,97 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	return false;
 }
 
+static void carl9170_tx_rateset(struct ar9170 *ar,
+				struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+
+	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES < CARL9170_TX_MAX_RATES);
+	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES > IEEE80211_TX_RATE_TABLE_SIZE);
+
+	info = IEEE80211_SKB_CB(skb);
+
+	rcu_read_lock();
+	vif = __carl9170_get_tx_vif(ar, skb);
+	sta = ___carl9170_get_tx_sta(ar, vif, skb);
+	ieee80211_get_tx_rates(vif, sta, skb,
+			       info->control.rates,
+			       IEEE80211_TX_MAX_RATES);
+	rcu_read_unlock();
+}
+
+static void carl9170_tx_apply_rateset(struct ar9170 *ar,
+				      struct ieee80211_tx_info *sinfo,
+				      struct sk_buff *skb)
+{
+	struct ieee80211_tx_rate *txrate;
+	struct ieee80211_tx_info *info;
+	struct _carl9170_tx_superframe *txc = (void *) skb->data;
+	int i;
+	bool ampdu;
+	bool no_ack;
+
+	info = IEEE80211_SKB_CB(skb);
+	ampdu = !!(info->flags & IEEE80211_TX_CTL_AMPDU);
+	no_ack = !!(info->flags & IEEE80211_TX_CTL_NO_ACK);
+
+	/* Set the rate control probe flag for all (sub-) frames.
+	 * This is because the TX_STATS_AMPDU flag is only set on
+	 * the last frame, so it has to be inherited.
+	 */
+	info->flags |= (sinfo->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+
+	/* NOTE: For the first rate, the ERP & AMPDU flags are directly
+	 * taken from mac_control. For all fallback rate, the firmware
+	 * updates the mac_control flags from the rate info field.
+	 */
+	for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
+		__le32 phy_set;
+
+		txrate = &sinfo->control.rates[i];
+		if (txrate->idx < 0)
+			break;
+
+		phy_set = carl9170_tx_physet(ar, info, txrate);
+		if (i == 0) {
+			__le16 mac_tmp = cpu_to_le16(0);
+
+			/* first rate - part of the hw's frame header */
+			txc->f.phy_control = phy_set;
+
+			if (ampdu && txrate->flags & IEEE80211_TX_RC_MCS)
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+
+			if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
+			else if (carl9170_tx_cts_check(ar, txrate))
+				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
+
+			txc->f.mac_control |= mac_tmp;
+		} else {
+			/* fallback rates are stored in the firmware's
+			 * retry rate set array.
+			 */
+			txc->s.rr[i - 1] = phy_set;
+		}
+
+		SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[i],
+			txrate->count);
+
+		if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
+			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_RTS <<
+				CARL9170_TX_SUPER_RI_ERP_PROT_S);
+		else if (carl9170_tx_cts_check(ar, txrate))
+			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_CTS <<
+				CARL9170_TX_SUPER_RI_ERP_PROT_S);
+
+		if (ampdu && (txrate->flags & IEEE80211_TX_RC_MCS))
+			txc->s.ri[i] |= CARL9170_TX_SUPER_RI_AMPDU;
+	}
+}
+
 static int carl9170_tx_prepare(struct ar9170 *ar,
 			       struct ieee80211_sta *sta,
 			       struct sk_buff *skb)
@@ -874,13 +981,10 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	struct _carl9170_tx_superframe *txc;
 	struct carl9170_vif_info *cvif;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_tx_rate *txrate;
 	struct carl9170_tx_info *arinfo;
 	unsigned int hw_queue;
-	int i;
 	__le16 mac_tmp;
 	u16 len;
-	bool ampdu, no_ack;
 
 	BUILD_BUG_ON(sizeof(*arinfo) > sizeof(info->rate_driver_data));
 	BUILD_BUG_ON(sizeof(struct _carl9170_tx_superdesc) !=
@@ -889,8 +993,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	BUILD_BUG_ON(sizeof(struct _ar9170_tx_hwdesc) !=
 		     AR9170_TX_HWDESC_LEN);
 
-	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES < CARL9170_TX_MAX_RATES);
-
 	BUILD_BUG_ON(AR9170_MAX_VIRTUAL_MAC >
 		((CARL9170_TX_SUPER_MISC_VIF_ID >>
 		 CARL9170_TX_SUPER_MISC_VIF_ID_S) + 1));
@@ -932,8 +1034,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	mac_tmp |= cpu_to_le16((hw_queue << AR9170_TX_MAC_QOS_S) &
 			       AR9170_TX_MAC_QOS);
 
-	no_ack = !!(info->flags & IEEE80211_TX_CTL_NO_ACK);
-	if (unlikely(no_ack))
+	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
 
 	if (info->control.hw_key) {
@@ -954,8 +1055,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 		}
 	}
 
-	ampdu = !!(info->flags & IEEE80211_TX_CTL_AMPDU);
-	if (ampdu) {
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 		unsigned int density, factor;
 
 		if (unlikely(!sta || !cvif))
@@ -982,50 +1082,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 			txc->s.ampdu_settings, factor);
 	}
 
-	/*
-	 * NOTE: For the first rate, the ERP & AMPDU flags are directly
-	 * taken from mac_control. For all fallback rate, the firmware
-	 * updates the mac_control flags from the rate info field.
-	 */
-	for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
-		__le32 phy_set;
-		txrate = &info->control.rates[i];
-		if (txrate->idx < 0)
-			break;
-
-		phy_set = carl9170_tx_physet(ar, info, txrate);
-		if (i == 0) {
-			/* first rate - part of the hw's frame header */
-			txc->f.phy_control = phy_set;
-
-			if (ampdu && txrate->flags & IEEE80211_TX_RC_MCS)
-				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_AGGR);
-			if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
-				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
-			else if (carl9170_tx_cts_check(ar, txrate))
-				mac_tmp |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
-
-		} else {
-			/* fallback rates are stored in the firmware's
-			 * retry rate set array.
-			 */
-			txc->s.rr[i - 1] = phy_set;
-		}
-
-		SET_VAL(CARL9170_TX_SUPER_RI_TRIES, txc->s.ri[i],
-			txrate->count);
-
-		if (carl9170_tx_rts_check(ar, txrate, ampdu, no_ack))
-			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_RTS <<
-				CARL9170_TX_SUPER_RI_ERP_PROT_S);
-		else if (carl9170_tx_cts_check(ar, txrate))
-			txc->s.ri[i] |= (AR9170_TX_MAC_PROT_CTS <<
-				CARL9170_TX_SUPER_RI_ERP_PROT_S);
-
-		if (ampdu && (txrate->flags & IEEE80211_TX_RC_MCS))
-			txc->s.ri[i] |= CARL9170_TX_SUPER_RI_AMPDU;
-	}
-
 	txc->s.len = cpu_to_le16(skb->len);
 	txc->f.length = cpu_to_le16(len + FCS_LEN);
 	txc->f.mac_control = mac_tmp;
@@ -1086,24 +1142,23 @@ static void carl9170_set_ampdu_params(struct ar9170 *ar, struct sk_buff *skb)
 	}
 }
 
-static bool carl9170_tx_rate_check(struct ar9170 *ar, struct sk_buff *_dest,
-				   struct sk_buff *_src)
+static void carl9170_set_rates(struct ar9170 *ar, struct sk_buff_head *queue)
 {
-	struct _carl9170_tx_superframe *dest, *src;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 
-	dest = (void *) _dest->data;
-	src = (void *) _src->data;
+	skb = skb_peek(queue);
+	carl9170_tx_rateset(ar, skb);
+	info = IEEE80211_SKB_CB(skb);
 
-	/*
-	 * The mac80211 rate control algorithm expects that all MPDUs in
-	 * an AMPDU share the same tx vectors.
-	 * This is not really obvious right now, because the hardware
-	 * does the AMPDU setup according to its own rulebook.
-	 * Our nicely assembled, strictly monotonic increasing mpdu
-	 * chains will be broken up, mashed back together...
-	 */
+	/* apply ampdu spacing & factor settings */
+	carl9170_set_ampdu_params(ar, skb);
+
+	skb_queue_walk(queue, skb)
+		carl9170_tx_apply_rateset(ar, info, skb);
 
-	return (dest->f.phy_control == src->f.phy_control);
+	/* set aggregation push bit */
+	carl9170_set_immba(ar, skb_peek_tail(queue));
 }
 
 static void carl9170_tx_ampdu(struct ar9170 *ar)
@@ -1166,9 +1221,6 @@ retry:
 			    (tid_info->max - 1)))
 				break;
 
-			if (!carl9170_tx_rate_check(ar, skb, first))
-				break;
-
 			atomic_inc(&ar->tx_ampdu_upload);
 			tid_info->snx = seq = SEQ_NEXT(seq);
 			__skb_unlink(skb, &tid_info->queue);
@@ -1197,11 +1249,8 @@ processed:
 		if (skb_queue_empty(&agg))
 			continue;
 
-		/* apply ampdu spacing & factor settings */
-		carl9170_set_ampdu_params(ar, skb_peek(&agg));
-
-		/* set aggregation push bit */
-		carl9170_set_immba(ar, skb_peek_tail(&agg));
+		/* set rate */
+		carl9170_set_rates(ar, &agg);
 
 		spin_lock_bh(&ar->tx_pending[queue].lock);
 		skb_queue_splice_tail_init(&agg, &ar->tx_pending[queue]);
@@ -1485,7 +1534,8 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 
 	} else {
 		unsigned int queue = skb_get_queue_mapping(skb);
-
+		carl9170_tx_rateset(ar, skb);
+		carl9170_tx_apply_rateset(ar, info, skb);
 		skb_queue_tail(&ar->tx_pending[queue], skb);
 	}
 
-- 
1.7.10.4

