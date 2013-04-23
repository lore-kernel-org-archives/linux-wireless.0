Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:65515 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762649Ab3ECOEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 10:04:55 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk13so743467bkc.31
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 07:04:53 -0700 (PDT)
In-Reply-To: <201304230437.31850.chunkeey@googlemail.com>
References: <201304230437.31850.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 23 Apr 2013 03:52:59 +0200
Subject: [PATCH] carl9170: add support for the new rate control API
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <20130503140451.9843710027A@blech.mobile> (sfid-20130503_160459_885905_A29761CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new rate control API, the driver can now apply the
tx rate to outgoing frames just before they are uploaded to
the device. This is important because the rate control can
now react to fading or improving links a bit sooner.

Also, the driver no longer needs to sort the outgoing frames
for sample attempts (which affected the size of A-MPDUs and
the throughput of the link). For aggregated data frames, the
driver (and rate control) needs only to calculate and apply
a single set of tx rates to every subframe of the whole
aggregate.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
rfc -> v1:
	- add pointers to sta and vif in the private tid struct.
	  (saves lookup)
	- acquire tx rate set and apply it to all sub frames
	  during ampdu frame selection
	  (saves an extra loop)
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    3 +
 drivers/net/wireless/ath/carl9170/main.c     |    3 +
 drivers/net/wireless/ath/carl9170/tx.c       |  182 +++++++++++++++-----------
 3 files changed, 110 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 9dce106..8596aba 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -133,6 +133,9 @@ struct carl9170_sta_tid {
 
 	/* Preaggregation reorder queue */
 	struct sk_buff_head queue;
+
+	struct ieee80211_sta *sta;
+	struct ieee80211_vif *vif;
 };
 
 #define CARL9170_QUEUE_TIMEOUT		256
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index e9010a4..4a33c6e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1448,6 +1448,8 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 		tid_info->state = CARL9170_TID_STATE_PROGRESS;
 		tid_info->tid = tid;
 		tid_info->max = sta_info->ampdu_max_len;
+		tid_info->sta = sta;
+		tid_info->vif = vif;
 
 		INIT_LIST_HEAD(&tid_info->list);
 		INIT_LIST_HEAD(&tid_info->tmp_list);
@@ -1857,6 +1859,7 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
+		     IEEE80211_HW_SUPPORTS_RC_TABLE |
 		     IEEE80211_HW_SIGNAL_DBM;
 
 	if (!modparam_noht) {
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index c61cafa..e3f696e 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -625,7 +625,7 @@ static void carl9170_tx_ampdu_timeout(struct ar9170 *ar)
 		    msecs_to_jiffies(CARL9170_QUEUE_TIMEOUT)))
 			goto unlock;
 
-		sta = __carl9170_get_tx_sta(ar, skb);
+		sta = iter->sta;
 		if (WARN_ON(!sta))
 			goto unlock;
 
@@ -866,6 +866,93 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	return false;
 }
 
+static void carl9170_tx_get_rates(struct ar9170 *ar,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+
+	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES < CARL9170_TX_MAX_RATES);
+	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES > IEEE80211_TX_RATE_TABLE_SIZE);
+
+	info = IEEE80211_SKB_CB(skb);
+
+	ieee80211_get_tx_rates(vif, sta, skb,
+			       info->control.rates,
+			       IEEE80211_TX_MAX_RATES);
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
@@ -874,13 +961,10 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
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
@@ -889,8 +973,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	BUILD_BUG_ON(sizeof(struct _ar9170_tx_hwdesc) !=
 		     AR9170_TX_HWDESC_LEN);
 
-	BUILD_BUG_ON(IEEE80211_TX_MAX_RATES < CARL9170_TX_MAX_RATES);
-
 	BUILD_BUG_ON(AR9170_MAX_VIRTUAL_MAC >
 		((CARL9170_TX_SUPER_MISC_VIF_ID >>
 		 CARL9170_TX_SUPER_MISC_VIF_ID_S) + 1));
@@ -932,8 +1014,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	mac_tmp |= cpu_to_le16((hw_queue << AR9170_TX_MAC_QOS_S) &
 			       AR9170_TX_MAC_QOS);
 
