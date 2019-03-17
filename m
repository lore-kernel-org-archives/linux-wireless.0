Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4226EC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 13:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07F612087F
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 13:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Rjl3Ijc6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfCQNuO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 09:50:14 -0400
Received: from nbd.name ([46.4.11.11]:33804 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfCQNuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 09:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QFytCOZELO/zj2YOK2aqNNZeWOJSIpYCKL7Aq9h3wU4=; b=Rjl3Ijc684b/sJxaWWGJpkodqo
        ed2yZy5Dp99a2xBHpIwq9HjbhZpHxWVxaHXSTMD1qZkLrzVHGn+XpQ0o16o0JjrxVxDhGXVHYxA5V
        pFYc9JfFFCm8iPTDSTgAE7hw0U7dmocaRJogMbsxvP8Ea+OxUaUeoXFIq7MPzz/XNCy8=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5WB2-0005r7-78; Sun, 17 Mar 2019 14:50:12 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id 224AD53139F9; Sun, 17 Mar 2019 14:50:10 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        johannes@sipsolutions.net
Subject: [PATCH] mac80211: make ieee80211_schedule_txq schedule empty TXQs
Date:   Sun, 17 Mar 2019 14:50:10 +0100
Message-Id: <20190317135010.19198-1-nbd@nbd.name>
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
 net/mac80211/tx.c      |  8 +++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

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
index f85344c9af62..8b6e4f609d5c 100644
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
-- 
2.17.0

