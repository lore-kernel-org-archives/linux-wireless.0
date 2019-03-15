Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241A5C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 10:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8ED92184C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 10:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="brRLnfKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfCOKDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:03:40 -0400
Received: from nbd.name ([46.4.11.11]:48152 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbfCOKDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 06:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w8WKWtShB6/8b7zUUDZc6Wog+o9NlqlLUr4OT0tAlNs=; b=brRLnfKVaY5iTak29El8UWlx9K
        0wDqf9ZX1w3pd+jAmhWgpIbwdS6F9UatWEUEXWY5RcKBiAOjl4PHdb9HybBUEVXAJ9Tu/xTNDRyAj
        dnp/INi6CPHZHJW/bTwK9pMNmbO97hiatuX4rOhLGeiBQZXrgbyr01xBKulimovvEgeE=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h4jgf-0005YS-0I; Fri, 15 Mar 2019 11:03:37 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id 3A0FD52BD462; Fri, 15 Mar 2019 11:03:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH] mac80211: rework locking for txq scheduling / airtime fairness
Date:   Fri, 15 Mar 2019 11:03:35 +0100
Message-Id: <20190315100335.91445-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Holding the lock around the entire duration of tx scheduling can create
some nasty lock contention, especially when processing airtime information
from the tx status or the rx path.
Improve locking by only holding the active_txq_lock for lookups / scheduling
list modifications.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 49 ++++++++++++++++--------------------------
 net/mac80211/tx.c      | 44 ++++++++++++++-----------------------
 2 files changed, 35 insertions(+), 58 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3771625b7a9d..0de0aba580eb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6269,8 +6269,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @ac: AC number to return packets from.
  *
- * Should only be called between calls to ieee80211_txq_schedule_start()
- * and ieee80211_txq_schedule_end().
  * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
  * is returned, it should be returned with ieee80211_return_txq() after the
  * driver has finished scheduling it.
@@ -6278,51 +6276,42 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac);
 
 /**
- * ieee80211_return_txq - return a TXQ previously acquired by ieee80211_next_txq()
- *
- * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @txq: pointer obtained from station or virtual interface
- *
- * Should only be called between calls to ieee80211_txq_schedule_start()
- * and ieee80211_txq_schedule_end().
- */
-void ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
-
-/**
- * ieee80211_txq_schedule_start - acquire locks for safe scheduling of an AC
+ * ieee80211_txq_schedule_start - start new scheduling round for TXQs
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @ac: AC number to acquire locks for
  *
- * Acquire locks needed to schedule TXQs from the given AC. Should be called
- * before ieee80211_next_txq() or ieee80211_return_txq().
+ * Should be called before ieee80211_next_txq() or ieee80211_return_txq().
+ * The driver must not call multiple TXQ scheduling rounds concurrently.
  */
-void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
-	__acquires(txq_lock);
+void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
+
+/* (deprecated) */
+static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
+{
+}
 
 /**
- * ieee80211_txq_schedule_end - release locks for safe scheduling of an AC
+ * ieee80211_schedule_txq - schedule a TXQ for transmission
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @ac: AC number to acquire locks for
+ * @txq: pointer obtained from station or virtual interface
  *
- * Release locks previously acquired by ieee80211_txq_schedule_end().
+ * Schedules a TXQ for transmission if it is not already scheduled.
  */
-void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
-	__releases(txq_lock);
+void ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 
 /**
- * ieee80211_schedule_txq - schedule a TXQ for transmission
+ * ieee80211_return_txq - return a TXQ previously acquired by ieee80211_next_txq()
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @txq: pointer obtained from station or virtual interface
- *
- * Schedules a TXQ for transmission if it is not already scheduled. Takes a
- * lock, which means it must *not* be called between
- * ieee80211_txq_schedule_start() and ieee80211_txq_schedule_end()
  */
-void ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
-	__acquires(txq_lock) __releases(txq_lock);
+static inline void
+ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	ieee80211_schedule_txq(hw, txq);
+}
 
 /**
  * ieee80211_txq_may_transmit - check whether TXQ is allowed to transmit
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ca23abbf5c0b..51cc37802439 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3653,16 +3653,17 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_txq *ret = NULL;
 	struct txq_info *txqi = NULL;
 
-	lockdep_assert_held(&local->active_txq_lock[ac]);
+	spin_lock_bh(&local->active_txq_lock[ac]);
 
  begin:
 	txqi = list_first_entry_or_null(&local->active_txqs[ac],
 					struct txq_info,
 					schedule_order);
 	if (!txqi)
-		return NULL;
+		goto out;
 
 	if (txqi->txq.sta) {
 		struct sta_info *sta = container_of(txqi->txq.sta,
@@ -3679,21 +3680,25 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 
 	if (txqi->schedule_round == local->schedule_round[ac])
-		return NULL;
+		goto out;
 
 	list_del_init(&txqi->schedule_order);
 	txqi->schedule_round = local->schedule_round[ac];
-	return &txqi->txq;
+	ret = &txqi->txq;
+
+out:
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+	return ret;
 }
 EXPORT_SYMBOL(ieee80211_next_txq);
 
-void ieee80211_return_txq(struct ieee80211_hw *hw,
-			  struct ieee80211_txq *txq)
+void ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = to_txq_info(txq);
 
-	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
+	spin_lock_bh(&local->active_txq_lock[txq->ac]);
 
 	if (list_empty(&txqi->schedule_order) &&
 	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
@@ -3713,17 +3718,7 @@ void ieee80211_return_txq(struct ieee80211_hw *hw,
 			list_add_tail(&txqi->schedule_order,
 				      &local->active_txqs[txq->ac]);
 	}
-}
-EXPORT_SYMBOL(ieee80211_return_txq);
 
-void ieee80211_schedule_txq(struct ieee80211_hw *hw,
-			    struct ieee80211_txq *txq)
-	__acquires(txq_lock) __releases(txq_lock)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	spin_lock_bh(&local->active_txq_lock[txq->ac]);
-	ieee80211_return_txq(hw, txq);
 	spin_unlock_bh(&local->active_txq_lock[txq->ac]);
 }
 EXPORT_SYMBOL(ieee80211_schedule_txq);
@@ -3736,7 +3731,7 @@ bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 	struct sta_info *sta;
 	u8 ac = txq->ac;
 
-	lockdep_assert_held(&local->active_txq_lock[ac]);
+	spin_lock_bh(&local->active_txq_lock[ac]);
 
 	if (!txqi->txq.sta)
 		goto out;
@@ -3766,34 +3761,27 @@ bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 
 	sta->airtime[ac].deficit += sta->airtime_weight;
 	list_move_tail(&txqi->schedule_order, &local->active_txqs[ac]);
+	spin_unlock_bh(&local->active_txq_lock[ac]);
 
 	return false;
 out:
 	if (!list_empty(&txqi->schedule_order))
 		list_del_init(&txqi->schedule_order);
+	spin_unlock_bh(&local->active_txq_lock[ac]);
 
 	return true;
 }
 EXPORT_SYMBOL(ieee80211_txq_may_transmit);
 
 void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
-	__acquires(txq_lock)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 	local->schedule_round[ac]++;
-}
-EXPORT_SYMBOL(ieee80211_txq_schedule_start);
-
-void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
-	__releases(txq_lock)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-
 	spin_unlock_bh(&local->active_txq_lock[ac]);
 }
-EXPORT_SYMBOL(ieee80211_txq_schedule_end);
+EXPORT_SYMBOL(ieee80211_txq_schedule_start);
 
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
-- 
2.17.0

