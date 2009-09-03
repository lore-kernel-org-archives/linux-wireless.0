Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49378 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZICQyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 12:54:06 -0400
Received: by fxm17 with SMTP id 17so82652fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 09:54:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] ar9170: added phy register initialisation from eeprom values
Date: Thu, 3 Sep 2009 18:16:29 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1789900589@web.de> <22ee4e770908311437y4954a79eje48976a0203f1806@mail.gmail.com> <4A9EF532.8070500@gmx.de>
In-Reply-To: <4A9EF532.8070500@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dv+nKKwnpU0+nLH"
Message-Id: <200909031816.29750.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_dv+nKKwnpU0+nLH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

(CC linux-wireless)
On Thursday 03 September 2009 00:44:02 Joerg Albert wrote:
> On 08/31/2009 11:37 PM, Christian Lamparter wrote:
> 
> > well you need a patch which lets you use the MCS rates and
> > kicks off BlockAck sessions. I posted a version some time
> > ago, (AFAIK initial RFC?). However due to fact that the code belongs
> > into the rc-algorithm and the lack of "out-house testing" feedback,
> > I had to drop it. I can send you an _updated_ (well, it should apply without
> > fuzz... but you still have to select the MCS by hand) version if you want,
> > however not until Friday. Of course, If you have free time on your hand,
> > you could do the fix-ups by yourself and start the madNess right on! ;-)
> 
> As I'm not that familiar with 802.11n (and always short of free time)
> I'd like to use your patch.
> Guess the old version is
> "[WIP][RFT][RFC] ar9170: aggregation xmit (aka the _other_ part)" from 2009/06/06?
exactly... it's old & buggy

this version even has a bogus rc.
(Of course, you can select your own MCS rate by changing)

+	rate->idx = sta_info->current_rate;
to a static value between 0 and 15.
(which is _translated_ into: MCS 0 - 15)

Regards,
	Chr

