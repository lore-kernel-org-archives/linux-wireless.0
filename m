Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172F6C4363B
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D902B21850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O5pL1RrE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Aq1qqqPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbeLSBC3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 20:02:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbeLSBC2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 20:02:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8316960C41; Wed, 19 Dec 2018 01:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181346;
        bh=Lo5NVoaepIcVvg9/pG8YIsQ5j+RFZEQWgVj68IcI4Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5pL1RrE03zYvfj5Qqx2pm3yJrF+h7b63Fp2FKStk46zCW7Kl3EvUTFqEkKHjrdGw
         8L4iJC9HLYvNiTFygPCVlmfGPME43KI+vIubRcpa4F0ShqJLBkLkZIbinCi6KIDcV1
         pwY/09NUX/phFsGv3EpleEnngTJWMkxpBmwZ5xk8=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85B9E60C01;
        Wed, 19 Dec 2018 01:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181344;
        bh=Lo5NVoaepIcVvg9/pG8YIsQ5j+RFZEQWgVj68IcI4Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aq1qqqPAzeV+xh+Yl0pgKuNINAIj4TkRmekrwd5KTTcCS/cT5Rhhbwyj3euQqDpNJ
         97hfnUb3X/5k5Iqx/3WcyHGyZNDAw6KyFqJEjAQBdbyuLI3z9i8qar/MQUsLGowGHM
         TLLcv4Nl3lETMx6D+XYjhG+GaF759FHc7KwEWPT4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85B9E60C01
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Tue, 18 Dec 2018 17:02:22 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v5 4/6] ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
Date:   Tue, 18 Dec 2018 17:02:09 -0800
Message-Id: <1545181331-5288-5-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

This moves the ath9k driver to use the mac80211 TXQ scheduling and
airtime accounting APIs, removing the corresponding state tracking
inside the driver.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
[rmanohar@codeaurora.org: fixed checkpatch error and warnings]
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  14 --
 drivers/net/wireless/ath/ath9k/debug.c     |   3 -
 drivers/net/wireless/ath/ath9k/debug.h     |   8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |  70 ---------
 drivers/net/wireless/ath/ath9k/init.c      |   3 +-
 drivers/net/wireless/ath/ath9k/recv.c      |   9 +-
 drivers/net/wireless/ath/ath9k/xmit.c      | 244 +++++++++--------------------
 7 files changed, 75 insertions(+), 276 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 21ba20981a80..90b56766dab1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -112,8 +112,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
-#define ATH_AIRTIME_QUANTUM        300 /* usec */
-
 /* Stop tx traffic 1ms before the GO goes away */
 #define ATH_P2P_PS_STOP_TIME       1000
 
