Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6341DC71151
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 179982064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WipAY+ka"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 179982064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbeJGAjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
Received: from nbd.name ([46.4.11.11]:35786 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbeJGAjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2dm737zRzRAkztju5uAZ/bIjpn/tbXOilSXsYIK2RSA=; b=WipAY+kaDH24Ss0pRzTz3EZCUO
        0VLaXyKeA+xyO1lbeeOmueEqVjXpz0VA4EieM8tuPhWwZDJHp78cDfwl0WVNbj2cjqBRmc+7T8skD
        0XiyvYDOvJMJoH/Qz3ZuSlQmpr9kJzv5ODK/ZCez12bw4yH8bFrTAHOxzi8WnvKNCJEM=;
Received: by maeck.local (Postfix, from userid 501)
        id 2EA833E6EAF5; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 9/9] mac80211: rc80211_minstrel: remove variance / stddev calculation
Date:   Sat,  6 Oct 2018 19:35:07 +0200
Message-Id: <20181006173507.7316-9-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When there are few packets (e.g. for sampling attempts), the exponentially
weighted variance is usually vastly overestimated, making the resulting data
essentially useless. As far as I know, there has not been any practical use
for this, so let's not waste any cycles on it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.c            |  6 -----
 net/mac80211/rc80211_minstrel.h            | 26 +---------------------
 net/mac80211/rc80211_minstrel_debugfs.c    | 14 ++++--------
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 14 ++++--------
 4 files changed, 9 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index dead57ba9eac..a34e9c2ca626 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -167,12 +167,6 @@ minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
 		if (unlikely(!mrs->att_hist)) {
 			mrs->prob_ewma = cur_prob;
 		} else {
-			/* update exponential weighted moving variance */
-			mrs->prob_ewmv = minstrel_ewmv(mrs->prob_ewmv,
-							cur_prob,
-							mrs->prob_ewma,
-							EWMA_LEVEL);
-
 			/*update exponential weighted moving avarage */
 			mrs->prob_ewma = minstrel_ewma(mrs->prob_ewma,
 						       cur_prob,
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 54b2b2c3e10a..23ec953e3a24 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -35,19 +35,6 @@ minstrel_ewma(int old, int new, int weight)
 	return old + incr;
 }
 
-/*
- * Perform EWMV (Exponentially Weighted Moving Variance) calculation
- */
-static inline int
-minstrel_ewmv(int old_ewmv, int cur_prob, int prob_ewma, int weight)
-{
-	int diff, incr;
-
-	diff = cur_prob - prob_ewma;
-	incr = (EWMA_DIV - weight) * diff / EWMA_DIV;
-	return weight * (old_ewmv + MINSTREL_TRUNC(diff * incr)) / EWMA_DIV;
-}
-
 struct minstrel_rate_stats {
 	/* current / last sampling period attempts/success counters */
 	u16 attempts, last_attempts;
@@ -56,11 +43,8 @@ struct minstrel_rate_stats {
 	/* total attempts/success counters */
 	u32 att_hist, succ_hist;
 
-	/* statistis of packet delivery probability
-	 *  prob_ewma - exponential weighted moving average of prob
-	 *  prob_ewmsd - exp. weighted moving standard deviation of prob */
+	/* prob_ewma - exponential weighted moving average of prob */
 	u16 prob_ewma;
-	u16 prob_ewmv;
 
 	/* maximum retry counts */
 	u8 retry_count;
@@ -140,14 +124,6 @@ struct minstrel_debugfs_info {
 	char buf[];
 };
 
-/* Get EWMSD (Exponentially Weighted Moving Standard Deviation) * 10 */
-static inline int
-minstrel_get_ewmsd10(struct minstrel_rate_stats *mrs)
-{
-	unsigned int ewmv = mrs->prob_ewmv;
-	return int_sqrt(MINSTREL_TRUNC(ewmv * 1000 * 1000));
-}
-
 extern const struct rate_control_ops mac80211_minstrel;
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 698a668b5316..c8afd85b51a0 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -70,14 +70,13 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	p = ms->buf;
 	p += sprintf(p, "\n");
 	p += sprintf(p,
-		     "best   __________rate_________    ________statistics________    ____last_____    ______sum-of________\n");
+		     "best   __________rate_________    ____statistics___    ____last_____    ______sum-of________\n");
 	p += sprintf(p,
-		     "rate  [name idx airtime max_tp]  [avg(tp) avg(prob) sd(prob)]  [retry|suc|att]  [#success | #attempts]\n");
+		     "rate  [name idx airtime max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]\n");
 
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
-		unsigned int prob_ewmsd;
 
 		*(p++) = (i == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (i == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -93,15 +92,13 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		tp_max = minstrel_get_tp_avg(mr, MINSTREL_FRAC(100,100));
 		tp_avg = minstrel_get_tp_avg(mr, mrs->prob_ewma);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
-		prob_ewmsd = minstrel_get_ewmsd10(mrs);
 
-		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.%1u"
+		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u"
 				"     %3u   %3u %-3u   "
 				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
-				prob_ewmsd / 10, prob_ewmsd % 10,
 				mrs->retry_count,
 				mrs->last_success,
 				mrs->last_attempts,
@@ -137,7 +134,6 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
-		unsigned int prob_ewmsd;
 
 		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[0]) ? "A" : ""));
 		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[1]) ? "B" : ""));
