Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7715C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC76220854
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="f4lfdazp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfCRLBD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:01:03 -0400
Received: from nbd.name ([46.4.11.11]:42556 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfCRLBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 07:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K1GLwAcGDKb9tV45cMgn+Fv0kj7OKlUxiAPdeQgd/Lc=; b=f4lfdazpYJKBIfCtccrMCd1ei5
        EzPw5jWzs+Db6UhJ/siaa/YyeKFH4LqejSZtNoZkLh8bwUWtejF/iZn46k0mPbkNoqNzRo8ynLlOd
        Tado9TlHZwLoVA5ux/X7C9ezNlnykBZF7yS/WrBd6pvMx/Bjgan7TviXdShKsTPpOtvc=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5q0p-0005YP-FT; Mon, 18 Mar 2019 12:00:59 +0100
Received: by maeck.lan (Postfix, from userid 501)
        id 82A3B532B754; Mon, 18 Mar 2019 12:00:58 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v3] mac80211: make ieee80211_schedule_txq schedule empty TXQs
Date:   Mon, 18 Mar 2019 12:00:58 +0100
Message-Id: <20190318110058.73586-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently there is no way for the driver to signal to mac80211 that it should
schedule a TXQ even if there are no packets on the mac80211 part of that queue.
This is problematic if the driver has an internal retry queue to deal with
software A-MPDU retry.

This patch changes the behavior of ieee80211_schedule_txq to always schedule
the queue, as its only user (ath9k) seems to expect such behavior already:
it calls this function on tx status and on powersave wakeup whenever its
internal retry queue is not empty.

Also add an extra argument to ieee80211_return_txq to get the same behavior.

This fixes an issue on ath9k where tx queues with packets to retry (and no
new packets in mac80211) would not get serviced.

Fixes: 89cea7493a346 ("ath9k: Switch to mac80211 TXQ scheduling and airtime APIs")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c    |  4 ++--
 drivers/net/wireless/ath/ath9k/xmit.c    |  5 ++++-
 include/net/mac80211.h                   | 24 ++++++++++++++++++++----
 net/mac80211/tx.c                        | 10 ++++++----
 5 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4fc885617de1..895a94b2a63e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2720,7 +2720,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 			num_msdus++;
 			num_bytes += ret;
 		}
-		ieee80211_return_txq(hw, txq);
+		ieee80211_return_txq(hw, txq, false);
 		ieee80211_txq_schedule_end(hw, txq->ac);
 
 		record->num_msdus = cpu_to_le16(num_msdus);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b73c23d4ce86..41e89db244d2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4089,7 +4089,7 @@ static int ath10k_mac_schedule_txq(struct ieee80211_hw *hw, u32 ac)
 			if (ret < 0)
 				break;
 		}
-		ieee80211_return_txq(hw, txq);
+		ieee80211_return_txq(hw, txq, false);
 		ath10k_htt_tx_txq_update(hw, txq);
 		if (ret == -EBUSY)
 			break;
@@ -4374,7 +4374,7 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 		if (ret < 0)
 			break;
 	}
-	ieee80211_return_txq(hw, txq);
+	ieee80211_return_txq(hw, txq, false);
 	ath10k_htt_tx_txq_update(hw, txq);
 out:
 	ieee80211_txq_schedule_end(hw, ac);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 06e0c5a6fab6..245a63932840 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1938,12 +1938,15 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		goto out;
 
 	while ((queue = ieee80211_next_txq(hw, txq->mac80211_qnum))) {
+		bool force;
+
 		tid = (struct ath_atx_tid *)queue->drv_priv;
 
 		ret = ath_tx_sched_aggr(sc, txq, tid);
 		ath_dbg(common, QUEUE, "ath_tx_sched_aggr returned %d\n", ret);
 
-		ieee80211_return_txq(hw, queue);
+		force = !skb_queue_empty(&tid->retry_q);
+		ieee80211_return_txq(hw, queue, force);
 	}
 
 out:
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0de0aba580eb..5b5d28eead38 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6291,26 +6291,42 @@ static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
 {
 }
 
+void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq, bool force);
+
 /**
  * ieee80211_schedule_txq - schedule a TXQ for transmission
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @txq: pointer obtained from station or virtual interface
  *
- * Schedules a TXQ for transmission if it is not already scheduled.
+ * Schedules a TXQ for transmission if it is not already scheduled,
+ * even if mac80211 does not have any packets buffered.
+ *
+ * The driver may call this function if it has buffered packets for
+ * this TXQ internally.
  */
-void ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+static inline void
+ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	__ieee80211_schedule_txq(hw, txq, true);
+}
 
 /**
  * ieee80211_return_txq - return a TXQ previously acquired by ieee80211_next_txq()
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  * @txq: pointer obtained from station or virtual interface
+ * @force: schedule txq even if mac80211 does not have any buffered packets.
+ *
+ * The driver may set force=true if it has buffered packets for this TXQ
+ * internally.
  */
 static inline void
-ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq,
+		     bool force)
 {
-	ieee80211_schedule_txq(hw, txq);
+	__ieee80211_schedule_txq(hw, txq, force);
 }
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9fe8682d79ec..e22de40a7790 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3692,8 +3692,9 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 }
 EXPORT_SYMBOL(ieee80211_next_txq);
 
-void ieee80211_schedule_txq(struct ieee80211_hw *hw,
-			    struct ieee80211_txq *txq)
+void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq,
+			      bool force)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = to_txq_info(txq);
@@ -3701,7 +3702,8 @@ void ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock[txq->ac]);
 
 	if (list_empty(&txqi->schedule_order) &&
-	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
+	    (force || !skb_queue_empty(&txqi->frags) ||
+	     txqi->tin.backlog_packets)) {
 		/* If airtime accounting is active, always enqueue STAs at the
 		 * head of the list to ensure that they only get moved to the
 		 * back by the airtime DRR scheduler once they have a negative
@@ -3721,7 +3723,7 @@ void ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
 	spin_unlock_bh(&local->active_txq_lock[txq->ac]);
 }
-EXPORT_SYMBOL(ieee80211_schedule_txq);
+EXPORT_SYMBOL(__ieee80211_schedule_txq);
 
 bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 				struct ieee80211_txq *txq)
-- 
2.17.0

