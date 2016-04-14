Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36005 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbcDNMQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:16:35 -0400
Received: by mail-lf0-f45.google.com with SMTP id g184so106240480lfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 05:16:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv3 5/5] mac80211: add debug knobs for codel
Date: Thu, 14 Apr 2016 14:18:22 +0200
Message-Id: <1460636302-31161-6-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141642_455824_2E1E46F6)
In-Reply-To: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few debugfs entries to make it easier
to test, debug and experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/debugfs.c     | 14 ++++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/tx.c          | 21 ++++++++++++++-------
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5cbaa5872e6b..9088e505fa85 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -132,6 +132,10 @@ DEBUGFS_READONLY_FILE(fq_overlimit, "%u",
 		      local->fq.overlimit);
 DEBUGFS_READONLY_FILE(fq_collisions, "%u",
 		      local->fq.collisions);
+DEBUGFS_READONLY_FILE(codel_drop_count, "%u",
+		      local->cdrop_count);
+DEBUGFS_READONLY_FILE(codel_ecn_mark, "%u",
+		      local->cecn_mark);
 
 DEBUGFS_RW_FILE(fq_limit,
 		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.limit),
@@ -139,6 +143,12 @@ DEBUGFS_RW_FILE(fq_limit,
 DEBUGFS_RW_FILE(fq_quantum,
 		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.quantum),
 		"%u", local->fq.quantum);
+DEBUGFS_RW_FILE(codel_interval,
+		DEBUGFS_RW_EXPR_FQ("%llu", &local->cparams.interval),
+		"%llu", local->cparams.interval);
+DEBUGFS_RW_FILE(codel_target,
+		DEBUGFS_RW_EXPR_FQ("%llu", &local->cparams.target),
+		"%llu", local->cparams.target);
 
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
@@ -330,6 +340,10 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(fq_collisions);
 	DEBUGFS_ADD(fq_limit);
 	DEBUGFS_ADD(fq_quantum);
+	DEBUGFS_ADD(codel_interval);
+	DEBUGFS_ADD(codel_target);
+	DEBUGFS_ADD(codel_drop_count);
+	DEBUGFS_ADD(codel_ecn_mark);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 78953b495a25..7aecb7b6528c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1111,6 +1111,8 @@ struct ieee80211_local {
 	struct fq fq;
 	struct codel_vars *cvars;
 	struct codel_params cparams;
+	unsigned int cdrop_count;
+	unsigned int cecn_mark;
 
 	const struct ieee80211_ops *ops;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 238cb8e979fd..b5506411b8e6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1314,6 +1314,7 @@ static void codel_drop_fn(void *ctx,
 	local = vif_to_sdata(txqi->txq.vif)->local;
 	hw = &local->hw;
 
+	local->cdrop_count++;
 	ieee80211_free_txskb(hw, skb);
 }
 
@@ -1325,6 +1326,8 @@ static struct sk_buff *fq_tin_dequeue_fn(struct fq *fq,
 	struct txq_info *txqi;
 	struct codel_vars *cvars;
 	struct codel_params *cparams;
+	struct sk_buff *skb;
+	u16 ecn_mark;
 	bool overloaded;
 
 	local = container_of(fq, struct ieee80211_local, fq);
@@ -1339,13 +1342,17 @@ static struct sk_buff *fq_tin_dequeue_fn(struct fq *fq,
 	/* TODO */
 	overloaded = false;
 
-	return codel_dequeue(txqi,
-			     &flow->backlog,
-			     0,
-			     cvars,
-			     cparams,
-			     codel_get_time(),
-			     overloaded);
+	ecn_mark = cvars->ecn_mark;
+	skb = codel_dequeue(txqi,
+			    &flow->backlog,
+			    0,
+			    cvars,
+			    cparams,
+			    codel_get_time(),
+			    overloaded);
+	local->cecn_mark += cvars->ecn_mark - ecn_mark;
+
+	return skb;
 }
 
 static void fq_skb_free_fn(struct fq *fq,
-- 
2.1.4