@@ -153,14 +149,12 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 		tp_max = minstrel_get_tp_avg(mr, MINSTREL_FRAC(100,100));
 		tp_avg = minstrel_get_tp_avg(mr, mrs->prob_ewma);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
-		prob_ewmsd = minstrel_get_ewmsd10(mrs);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,"
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
 				"%llu,%llu,%d,%d\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
-				prob_ewmsd / 10, prob_ewmsd % 10,
 				mrs->retry_count,
 				mrs->last_success,
 				mrs->last_attempts,
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 8065da2cf0f1..57820a5f2c16 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -57,7 +57,6 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		struct minstrel_rate_stats *mrs = &mi->groups[i].rates[j];
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
-		unsigned int prob_ewmsd;
 		unsigned int duration;
 
 		if (!(mi->supported[i] & BIT(j)))
@@ -104,15 +103,13 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
 		tp_avg = minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewma);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
-		prob_ewmsd = minstrel_get_ewmsd10(mrs);
 
-		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.%1u"
+		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u"
 				"     %3u   %3u %-3u   "
 				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
-				prob_ewmsd / 10, prob_ewmsd % 10,
 				mrs->retry_count,
 				mrs->last_success,
 				mrs->last_attempts,
@@ -149,9 +146,9 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	p += sprintf(p, "\n");
 	p += sprintf(p,
-		     "              best   ____________rate__________    ________statistics________    _____last____    ______sum-of________\n");
+		     "              best   ____________rate__________    ____statistics___    _____last____    ______sum-of________\n");
 	p += sprintf(p,
-		     "mode guard #  rate  [name   idx airtime  max_tp]  [avg(tp) avg(prob) sd(prob)]  [retry|suc|att]  [#success | #attempts]\n");
+		     "mode guard #  rate  [name   idx airtime  max_tp]  [avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]\n");
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
 	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
@@ -206,7 +203,6 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		struct minstrel_rate_stats *mrs = &mi->groups[i].rates[j];
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
-		unsigned int prob_ewmsd;
 		unsigned int duration;
 
 		if (!(mi->supported[i] & BIT(j)))
@@ -251,14 +247,12 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
 		tp_avg = minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewma);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
-		prob_ewmsd = minstrel_get_ewmsd10(mrs);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,"
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,"
 				"%u,%llu,%llu,",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
-				prob_ewmsd / 10, prob_ewmsd % 10,
 				mrs->retry_count,
 				mrs->last_success,
 				mrs->last_attempts,
-- 
2.17.0

