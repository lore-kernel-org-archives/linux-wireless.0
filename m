Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF51C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 21:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C2020675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 21:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="itidrtIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbfAPVcP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 16:32:15 -0500
Received: from nbd.name ([46.4.11.11]:46314 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbfAPVcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 16:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0AZnvvlabSkPtim/q/SLIQiUkv0lZiMoP7gknjuLkFY=; b=itidrtIzN1omg91nQou9c/J80U
        aeYe5e7BOww8s1QHNOpc9KswtS4N4uHMgbMsP9rZwkSLkyLZ9cy49QygcnrX/nM5qlEwkg45o/12N
        355nynJlKHgVDOcWlHyPssLK0lBJsTZdPTSZ141cjhyWjW19l44Z3lgs1R1Q2C8zHuwc=;
Received: by maeck.lan (Postfix, from userid 501)
        id 763A64C4B0D5; Wed, 16 Jan 2019 22:32:12 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: minstrel_ht: add flag to indicate missing/inaccurate tx A-MPDU length
Date:   Wed, 16 Jan 2019 22:32:12 +0100
Message-Id: <20190116213212.58416-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some hardware (e.g. MediaTek MT7603) cannot report A-MPDU length in tx status
information. Add support for a flag to indicate that, to allow minstrel_ht
to use a fixed value in its internal calculation (which gives better results
than just defaulting to 1).

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h                     |  4 ++++
 net/mac80211/debugfs.c                     |  1 +
 net/mac80211/rc80211_minstrel_ht.c         | 25 +++++++++++++++++-----
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  7 +++---
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 88219cc137c3..b7361480b376 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2184,6 +2184,9 @@ struct ieee80211_txq {
  *	MMPDUs on station interfaces. This of course requires the driver to use
  *	TXQs to start with.
  *
+ * @IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN: Driver does not report accurate A-MPDU
+ *	length in tx status information
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2232,6 +2235,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_BUFF_MMPDU_TXQ,
 	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 	IEEE80211_HW_STA_MMPDU_TXQ,
+	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3fe541e358f3..eae38b79690c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -218,6 +218,7 @@ static const char *hw_flag_names[] = {
 	FLAG(BUFF_MMPDU_TXQ),
 	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 	FLAG(STA_MMPDU_TXQ),
+	FLAG(TX_STATUS_NO_AMPDU_LEN),
 #undef FLAG
 };
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index f466ec37d161..ccaf951e4e31 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -294,6 +294,15 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
 	return &mi->groups[index / MCS_GROUP_RATES].rates[index % MCS_GROUP_RATES];
 }
 
+static unsigned int
+minstrel_ht_avg_ampdu_len(struct minstrel_ht_sta *mi)
+{
+	if (!mi->avg_ampdu_len)
+		return AVG_AMPDU_SIZE;
+
+	return MINSTREL_TRUNC(mi->avg_ampdu_len);
+}
+
 /*
  * Return current throughput based on the average A-MPDU length, taking into
  * account the expected number of retransmissions and their expected length
@@ -309,7 +318,7 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
 		return 0;
 
 	if (group != MINSTREL_CCK_GROUP)
-		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
+		nsecs = 1000 * mi->overhead / minstrel_ht_avg_ampdu_len(mi);
 
 	nsecs += minstrel_mcs_groups[group].duration[rate] <<
 		 minstrel_mcs_groups[group].shift;
@@ -503,8 +512,12 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	u16 tmp_cck_tp_rate[MAX_THR_RATES], index;
 
 	if (mi->ampdu_packets > 0) {
-		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
-			MINSTREL_FRAC(mi->ampdu_len, mi->ampdu_packets), EWMA_LEVEL);
+		if (!ieee80211_hw_check(mp->hw, TX_STATUS_NO_AMPDU_LEN))
+			mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
+				MINSTREL_FRAC(mi->ampdu_len, mi->ampdu_packets),
+					      EWMA_LEVEL);
+		else
+			mi->avg_ampdu_len = 0;
 		mi->ampdu_len = 0;
 		mi->ampdu_packets = 0;
 	}
@@ -709,7 +722,9 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	mi->ampdu_len += info->status.ampdu_len;
 
 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
-		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
+		int avg_ampdu_len = minstrel_ht_avg_ampdu_len(mi);
+
+		mi->sample_wait = 16 + 2 * avg_ampdu_len;
 		mi->sample_tries = 1;
 		mi->sample_count--;
 	}
@@ -777,7 +792,7 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	unsigned int cw = mp->cw_min;
 	unsigned int ctime = 0;
 	unsigned int t_slot = 9; /* FIXME */
-	unsigned int ampdu_len = MINSTREL_TRUNC(mi->avg_ampdu_len);
+	unsigned int ampdu_len = minstrel_ht_avg_ampdu_len(mi);
 	unsigned int overhead = 0, overhead_rtscts = 0;
 
 	mrs = minstrel_get_ratestats(mi, index);
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 57820a5f2c16..31641d0b0f5c 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -160,9 +160,10 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 			"lookaround %d\n",
 			max(0, (int) mi->total_packets - (int) mi->sample_packets),
 			mi->sample_packets);
-	p += sprintf(p, "Average # of aggregated frames per A-MPDU: %d.%d\n",
-		MINSTREL_TRUNC(mi->avg_ampdu_len),
-		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
+	if (mi->avg_ampdu_len)
+		p += sprintf(p, "Average # of aggregated frames per A-MPDU: %d.%d\n",
+			MINSTREL_TRUNC(mi->avg_ampdu_len),
+			MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
 	WARN_ON(ms->len + sizeof(*ms) > 32768);
 
-- 
2.17.0

