Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB397C10F03
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88856218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="C5afJywK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfCPRGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:06:38 -0400
Received: from nbd.name ([46.4.11.11]:55512 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfCPRGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 13:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Eylsd6osPbpYUEHFy36WYi4wScGzYNuetPppnXg1jIc=; b=C5afJywKbLJEWV4rtVs7eesMbo
        r63Cex38fIPrVTa/7+3qGJNrset7Y0YirXbQ8KC72UjgVNZX0e/EvoevHD23oY2W4kBpmetvi9LC+
        e9/wisF3EAYhq1QlWTTEvBaVd4NN3HPcbzyJaGfvUnQQstXqNnHuLV58HoIC+NMeKw4Q=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ClX-00071p-PX; Sat, 16 Mar 2019 18:06:36 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CC72752C90E5; Sat, 16 Mar 2019 18:06:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 3/5] mac80211: calculate hash for fq without holding fq->lock in itxq enqueue
Date:   Sat, 16 Mar 2019 18:06:32 +0100
Message-Id: <20190316170634.13125-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316170634.13125-1-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reduces lock contention on enqueue/dequeue of iTXQ packets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/fq_impl.h | 18 ++++++++++--------
 net/mac80211/tx.c     | 15 ++++++++++-----
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index be7c0fab3478..2caa86660ab0 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -107,21 +107,23 @@ static struct sk_buff *fq_tin_dequeue(struct fq *fq,
 	return skb;
 }
 
+static u32 fq_flow_idx(struct fq *fq, struct sk_buff *skb)
+{
+	u32 hash = skb_get_hash_perturb(skb, fq->perturbation);
+
+	return reciprocal_scale(hash, fq->flows_cnt);
+}
+
 static struct fq_flow *fq_flow_classify(struct fq *fq,
-					struct fq_tin *tin,
+					struct fq_tin *tin, u32 idx,
 					struct sk_buff *skb,
 					fq_flow_get_default_t get_default_func)
 {
 	struct fq_flow *flow;
-	u32 hash;
-	u32 idx;
 
 	lockdep_assert_held(&fq->lock);
 
-	hash = skb_get_hash_perturb(skb, fq->perturbation);
-	idx = reciprocal_scale(hash, fq->flows_cnt);
 	flow = &fq->flows[idx];
-
 	if (flow->tin && flow->tin != tin) {
 		flow = get_default_func(fq, tin, idx, skb);
 		tin->collisions++;
@@ -153,7 +155,7 @@ static void fq_recalc_backlog(struct fq *fq,
 }
 
 static void fq_tin_enqueue(struct fq *fq,
-			   struct fq_tin *tin,
+			   struct fq_tin *tin, u32 idx,
 			   struct sk_buff *skb,
 			   fq_skb_free_t free_func,
 			   fq_flow_get_default_t get_default_func)
@@ -163,7 +165,7 @@ static void fq_tin_enqueue(struct fq *fq,
 
 	lockdep_assert_held(&fq->lock);
 
-	flow = fq_flow_classify(fq, tin, skb, get_default_func);
+	flow = fq_flow_classify(fq, tin, idx, skb, get_default_func);
 
 	flow->tin = tin;
 	flow->backlog += skb->len;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0b73a0fe8218..8127e43e12b1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1398,11 +1398,15 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
+	u32 flow_idx = fq_flow_idx(fq, skb);
 
 	ieee80211_set_skb_enqueue_time(skb);
-	fq_tin_enqueue(fq, tin, skb,
+
+	spin_lock_bh(&fq->lock);
+	fq_tin_enqueue(fq, tin, flow_idx, skb,
 		       fq_skb_free_func,
 		       fq_flow_get_default_func);
+	spin_unlock_bh(&fq->lock);
 }
 
 static bool fq_vlan_filter_func(struct fq *fq, struct fq_tin *tin,
@@ -1589,7 +1593,6 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct sk_buff *skb)
 {
-	struct fq *fq = &local->fq;
 	struct ieee80211_vif *vif;
 	struct txq_info *txqi;
 
@@ -1607,9 +1610,7 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	if (!txqi)
 		return false;
 
-	spin_lock_bh(&fq->lock);
 	ieee80211_txq_enqueue(local, txqi, skb);
-	spin_unlock_bh(&fq->lock);
 
 	schedule_and_wake_txq(local, txqi);
 
@@ -3227,6 +3228,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	u8 max_subframes = sta->sta.max_amsdu_subframes;
 	int max_frags = local->hw.max_tx_fragments;
 	int max_amsdu_len = sta->sta.max_amsdu_len;
+	u32 flow_idx;
 	int orig_truesize;
 	__be16 len;
 	void *data;
@@ -3256,6 +3258,8 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 		max_amsdu_len = min_t(int, max_amsdu_len,
 				      sta->sta.max_tid_amsdu_len[tid]);
 
+	flow_idx = fq_flow_idx(fq, skb);
+
 	spin_lock_bh(&fq->lock);
 
 	/* TODO: Ideally aggregation should be done on dequeue to remain
@@ -3263,7 +3267,8 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	 */
 
 	tin = &txqi->tin;
-	flow = fq_flow_classify(fq, tin, skb, fq_flow_get_default_func);
+	flow = fq_flow_classify(fq, tin, flow_idx, skb,
+				fq_flow_get_default_func);
 	head = skb_peek_tail(&flow->queue);
 	if (!head || skb_is_gso(head))
 		goto out;
-- 
2.17.0