--Boundary-00=_dv+nKKwnpU0+nLH
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ar9170-rate-v4.2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ar9170-rate-v4.2.diff"

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 914e471..d3ba91c 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -131,6 +131,7 @@ struct ar9170_rxstream_mpdu_merge {
 enum ar9170_tid_state {
 	AR9170_TID_STATE_INVALID,
 	AR9170_TID_STATE_SHUTDOWN,
+	AR9170_TID_STATE_STARTING,
 	AR9170_TID_STATE_PROGRESS,
 	AR9170_TID_STATE_COMPLETE,
 };
@@ -233,6 +234,10 @@ struct ar9170 {
 	struct list_head tx_ampdu_list;
 	unsigned int tx_ampdu_pending;
 
+	spinlock_t addba_list_lock;
+	struct list_head addba_list;
+	struct work_struct start_tx_ba_work;
+
 	/* rxstream mpdu merge */
 	struct ar9170_rxstream_mpdu_merge rx_mpdu;
 	struct sk_buff *rx_failover;
@@ -246,6 +251,12 @@ struct ar9170 {
 struct ar9170_sta_info {
 	struct ar9170_sta_tid agg[AR9170_NUM_TID];
 	unsigned int ampdu_max_len;
+
+#ifndef AR9170_MAC80211_RC_MCS
+	unsigned int max_mcs;
+	int score;
+	unsigned int current_rate;
+#endif /* AR9170_MAC80211_RC_MCS */
 };
 
 #define AR9170_TX_FLAG_WAIT_FOR_ACK	BIT(0)
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index b007357..89aa831 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -49,7 +49,7 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
-static int modparam_ht;
+static int modparam_ht = 1;
 module_param_named(ht, modparam_ht, bool, S_IRUGO);
 MODULE_PARM_DESC(ht, "enable MPDU aggregation.");
 
@@ -285,6 +285,124 @@ static void ar9170_dump_tx_status_ampdu(struct ar9170 *ar)
 
 #endif /* AR9170_TXAGG_DEBUG */
 
+static void ar9170_setup_aggregation(struct ar9170 *ar, struct sk_buff *skb)
+{
+	unsigned long flags;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ar9170_sta_tid *tid_info;
+	u16 tid = ar9170_get_tid(skb);
+
+	if (!conf_is_ht(&ar->hw->conf))
+		return ;
+
+	/* don't start aggregation for non-qos / WPA handshake */
+	if ((skb->protocol == cpu_to_le16(ETH_P_PAE)) ||
+	    !ieee80211_is_data_qos(hdr->frame_control))
+		return ;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(ar->hw, ieee80211_get_DA(hdr));
+	if (!sta)
+		goto out_unlock;
+
+	if (!sta->ht_cap.ht_supported)
+		goto out_unlock;
+
+	tid_info = &((struct ar9170_sta_info *) sta->drv_priv)->agg[tid];
+
+	if (tid_info->retry++ > AR9170_NUM_MAX_BA_RETRY) {
+#ifdef AR9170_TXAGG_DEBUG
+		printk(KERN_DEBUG "%s: too many addba retries for "
+		       "ESS:[%pM], tid:%d.\n", wiphy_name(ar->hw->wiphy),
+		       sta->addr, tid);
+#endif /* AR9170_TXAGG_DEBUG */
+		goto out_unlock;
+	}
+
+	if (tid_info->state == AR9170_TID_STATE_SHUTDOWN) {
+		if (!list_empty(&tid_info->list)) {
+#ifdef AR9170_TXAGG_DEBUG
+			printk(KERN_DEBUG "%s: addba already queued.\n",
+			       wiphy_name(ar->hw->wiphy));
+#endif /* AR9170_TXAGG_DEBUG */
+			goto out_unlock;
+		}
+
+		/* FIXME: no idea if this is right... */
+		tid_info->ssn = GET_NEXT_SEQ_FROM_SKB(skb);
+
+		spin_lock_irqsave(&ar->addba_list_lock, flags);
+		memcpy(tid_info->addr, sta->addr, ETH_ALEN);
+		tid_info->state = AR9170_TID_STATE_STARTING;
+		list_add_tail(&tid_info->list, &ar->addba_list);
+		spin_unlock_irqrestore(&ar->addba_list_lock, flags);
+		ieee80211_queue_work(ar->hw, &ar->start_tx_ba_work);
+	}
+
+out_unlock:
+	rcu_read_unlock();
+}
+
+#ifndef AR9170_MAC80211_RC_MCS
+static void ar9170_feedback_11nrate(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *txrate = txinfo->status.rates;
+	struct ieee80211_sta *sta;
+	struct ar9170_sta_info *sta_info;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(ar->hw, ieee80211_get_DA((void *)skb->data));
+	if (sta == NULL)
+		goto out_unlock;
+
+	sta_info = (void *) sta->drv_priv;
+	sta_info->score = (sta_info->score * 99998) / 99999;
+
+	if (txinfo->flags & IEEE80211_TX_STAT_ACK)
+		sta_info->score += 16 - txrate->idx;
+	else
+		sta_info->score -= 16 - txrate->idx;
+
+	if (sta_info->score < 0) {
+		if (sta_info->current_rate)
+			sta_info->current_rate--;
+	} else if (sta_info->score > (1 << txrate->idx) &&
+		   sta_info->current_rate < sta_info->max_mcs)
+			sta_info->current_rate++;
+
+out_unlock:
+	rcu_read_unlock();
+}
+
+static void ar9170_select_11nrate(struct ar9170 *ar,
+				  struct ieee80211_tx_rate *rate,
+				  struct ieee80211_tx_info *info)
+{
+	struct ieee80211_sta *sta = info->control.sta;
+	struct ar9170_sta_info *sta_info = (void *) sta->drv_priv;
+
+	info->flags &= ~IEEE80211_TX_INTFL_RCALGO;
+	rate->flags = IEEE80211_TX_RC_MCS;
+	rate->idx = sta_info->current_rate;
+
+	if ((rate->idx > 4) &&
+	    conf_is_ht40(&ar->hw->conf) &&
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+		rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+
+	if ((rate->idx == (sta_info->max_mcs + 1)) &&
+	    (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
+		rate->flags |= IEEE80211_TX_RC_SHORT_GI;
+#ifdef AR9170_RC_MCS_DEBUG
+	if (net_ratelimit())
+		printk(KERN_DEBUG "rate:%x flags:%x\n", rate->idx, rate->flags);
+#endif
+}
+#endif /* AR9170_MAC80211_RC_MCS */
+
 /* caller must guarantee exclusive access for _bin_ queue. */
 static void ar9170_recycle_expired(struct ar9170 *ar,
 				   struct sk_buff_head *queue,
@@ -353,6 +471,9 @@ static void ar9170_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 
 	txinfo->status.rates[0].count = retries + 1;
 	skb_pull(skb, sizeof(struct ar9170_tx_control));
+	if (tx_status != AR9170_TX_STATUS_FAILED)
+		ar9170_setup_aggregation(ar, skb);
+
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
 
@@ -388,6 +509,9 @@ static void ar9170_tx_fake_ampdu_status(struct ar9170 *ar)
 		txinfo->status.rates[0].count = 1;
 
 		skb_pull(skb, sizeof(struct ar9170_tx_control));
+#ifndef AR9170_MAC80211_RC_MCS
+		ar9170_feedback_11nrate(ar, skb);
+#endif /* AR9170_MAC80211_RC_MCS */
 		ieee80211_tx_status_irqsafe(ar->hw, skb);
 	}
 
@@ -542,6 +666,9 @@ static void ar9170_handle_block_ack(struct ar9170 *ar, u16 count, u16 r)
 		txinfo->status.rates[0].count = 1;
 
 		skb_pull(skb, sizeof(struct ar9170_tx_control));
+#ifndef AR9170_MAC80211_RC_MCS
+		ar9170_feedback_11nrate(ar, skb);
+#endif /* AR9170_MAC80211_RC_MCS */
 		ieee80211_tx_status_irqsafe(ar->hw, skb);
 		count--;
 	}
@@ -1295,6 +1422,7 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&ar->led_work);
 #endif
 	cancel_work_sync(&ar->beacon_work);
+	cancel_work_sync(&ar->start_tx_ba_work);
 
 	mutex_lock(&ar->mutex);
 
@@ -1414,6 +1542,10 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
 			arinfo->flags = AR9170_TX_FLAG_BLOCK_ACK;
 
+#ifndef AR9170_MAC80211_RC_MCS
+			ar9170_select_11nrate(ar, txrate, info);
+#endif /* AR9170_MAC80211_RC_MCS */
+
 			goto out;
 		}
 
@@ -1475,6 +1607,13 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 		u32 r = txrate->idx;
 		u8 *txpower;
 
+#ifndef AR9170_MAC80211_RC_MCS
+		if (ar->eeprom.tx_mask == 1)
+			txrate->idx = r = min_t(s8, txrate->idx, 7);
+		else
+			txrate->idx = r = min_t(s8, txrate->idx, 15);
+#endif /* AR9170_MAC80211_RC_MCS */
+
 		/* heavy clip control */
 		txc->phy_control |= cpu_to_le32((r & 0x7) << 7);
 
@@ -1540,6 +1679,7 @@ static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
 		/* >= 36M legacy OFDM - use only one chain */
 		if (rate && rate->bitrate >= 360)
 			chains = AR9170_TX_PHY_TXCHAIN_1;
+
 	}
 	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
 }
@@ -2363,6 +2503,18 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 		}
 
 		sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