@@ -246,10 +244,8 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
-	bool has_queued;
 };
 
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 
 struct ath_node {
@@ -263,12 +259,9 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
-	s64 airtime_deficit[IEEE80211_NUM_ACS];
-	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
-	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -986,11 +979,6 @@ struct ath_ant_comb {
 
 #define ATH9K_NUM_CHANCTX  2 /* supports 2 operating channels */
 
-#define AIRTIME_USE_TX		BIT(0)
-#define AIRTIME_USE_RX		BIT(1)
-#define AIRTIME_USE_NEW_QUEUES	BIT(2)
-#define AIRTIME_ACTIVE(flags) (!!(flags & (AIRTIME_USE_TX|AIRTIME_USE_RX)))
-
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -1034,8 +1022,6 @@ struct ath_softc {
 	short nbcnvifs;
 	unsigned long ps_usecount;
 
-	u16 airtime_flags; /* AIRTIME_* */
-
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 4399e9ad058f..0dfea5d6e949 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1443,9 +1443,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 #endif
 	debugfs_create_file("tpc", 0600, sc->debug.debugfs_phy, sc, &fops_tpc);
 
-	debugfs_create_u16("airtime_flags", 0600,
-			   sc->debug.debugfs_phy, &sc->airtime_flags);
-
 	debugfs_create_file("nf_override", 0600,
 			    sc->debug.debugfs_phy, sc, &fops_nf_override);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 79607db14387..33826aa13687 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -319,20 +319,12 @@ static inline void ath9k_debug_stat_ant(struct ath_softc *sc,
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
-void ath_debug_airtime(struct ath_softc *sc,
-		       struct ath_node *an,
-		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
-static inline void ath_debug_airtime(struct ath_softc *sc,
-			      struct ath_node *an,
-			      u32 rx, u32 tx)
-{
-}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index e8fcd3e1c470..d95cabddce33 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -242,75 +242,6 @@ static ssize_t read_file_node_recv(struct file *file, char __user *user_buf,
 	.llseek = default_llseek,
 };
 
-void ath_debug_airtime(struct ath_softc *sc,
-		struct ath_node *an,
-		u32 rx,
-		u32 tx)
-{
-	struct ath_airtime_stats *astats = &an->airtime_stats;
-
-	astats->rx_airtime += rx;
-	astats->tx_airtime += tx;
-}
-
-static ssize_t read_airtime(struct file *file, char __user *user_buf,
-			size_t count, loff_t *ppos)
-{
-	struct ath_node *an = file->private_data;
-	struct ath_airtime_stats *astats;
-	static const char *qname[4] = {
-		"VO", "VI", "BE", "BK"
-	};
-	u32 len = 0, size = 256;
-	char *buf;
-	size_t retval;
-	int i;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	astats = &an->airtime_stats;
-
-	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
-	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
-	len += scnprintf(buf + len, size - len, "Deficit: ");
-	for (i = 0; i < 4; i++)
-		len += scnprintf(buf+len, size - len, "%s: %lld us ", qname[i], an->airtime_deficit[i]);
-	if (len < size)
-		buf[len++] = '\n';
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static ssize_t
-write_airtime_reset_stub(struct file *file, const char __user *ubuf,
-		   size_t count, loff_t *ppos)
-{
-	struct ath_node *an = file->private_data;
-	struct ath_airtime_stats *astats;
-	int i;
-
-	astats = &an->airtime_stats;
-	astats->rx_airtime = 0;
-	astats->tx_airtime = 0;
-	for (i = 0; i < 4; i++)
-		an->airtime_deficit[i] = ATH_AIRTIME_QUANTUM;
-	return count;
-}
-
-static const struct file_operations fops_airtime = {
-	.read = read_airtime,
-	.write = write_airtime_reset_stub,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
@@ -320,5 +251,4 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", 0444, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", 0444, dir, an, &fops_node_recv);
-	debugfs_create_file("airtime", 0644, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c070a9e51ebf..45a31f8a1514 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -676,8 +676,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(ATH_OP_INVALID, &common->op_flags);
-	sc->airtime_flags = (AIRTIME_USE_TX | AIRTIME_USE_RX |
-			     AIRTIME_USE_NEW_QUEUES);
 
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
@@ -1013,6 +1011,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 }
 
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 30d1bd832d90..285a62d3019d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1054,14 +1054,7 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 						len, rxs->rate_idx, is_sp);
 	}
 
- 	if (!!(sc->airtime_flags & AIRTIME_USE_RX)) {
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[acno] -= airtime;
-		if (an->airtime_deficit[acno] <= 0)
-			__ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, airtime, 0);
+	ieee80211_sta_register_airtime(sta, tidno, 0, airtime);
 exit:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 25b3fc82d4ac..d150db99451f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -113,44 +113,14 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 		ath_tx_status(hw, skb);
 }
 
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx = avp->chanctx;
-	struct ath_acq *acq;
-	struct list_head *tid_list;
-	u8 acno = TID_TO_WME_AC(tid->tidno);
-
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-
-	acq = &ctx->acq[acno];
-	if ((sc->airtime_flags & AIRTIME_USE_NEW_QUEUES) &&
-	    tid->an->airtime_deficit[acno] > 0)
-		tid_list = &acq->acq_new;
-	else
-		tid_list = &acq->acq_old;
-
-	list_add_tail(&tid->list, tid_list);
-}
-
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx = avp->chanctx;
-	struct ath_acq *acq;
+	struct ieee80211_txq *queue =
+		container_of((void *)tid, struct ieee80211_txq, drv_priv);
 
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	spin_lock_bh(&acq->lock);
-	__ath_tx_queue_tid(sc, tid);
-	spin_unlock_bh(&acq->lock);
+	ieee80211_return_txq(sc->hw, queue);
 }
 
-
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 {
 	struct ath_softc *sc = hw->priv;
@@ -163,11 +133,7 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 		tid->tidno);
 
 	ath_txq_lock(sc, txq);
-
-	tid->has_queued = true;
-	ath_tx_queue_tid(sc, tid);
 	ath_txq_schedule(sc, txq);
-
 	ath_txq_unlock(sc, txq);
 }
 
