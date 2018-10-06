Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E952C71151
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE6C2064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WYUz/S7n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFE6C2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbeJGAjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
Received: from nbd.name ([46.4.11.11]:35808 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbeJGAjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RzZqYTJjZRZUFZAA+yW+YkC/wQNmGTe2+ElYyFqdS+s=; b=WYUz/S7nyLhkNxqrNAbb9cOuKd
        MoX2ia+MNqIo1V3sSPtEzy0+YLaUzOckxTS+mo/jzaVpbgU6ikorfcN2cIujQgL0iFt9lo96utaTR
        Vf3+o/DBipU64fijym6ZRAiCSkpawXjR0Fs4F5+UrmKGt2cc7MXvp/BzfKPlswNIwn+w=;
Received: by maeck.local (Postfix, from userid 501)
        id 2F3F53E6EAF7; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 2/9] mac80211: minstrel: remove unnecessary debugfs cleanup code
Date:   Sat,  6 Oct 2018 19:35:00 +0200
Message-Id: <20181006173507.7316-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

debugfs entries are cleaned up by debugfs_remove_recursive already.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.c            |  8 ++------
 net/mac80211/rc80211_minstrel.h            |  7 -------
 net/mac80211/rc80211_minstrel_debugfs.c    | 18 +++---------------
 net/mac80211/rc80211_minstrel_ht.c         |  1 -
 net/mac80211/rc80211_minstrel_ht.h         |  5 -----
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 17 ++++-------------
 6 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index fc6134c01a76..eac61242238a 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -689,8 +689,8 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	mp->fixed_rate_idx = (u32) -1;
-	mp->dbg_fixed_rate = debugfs_create_u32("fixed_rate_idx",
-			0666, debugfsdir, &mp->fixed_rate_idx);
+	debugfs_create_u32("fixed_rate_idx", 0666, debugfsdir,
+			   &mp->fixed_rate_idx);
 #endif
 
 	minstrel_init_cck_rates(mp);
@@ -701,9 +701,6 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 static void
 minstrel_free(void *priv)
 {
-#ifdef CONFIG_MAC80211_DEBUGFS
-	debugfs_remove(((struct minstrel_priv *)priv)->dbg_fixed_rate);
-#endif
 	kfree(priv);
 }
 
@@ -735,7 +732,6 @@ const struct rate_control_ops mac80211_minstrel = {
 	.free_sta = minstrel_free_sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
-	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
 	.get_expected_throughput = minstrel_get_expected_throughput,
 };
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index be6c3f35f48b..6abe8bf603e2 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -109,11 +109,6 @@ struct minstrel_sta_info {
 
 	/* sampling table */
 	u8 *sample_table;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *dbg_stats;
-	struct dentry *dbg_stats_csv;
-#endif
 };
 
 struct minstrel_priv {
@@ -137,7 +132,6 @@ struct minstrel_priv {
 	 *   - setting will be applied on next update
 	 */
 	u32 fixed_rate_idx;
-	struct dentry *dbg_fixed_rate;
 #endif
 };
 
@@ -156,7 +150,6 @@ minstrel_get_ewmsd10(struct minstrel_rate_stats *mrs)
 
 extern const struct rate_control_ops mac80211_minstrel;
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
-void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
 /* Recalculate success probabilities and counters for a given rate using EWMA */
 void minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs);
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 9ad7d63d3e5b..2e7266b81b19 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -214,19 +214,7 @@ minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
 {
 	struct minstrel_sta_info *mi = priv_sta;
 
-	mi->dbg_stats = debugfs_create_file("rc_stats", 0444, dir, mi,
-					    &minstrel_stat_fops);
-
-	mi->dbg_stats_csv = debugfs_create_file("rc_stats_csv", 0444, dir, mi,
-						&minstrel_stat_csv_fops);
-}
-
-void
-minstrel_remove_sta_debugfs(void *priv, void *priv_sta)
-{
-	struct minstrel_sta_info *mi = priv_sta;
-
-	debugfs_remove(mi->dbg_stats);
-
-	debugfs_remove(mi->dbg_stats_csv);
+	debugfs_create_file("rc_stats", 0444, dir, mi, &minstrel_stat_fops);
+	debugfs_create_file("rc_stats_csv", 0444, dir, mi,
+			    &minstrel_stat_csv_fops);
 }
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 16d1ac30978d..818552ba61d0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1391,7 +1391,6 @@ static const struct rate_control_ops mac80211_minstrel_ht = {
 	.free = minstrel_ht_free,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
-	.remove_sta_debugfs = minstrel_ht_remove_sta_debugfs,
 #endif
 	.get_expected_throughput = minstrel_ht_get_expected_throughput,
 };
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index de1646c42e82..50f2a8d004c4 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -110,17 +110,12 @@ struct minstrel_ht_sta_priv {
 		struct minstrel_ht_sta ht;
 		struct minstrel_sta_info legacy;
 	};
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *dbg_stats;
-	struct dentry *dbg_stats_csv;
-#endif
 	void *ratelist;
 	void *sample_table;
 	bool is_ht;
 };
 
 void minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
-void minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta);
 int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
 			   int prob_ewma);
 
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index bfcc03152dc6..afc7c65ebfad 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -303,17 +303,8 @@ minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
 {
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 
-	msp->dbg_stats = debugfs_create_file("rc_stats", 0444, dir, msp,
-					     &minstrel_ht_stat_fops);
-	msp->dbg_stats_csv = debugfs_create_file("rc_stats_csv", 0444, dir, msp,
-						 &minstrel_ht_stat_csv_fops);
-}
-
-void
-minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta)
-{
-	struct minstrel_ht_sta_priv *msp = priv_sta;
-
-	debugfs_remove(msp->dbg_stats);
-	debugfs_remove(msp->dbg_stats_csv);
+	debugfs_create_file("rc_stats", 0444, dir, msp,
+			    &minstrel_ht_stat_fops);
+	debugfs_create_file("rc_stats_csv", 0444, dir, msp,
+			    &minstrel_ht_stat_csv_fops);
 }
-- 
2.17.0

