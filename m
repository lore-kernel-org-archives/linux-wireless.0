Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E1BC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 17:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9222420811
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 17:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="e/Awq7bD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCQRC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:02:58 -0400
Received: from nbd.name ([46.4.11.11]:48776 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfCQRC6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 13:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VjixlOcgs303XsyPjs6tm8lNu5iHTEpnb9PcuIphX2E=; b=e/Awq7bDMIYJNGLE/B6nj+CXh5
        SmRn4C33B7IWYnFOvCrhGImDg3f4qBAE5HzoXLMpKqJ6DpOsgBcK0UF17gmTX/xOa5y0sFRTqvVnA
        +f4X29n5uhiYix+2WqK9R6oXTTHL0PPhVazJviy60EnPBTwERDPxrgpoRkS5q2V68isA=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ZBV-0002kV-5X; Sun, 17 Mar 2019 18:02:54 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id 1CEAB53185A7; Sun, 17 Mar 2019 18:02:51 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2] mac80211: make ieee80211_schedule_txq schedule empty TXQs
Date:   Sun, 17 Mar 2019 18:02:51 +0100
Message-Id: <20190317170251.71185-1-nbd@nbd.name>
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
internal retry queue is not empty

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 17 ++++++++++++++---
 net/mac80211/tx.c      | 10 ++++++----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0de0aba580eb..630941e5a20e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6291,15 +6291,26 @@ static inline void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
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
@@ -6310,7 +6321,7 @@ void ieee80211_schedule_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 static inline void
 ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
-	ieee80211_schedule_txq(hw, txq);
+	__ieee80211_schedule_txq(hw, txq, false);
 }
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f85344c9af62..72279fb318e0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3706,8 +3706,9 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
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
@@ -3715,7 +3716,8 @@ void ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock[txq->ac]);
 
 	if (list_empty(&txqi->schedule_order) &&
-	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
+	    (force || !skb_queue_empty(&txqi->frags) ||
+	     txqi->tin.backlog_packets)) {
 		/* If airtime accounting is active, always enqueue STAs at the
 		 * head of the list to ensure that they only get moved to the
 		 * back by the airtime DRR scheduler once they have a negative
@@ -3735,7 +3737,7 @@ void ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
 	spin_unlock_bh(&local->active_txq_lock[txq->ac]);
 }
-EXPORT_SYMBOL(ieee80211_schedule_txq);
+EXPORT_SYMBOL(__ieee80211_schedule_txq);
 
 bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 				struct ieee80211_txq *txq)
-- 
2.17.0