@@ -217,8 +183,8 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	return ATH_AN_2_TID(an, tidno);
 }
 
-static struct sk_buff *
-ath_tid_pull(struct ath_atx_tid *tid)
+static int
+ath_tid_pull(struct ath_atx_tid *tid, struct sk_buff **skbuf)
 {
 	struct ieee80211_txq *txq = container_of((void*)tid, struct ieee80211_txq, drv_priv);
 	struct ath_softc *sc = tid->an->sc;
@@ -229,20 +195,16 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	};
 	struct sk_buff *skb;
 	struct ath_frame_info *fi;
-	int q;
-
-	if (!tid->has_queued)
-		return NULL;
+	int q, ret;
 
 	skb = ieee80211_tx_dequeue(hw, txq);
-	if (!skb) {
-		tid->has_queued = false;
-		return NULL;
-	}
+	if (!skb)
+		return -ENOENT;
 
-	if (ath_tx_prepare(hw, skb, &txctl)) {
+	ret = ath_tx_prepare(hw, skb, &txctl);
+	if (ret) {
 		ieee80211_free_txskb(hw, skb);
-		return NULL;
+		return ret;
 	}
 
 	q = skb_get_queue_mapping(skb);
@@ -252,24 +214,19 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 		++tid->txq->pending_frames;
 	}
 
-	return skb;
-}
-
-
-static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
-{
-	return !skb_queue_empty(&tid->retry_q) || tid->has_queued;
+	*skbuf = skb;
+	return 0;
 }
 
-static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
+static int ath_tid_dequeue(struct ath_atx_tid *tid,
+			   struct sk_buff **skb)
 {
-	struct sk_buff *skb;
-
-	skb = __skb_dequeue(&tid->retry_q);
-	if (!skb)
-		skb = ath_tid_pull(tid);
+	int ret = 0;
+	*skb = __skb_dequeue(&tid->retry_q);
+	if (!*skb)
+		ret = ath_tid_pull(tid, skb);
 
-	return skb;
+	return ret;
 }
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
@@ -365,11 +322,12 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	struct list_head bf_head;
 	struct ath_tx_status ts;
 	struct ath_frame_info *fi;
+	int ret;
 
 	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
 
-	while ((skb = ath_tid_dequeue(tid))) {
+	while ((ret = ath_tid_dequeue(tid, &skb)) == 0) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
@@ -681,7 +639,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
 			ath_tx_queue_tid(sc, tid);
-
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->clear_ps_filter = true;
 		}
@@ -708,11 +665,11 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
-static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
-				 struct ath_atx_tid *tid, struct ath_buf *bf,
+static void ath_tx_count_airtime(struct ath_softc *sc,
+				 struct ieee80211_sta *sta,
+				 struct ath_buf *bf,
 				 struct ath_tx_status *ts)
 {
-	struct ath_txq *txq = tid->txq;
 	u32 airtime = 0;
 	int i;
 
@@ -722,17 +679,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	if (sc->airtime_flags & AIRTIME_USE_TX) {
-		int q = txq->mac80211_qnum;
-		struct ath_acq *acq = &sc->cur_chan->acq[q];
-
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[q] -= airtime;
-		if (an->airtime_deficit[q] <= 0)
-			__ath_tx_queue_tid(sc, tid);
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, 0, airtime);
+	ieee80211_sta_register_airtime(sta, ts->tid, airtime, 0);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -762,7 +709,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, an, tid, bf, ts);
+		ath_tx_count_airtime(sc, sta, bf, ts);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
@@ -946,20 +893,21 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	return ndelim;
 }
 
