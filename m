Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972A5C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 22:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5181D2184C
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 22:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZvLwPBwh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CIxa92vE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbeLRWdJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 17:33:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58872 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbeLRWdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 17:33:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4334B60851; Tue, 18 Dec 2018 22:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545172387;
        bh=Wwly1wjTYgMpRVy8VTjDckRCslaWje83E+h/6H5i0YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvLwPBwhOBsuSLJbpfw2Wp85gW21KekIgAjqurrUGpP41itCqGEmm2t+zjRN6uFRf
         f3GACEnX/E7nXrdQlxa89RGOG2b7ipTPs4Mkv8FsfeSdC6hC9G5C7KdmE9Lk5sLy5i
         uapf9yoHTYn4QHKGsrTn+dzRiR5tPiUCXSm2TFz4=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37D9E606CF;
        Tue, 18 Dec 2018 22:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545172386;
        bh=Wwly1wjTYgMpRVy8VTjDckRCslaWje83E+h/6H5i0YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIxa92vEDWTSnRIDAUfwcO5mpJQvvvEEbJCagF0o+FHKWnOliAaP8fHMwpJ0Pw8tE
         lGZkUxMyaV6VI13AYyKYCdFmD8QO+j3YjT+MbXCs26caEhc4hzsN6AsvPGmjcrY/YN
         ZAYoLXqM4MEgaemhBjmS3BeymLTEnHvwTHh5cVbI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37D9E606CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Tue, 18 Dec 2018 14:33:04 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v4 1/6] mac80211: Add TXQ scheduling API
Date:   Tue, 18 Dec 2018 14:32:49 -0800
Message-Id: <1545172374-1072-2-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1545172374-1072-1-git-send-email-rmanohar@codeaurora.org>
References: <1545172374-1072-1-git-send-email-rmanohar@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

