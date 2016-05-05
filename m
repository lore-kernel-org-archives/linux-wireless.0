Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35827 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbcEEK65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 06:58:57 -0400
Received: by mail-lf0-f54.google.com with SMTP id j8so91363278lfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 03:58:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv4 5/5] mac80211: add debug knobs for codel
Date: Thu,  5 May 2016 13:00:39 +0200
Message-Id: <1462446039-1070-6-git-send-email-michal.kazior@tieto.com> (sfid-20160505_125900_847285_8503B645)
In-Reply-To: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
 <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few debugfs entries to make it easier
to test, debug and experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v4:
     * stats adjustments (in-kernel codel has more of them)

 net/mac80211/debugfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 43592b6f79f0..c7cfedc61fc4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -124,6 +124,15 @@ static const struct file_operations name## _ops = {	\
 	res;								\
 })
 
+#define DEBUGFS_RW_BOOL(arg)						\
+({									\
+	int res;							\
+	int val;							\
+	res = mac80211_parse_buffer(userbuf, count, ppos, "%d", &val);	\
+	arg = !!(val);							\
+	res;								\
+})
+
 DEBUGFS_READONLY_FILE(fq_flows_cnt, "%u",
 		      local->fq.flows_cnt);
 DEBUGFS_READONLY_FILE(fq_backlog, "%u",
@@ -132,6 +141,16 @@ DEBUGFS_READONLY_FILE(fq_overlimit, "%u",
 		      local->fq.overlimit);
 DEBUGFS_READONLY_FILE(fq_collisions, "%u",
 		      local->fq.collisions);
+DEBUGFS_READONLY_FILE(codel_maxpacket, "%u",
+		      local->cstats.maxpacket);
+DEBUGFS_READONLY_FILE(codel_drop_count, "%u",
+		      local->cstats.drop_count);
+DEBUGFS_READONLY_FILE(codel_drop_len, "%u",
+		      local->cstats.drop_len);
+DEBUGFS_READONLY_FILE(codel_ecn_mark, "%u",
+		      local->cstats.ecn_mark);
+DEBUGFS_READONLY_FILE(codel_ce_mark, "%u",
+		      local->cstats.ce_mark);
 
 DEBUGFS_RW_FILE(fq_limit,
 		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.limit),
@@ -139,6 +158,18 @@ DEBUGFS_RW_FILE(fq_limit,
 DEBUGFS_RW_FILE(fq_quantum,
 		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.quantum),
 		"%u", local->fq.quantum);
+DEBUGFS_RW_FILE(codel_interval,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.interval),
+		"%u", local->cparams.interval);
+DEBUGFS_RW_FILE(codel_target,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.target),
+		"%u", local->cparams.target);
+DEBUGFS_RW_FILE(codel_mtu,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->cparams.mtu),
+		"%u", local->cparams.mtu);
+DEBUGFS_RW_FILE(codel_ecn,
+		DEBUGFS_RW_BOOL(local->cparams.ecn),
+		"%d", local->cparams.ecn ? 1 : 0);
 
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
@@ -333,6 +364,15 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(fq_collisions);
 	DEBUGFS_ADD(fq_limit);
 	DEBUGFS_ADD(fq_quantum);
+	DEBUGFS_ADD(codel_maxpacket);
+	DEBUGFS_ADD(codel_drop_count);
+	DEBUGFS_ADD(codel_drop_len);
+	DEBUGFS_ADD(codel_ecn_mark);
+	DEBUGFS_ADD(codel_ce_mark);
+	DEBUGFS_ADD(codel_interval);
+	DEBUGFS_ADD(codel_target);
+	DEBUGFS_ADD(codel_mtu);
+	DEBUGFS_ADD(codel_ecn);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
-- 
2.1.4