-static struct ath_buf *
+static int
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
-			struct ath_atx_tid *tid)
+			struct ath_atx_tid *tid, struct ath_buf **buf)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
-	struct sk_buff *skb, *first_skb = NULL;
 	struct ath_buf *bf;
+	struct sk_buff *skb, *first_skb = NULL;
 	u16 seqno;
+	int ret;
 
 	while (1) {
-		skb = ath_tid_dequeue(tid);
-		if (!skb)
-			break;
+		ret = ath_tid_dequeue(tid, &skb);
+		if (ret < 0)
+			return ret;
 
 		fi = get_frame_info(skb);
 		bf = fi->bf;
@@ -991,7 +939,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type = 0;
-			return bf;
+			break;
 		}
 
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
@@ -1010,7 +958,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 					first_skb = skb;
 				continue;
 			}
-			break;
+			return -EINPROGRESS;
 		}
 
 		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
@@ -1027,10 +975,11 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 		if (bf_isampdu(bf))
 			ath_tx_addto_baw(sc, tid, bf);
 
-		return bf;
+		break;
 	}
 
-	return NULL;
+	*buf = bf;
+	return 0;
 }
 
 static int
@@ -1040,7 +989,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf = bf_first, *bf_prev = NULL;
-	int nframes = 0, ndelim;
+	int nframes = 0, ndelim, ret;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 	    al_delta, h_baw = tid->baw_size / 2;
 	struct ieee80211_tx_info *tx_info;
@@ -1092,7 +1041,9 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 		bf_prev = bf;
 
-		bf = ath_tx_get_tid_subframe(sc, txq, tid);
+		ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
+			break;
 	}
 	goto finish;
 stop:
@@ -1489,7 +1440,7 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		  struct ath_buf *bf_first)
 {
 	struct ath_buf *bf = bf_first, *bf_prev = NULL;
-	int nframes = 0;
+	int nframes = 0, ret;
 
 	do {
 		struct ieee80211_tx_info *tx_info;
@@ -1503,8 +1454,8 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		if (nframes >= 2)
 			break;
 
-		bf = ath_tx_get_tid_subframe(sc, txq, tid);
-		if (!bf)
+		ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
 			break;
 
 		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
@@ -1517,30 +1468,27 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 	} while (1);
 }
 
-static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid)
+static int ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
-	struct ath_buf *bf;
+	struct ath_buf *bf = NULL;
 	struct ieee80211_tx_info *tx_info;
 	struct list_head bf_q;
-	int aggr_len = 0;
+	int aggr_len = 0, ret;
 	bool aggr;
 
-	if (!ath_tid_has_buffered(tid))
-		return false;
-
 	INIT_LIST_HEAD(&bf_q);
 
-	bf = ath_tx_get_tid_subframe(sc, txq, tid);
-	if (!bf)
-		return false;
+	ret = ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+	if (ret < 0)
+		return ret;
 
 	tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
-		return false;
+		return -EBUSY;
 	}
 
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
@@ -1550,7 +1498,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_form_burst(sc, txq, tid, &bf_q, bf);
 
 	if (list_empty(&bf_q))
-		return false;
+		return -EAGAIN;
 
 	if (tid->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->clear_ps_filter = false;
@@ -1559,7 +1507,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_tx_fill_desc(sc, bf, txq, aggr_len);
 	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-	return true;
+	return 0;
 }
 
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1622,28 +1570,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
-	struct ath_txq *txq;
 	int tidno;
 
 	ath_dbg(common, XMIT, "%s called\n", __func__);
 
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
-		txq = tid->txq;
-
-		ath_txq_lock(sc, txq);
-
-		if (list_empty(&tid->list)) {
-			ath_txq_unlock(sc, txq);
-			continue;
-		}
 
 		if (!skb_queue_empty(&tid->retry_q))
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
-		list_del_init(&tid->list);
-
-		ath_txq_unlock(sc, txq);
 	}
 }
 