+
+#ifndef AR9170_MAC80211_RC_MCS
+		{
+			unsigned int tx_mcs;
+			unsigned int rx_mcs;
+
+			tx_mcs = ar->eeprom.tx_mask == 1 ? 7 : 15;
+			rx_mcs = find_last_bit((unsigned long *)sta->ht_cap.mcs.rx_mask, 16);
+
+			sta_info->max_mcs = min(tx_mcs, rx_mcs);
+		}
+#endif /* AR9170_MAC80211_RC_MCS */
 		break;
 
 	case STA_NOTIFY_REMOVE:
@@ -2445,7 +2597,7 @@ static int ar9170_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
 		spin_lock_irqsave(&ar->tx_ampdu_list_lock, flags);
-		if (tid_info->state != AR9170_TID_STATE_SHUTDOWN ||
+		if (tid_info->state != AR9170_TID_STATE_STARTING ||
 		    !list_empty(&tid_info->list)) {
 			spin_unlock_irqrestore(&ar->tx_ampdu_list_lock, flags);
 #ifdef AR9170_TXAGG_DEBUG
@@ -2514,6 +2666,35 @@ static const struct ieee80211_ops ar9170_ops = {
 	.ampdu_action		= ar9170_ampdu_action,
 };
 
+static void ar9170_start_tx_ba(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170,
+					 start_tx_ba_work);
+	unsigned long flags;
+
+	while (!list_empty(&ar->addba_list)) {
+		struct ar9170_sta_tid *tid_info;
+
+		spin_lock_irqsave(&ar->addba_list_lock, flags);
+		tid_info = list_first_entry(&ar->addba_list,
+					    struct ar9170_sta_tid, list);
+		if (tid_info) {
+			tid_info->retry = 0;
+			list_del_init(&tid_info->list);
+
+			if (tid_info->state != AR9170_TID_STATE_STARTING) {
+				WARN_ON(1);
+				tid_info = NULL;
+			}
+		}
+		spin_unlock_irqrestore(&ar->addba_list_lock, flags);
+
+		if (tid_info)
+			ieee80211_start_tx_ba_session(ar->hw, tid_info->addr,
+						      tid_info->tid);
+	}
+}
+
 void *ar9170_alloc(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
@@ -2542,6 +2723,7 @@ void *ar9170_alloc(size_t priv_size)
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_stats_lock);
+	spin_lock_init(&ar->addba_list_lock);
 	spin_lock_init(&ar->tx_ampdu_list_lock);
 	skb_queue_head_init(&ar->tx_status_ampdu);
 	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
@@ -2550,8 +2732,10 @@ void *ar9170_alloc(size_t priv_size)
 	}
 	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
+	INIT_WORK(&ar->start_tx_ba_work, ar9170_start_tx_ba);
 	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);
+	INIT_LIST_HEAD(&ar->addba_list);
 
 	/* all hw supports 2.4 GHz, so set channel to 1 by default */
 	ar->channel = &ar9170_2ghz_chantable[0];

--Boundary-00=_dv+nKKwnpU0+nLH--