This adds an API to mac80211 to handle scheduling of TXQs. The interface
between driver and mac80211 for TXQ handling is changed by adding two new
functions: ieee80211_next_txq(), which will return the next TXQ to schedule
in the current round-robin rotation, and ieee80211_return_txq(), which the
driver uses to indicate that it has finished scheduling a TXQ (which will
then be put back in the scheduling rotation if it isn't empty).

The driver must call ieee80211_txq_schedule_start() at the start of each
scheduling session, and ieee80211_txq_schedule_end() at the end. The API
then guarantees that the same TXQ is not returned twice in the same
session (so a driver can loop on ieee80211_next_txq() without worrying
about breaking the loop.

Usage of the new API is optional, so drivers can be ported one at a time.
In this patch, the actual scheduling performed by mac80211 is simple
round-robin, but a subsequent commit adds airtime fairness awareness to the
scheduler.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h     | 62 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/agg-tx.c      |  2 +-
 net/mac80211/driver-ops.h  |  9 +++++++
 net/mac80211/ieee80211_i.h |  9 +++++++
 net/mac80211/main.c        |  5 ++++
 net/mac80211/sta_info.c    |  2 +-
 net/mac80211/tx.c          | 58 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e95d2d9..18b11c119b7e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -108,9 +108,15 @@
  * The driver is expected to initialize its private per-queue data for stations
  * and interfaces in the .add_interface and .sta_add ops.
  *
- * The driver can't access the queue directly. To dequeue a frame, it calls
- * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, it
- * calls the .wake_tx_queue driver op.
+ * The driver can't access the queue directly. To dequeue a frame from a
+ * txq, it calls ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a
+ * queue, it calls the .wake_tx_queue driver op.
+ *
+ * Drivers can optionally delegate responsibility for scheduling queues to
+ * mac80211, to take advantage of airtime fairness accounting. In this case, to
+ * obtain the next queue to pull frames from, the driver calls
+ * ieee80211_next_txq(). The driver is then expected to return the txq using
+ * ieee80211_return_txq().
  *
  * For AP powersave TIM handling, the driver only needs to indicate if it has
  * buffered packets in the driver specific data structures by calling
@@ -6088,7 +6094,8 @@ void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
  * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @txq: pointer obtained from station or virtual interface
+ * @txq: pointer obtained from station or virtual interface, or from
+ *	ieee80211_next_txq()
  *
  * Returns the skb if successful, %NULL if no frame was available.
  */
@@ -6096,6 +6103,53 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
 
 /**
+ * ieee80211_next_txq - get next tx queue to pull packets from
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to return packets from.
+ *
+ * Should only be called between calls to ieee80211_txq_schedule_start()
+ * and ieee80211_txq_schedule_end().
+ * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
+ * is returned, it should be returned with ieee80211_return_txq() after the
+ * driver has finished scheduling it.
+ */
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac);
+
+/**
+ * ieee80211_return_txq - return a TXQ previously acquired by
+ * ieee80211_next_txq()
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Should only be called between calls to ieee80211_txq_schedule_start()
+ * and ieee80211_txq_schedule_end().
+ */
+void ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+
+/**
+ * ieee80211_txq_schedule_start - acquire locks for safe scheduling of an AC
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to acquire locks for
+ *
+ * Acquire locks needed to schedule TXQs from the given AC. Should be called
+ * before ieee80211_next_txq() or ieee80211_return_txq().
+ */
+void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
+
+/**
+ * ieee80211_txq_schedule_end - release locks for safe scheduling of an AC
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to acquire locks for
+ *
+ * Release locks previously acquired by ieee80211_txq_schedule_end().
+ */
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac);
+
+/**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
  * The values are not guaranteed to be coherent with regard to each other, i.e.
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 69e831bc317b..e94b1a0407af 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -229,7 +229,7 @@ static void __releases(agg_queue)
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
 	local_bh_disable();
 	rcu_read_lock();
-	drv_wake_tx_queue(sta->sdata->local, txqi);
+	schedule_and_wake_txq(sta->sdata->local, txqi);
 	rcu_read_unlock();
 	local_bh_enable();
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0b1747a2313d..ce4138323820 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1173,6 +1173,15 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline void schedule_and_wake_txq(struct ieee80211_local *local,
+					 struct txq_info *txqi)
+{
+	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	ieee80211_return_txq(&local->hw, &txqi->txq);
+	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	drv_wake_tx_queue(local, txqi);
+}
+
 static inline int drv_can_aggregate_in_amsdu(struct ieee80211_local *local,
 					     struct sk_buff *head,
 					     struct sk_buff *skb)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 10a05062e4a0..33763a2eac81 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -830,6 +830,8 @@ enum txq_info_flags {
  *	a fq_flow which is already owned by a different tin
  * @def_cvars: codel vars for @def_flow
  * @frags: used to keep fragments created after dequeue
+ * @schedule_order: used with ieee80211_local->active_txqs
+ * @schedule_round: counter to prevent infinite loops on TXQ scheduling
  */
 struct txq_info {
 	struct fq_tin tin;
@@ -837,6 +839,8 @@ struct txq_info {
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
 	struct sk_buff_head frags;
+	struct list_head schedule_order;
+	u16 schedule_round;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1128,6 +1132,11 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
+	/* protects active_txqs and txqi->schedule_order */
+	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
+	struct list_head active_txqs[IEEE80211_NUM_ACS];
+	u16 schedule_round[IEEE80211_NUM_ACS];
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7b8320d4a8e4..5d292ef0a544 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -663,6 +663,11 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		INIT_LIST_HEAD(&local->active_txqs[i]);
+		spin_lock_init(&local->active_txq_lock[i]);
+	}
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fb8c2252ac0e..c2f5cb7df54f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1249,7 +1249,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
 			continue;
 
-		drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
+		schedule_and_wake_txq(local, to_txq_info(sta->sta.txq[i]));
 	}
 
 	skb_queue_head_init(&pending);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1f536ba573b4..ae897c4d2520 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1449,6 +1449,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
+	INIT_LIST_HEAD(&txqi->schedule_order);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1489,6 +1490,9 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	list_del_init(&txqi->schedule_order);
+	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
 }
 
 void ieee80211_txq_set_params(struct ieee80211_local *local)
@@ -1605,7 +1609,7 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
 
-	drv_wake_tx_queue(local, txqi);
+	schedule_and_wake_txq(local, txqi);
 
 	return true;
 }
@@ -3627,6 +3631,58 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = NULL;
+
+	lockdep_assert_held(&local->active_txq_lock[ac]);
+
+	txqi = list_first_entry_or_null(&local->active_txqs[ac],
+					struct txq_info,
+					schedule_order);
+
+	if (!txqi || txqi->schedule_round == local->schedule_round[ac])
+		return NULL;
+
+	list_del_init(&txqi->schedule_order);
+	txqi->schedule_round = local->schedule_round[ac];
+	return &txqi->txq;
+}
+EXPORT_SYMBOL(ieee80211_next_txq);
+
+void ieee80211_return_txq(struct ieee80211_hw *hw,
+			  struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+
+	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
+
+	if (list_empty(&txqi->schedule_order) &&
+	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets))
+		list_add_tail(&txqi->schedule_order,
+			      &local->active_txqs[txq->ac]);
+}
+EXPORT_SYMBOL(ieee80211_return_txq);
+
+void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	spin_lock_bh(&local->active_txq_lock[ac]);
+	local->schedule_round[ac]++;
+}
+EXPORT_SYMBOL(ieee80211_txq_schedule_start);
+
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+}
+EXPORT_SYMBOL(ieee80211_txq_schedule_end);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
-- 
1.9.1