@@ -1662,11 +1598,12 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter = true;
-		if (ath_tid_has_buffered(tid)) {
+		if (!skb_queue_empty(&tid->retry_q)) {
 			ath_tx_queue_tid(sc, tid);
 			ath_txq_schedule(sc, txq);
 		}
 		ath_txq_unlock_complete(sc, txq);
+
 	}
 }
 
@@ -1697,9 +1634,9 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 	struct ath_txq *txq = sc->tx.uapsdq;
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
-	struct ath_buf *bf_tail = NULL, *bf;
+	struct ath_buf *bf_tail = NULL, *bf = NULL;
 	int sent = 0;
-	int i;
+	int i, ret;
 
 	INIT_LIST_HEAD(&bf_q);
 	for (i = 0; tids && nframes; i++, tids >>= 1) {
@@ -1712,8 +1649,9 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 
 		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
-			bf = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
-			if (!bf)
+			ret = ath_tx_get_tid_subframe(sc, sc->tx.uapsdq,
+						      tid, &bf);
+			if (ret < 0)
 				break;
 
 			ath9k_set_moredata(sc, bf, true);
@@ -1979,11 +1917,11 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
+	struct ieee80211_hw *hw = sc->hw;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *queue;
 	struct ath_atx_tid *tid;
-	struct list_head *tid_list;
-	struct ath_acq *acq;
-	bool active = AIRTIME_ACTIVE(sc->airtime_flags);
+	int ret;
 
 	if (txq->mac80211_qnum < 0)
 		return;
@@ -1991,58 +1929,26 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 		return;
 
+	ieee80211_txq_schedule_start(hw, txq->mac80211_qnum);
 	spin_lock_bh(&sc->chan_lock);
 	rcu_read_lock();
-	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
 
 	if (sc->cur_chan->stopped)
 		goto out;
 
-begin:
-	tid_list = &acq->acq_new;
-	if (list_empty(tid_list)) {
-		tid_list = &acq->acq_old;
-		if (list_empty(tid_list))
-			goto out;
-	}
-	tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-
-	if (active && tid->an->airtime_deficit[txq->mac80211_qnum] <= 0) {
-		spin_lock_bh(&acq->lock);
-		tid->an->airtime_deficit[txq->mac80211_qnum] += ATH_AIRTIME_QUANTUM;
-		list_move_tail(&tid->list, &acq->acq_old);
-		spin_unlock_bh(&acq->lock);
-		goto begin;
-	}
-
-	if (!ath_tid_has_buffered(tid)) {
-		spin_lock_bh(&acq->lock);
-		if ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old))
-			list_move_tail(&tid->list, &acq->acq_old);
-		else {
-			list_del_init(&tid->list);
-		}
-		spin_unlock_bh(&acq->lock);
-		goto begin;
-	}
+	while ((queue = ieee80211_next_txq(hw, txq->mac80211_qnum))) {
+		tid = (struct ath_atx_tid *)queue->drv_priv;
 
+		ret = ath_tx_sched_aggr(sc, txq, tid);
+		ath_dbg(common, QUEUE, "ath_tx_sched_aggr returned %d\n", ret);
 
-	/*
-	 * If we succeed in scheduling something, immediately restart to make
-	 * sure we keep the HW busy.
-	 */
-	if(ath_tx_sched_aggr(sc, txq, tid)) {
-		if (!active) {
-			spin_lock_bh(&acq->lock);
-			list_move_tail(&tid->list, &acq->acq_old);
-			spin_unlock_bh(&acq->lock);
-		}
-		goto begin;
+		ieee80211_return_txq(hw, queue);
 	}
 
 out:
 	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
+	ieee80211_txq_schedule_end(hw, txq->mac80211_qnum);
 }
 
 void ath_txq_schedule_all(struct ath_softc *sc)
@@ -2886,9 +2792,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
-	for (acno = 0; acno < IEEE80211_NUM_ACS; acno++)
-		an->airtime_deficit[acno] = ATH_AIRTIME_QUANTUM;
-
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		tid->an        = an;
@@ -2898,7 +2801,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->active	   = false;
 		tid->clear_ps_filter = true;
-		tid->has_queued  = false;
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno = TID_TO_WME_AC(tidno);
-- 
1.9.1