-	no_ack = !!(info->flags & IEEE80211_TX_CTL_NO_ACK);
-	if (unlikely(no_ack))
+	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_tmp |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
 
 	if (info->control.hw_key) {
@@ -954,8 +1035,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 		}
 	}
 
-	ampdu = !!(info->flags & IEEE80211_TX_CTL_AMPDU);
-	if (ampdu) {
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 		unsigned int density, factor;
 
 		if (unlikely(!sta || !cvif))
@@ -982,50 +1062,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
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
@@ -1086,31 +1122,12 @@ static void carl9170_set_ampdu_params(struct ar9170 *ar, struct sk_buff *skb)
 	}
 }
 
-static bool carl9170_tx_rate_check(struct ar9170 *ar, struct sk_buff *_dest,
-				   struct sk_buff *_src)
-{
-	struct _carl9170_tx_superframe *dest, *src;
-
-	dest = (void *) _dest->data;
-	src = (void *) _src->data;
-
-	/*
-	 * The mac80211 rate control algorithm expects that all MPDUs in
-	 * an AMPDU share the same tx vectors.
-	 * This is not really obvious right now, because the hardware
-	 * does the AMPDU setup according to its own rulebook.
-	 * Our nicely assembled, strictly monotonic increasing mpdu
-	 * chains will be broken up, mashed back together...
-	 */
-
-	return (dest->f.phy_control == src->f.phy_control);
-}
-
 static void carl9170_tx_ampdu(struct ar9170 *ar)
 {
 	struct sk_buff_head agg;
 	struct carl9170_sta_tid *tid_info;
 	struct sk_buff *skb, *first;
+	struct ieee80211_tx_info *tx_info_first;
 	unsigned int i = 0, done_ampdus = 0;
 	u16 seq, queue, tmpssn;
 
@@ -1156,6 +1173,7 @@ retry:
 			goto processed;
 		}
 
+		tx_info_first = NULL;
 		while ((skb = skb_peek(&tid_info->queue))) {
 			/* strict 0, 1, ..., n - 1, n frame sequence order */
 			if (unlikely(carl9170_get_seq(skb) != seq))
@@ -1166,8 +1184,13 @@ retry:
 			    (tid_info->max - 1)))
 				break;
 
-			if (!carl9170_tx_rate_check(ar, skb, first))
-				break;
+			if (!tx_info_first) {
+				carl9170_tx_get_rates(ar, tid_info->vif,
+						      tid_info->sta, first);
+				tx_info_first = IEEE80211_SKB_CB(first);
+			}
+
+			carl9170_tx_apply_rateset(ar, tx_info_first, skb);
 
 			atomic_inc(&ar->tx_ampdu_upload);
 			tid_info->snx = seq = SEQ_NEXT(seq);
@@ -1182,8 +1205,7 @@ retry:
 		if (skb_queue_empty(&tid_info->queue) ||
 		    carl9170_get_seq(skb_peek(&tid_info->queue)) !=
 		    tid_info->snx) {
-			/*
-			 * stop TID, if A-MPDU frames are still missing,
+			/* stop TID, if A-MPDU frames are still missing,
 			 * or whenever the queue is empty.
 			 */
 
@@ -1450,12 +1472,14 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta = control->sta;
+	struct ieee80211_vif *vif;
 	bool run;
 
 	if (unlikely(!IS_STARTED(ar)))
 		goto err_free;
 
 	info = IEEE80211_SKB_CB(skb);
+	vif = info->control.vif;
 
 	if (unlikely(carl9170_tx_prepare(ar, sta, skb)))
 		goto err_free;
@@ -1486,6 +1510,8 @@ void carl9170_op_tx(struct ieee80211_hw *hw,
 	} else {
 		unsigned int queue = skb_get_queue_mapping(skb);
 
+		carl9170_tx_get_rates(ar, vif, sta, skb);
+		carl9170_tx_apply_rateset(ar, info, skb);
 		skb_queue_tail(&ar->tx_pending[queue], skb);
 	}
 
-- 
1.7.10.4

