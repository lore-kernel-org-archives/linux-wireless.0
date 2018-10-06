Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D0CECDE27
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47982064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tazDlVSY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C47982064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbeJGAjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
Received: from nbd.name ([46.4.11.11]:35816 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbeJGAjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fhLahCDvDszxt4MhaxWzb5XuQAWAVY/PjB1kN8fUSEQ=; b=tazDlVSY0jpUyLW0kzPKodoh6p
        smWwlGhh0gX/yuRY5oCFIkl9sFDCDkBlvx8tUXjp9sjkAoW6rarEcWPfn6wUJxLlpzJkmcWpyJljS
        PhWmSFmlKiXfOWPjCJiNng/oMrexpKe7WAYIporoLhvUok0DH7jqbixHED1qQ/CokDro=;
Received: by maeck.local (Postfix, from userid 501)
        id 2F8143E6EAF8; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 3/9] mac80211: minstrel: merge with minstrel_ht, always enable VHT support
Date:   Sat,  6 Oct 2018 19:35:01 +0200
Message-Id: <20181006173507.7316-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Legacy-only devices are not very common and the overhead of the extra
code for HT and VHT rates is not big enough to justify all those extra
lines of code to make it optional.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/Kconfig                       |  17 +--
 net/mac80211/Makefile                      |  11 +-
 net/mac80211/main.c                        |   7 -
 net/mac80211/rate.h                        |  13 --
 net/mac80211/rc80211_minstrel.c            | 152 ---------------------
 net/mac80211/rc80211_minstrel.h            |   2 -
 net/mac80211/rc80211_minstrel_debugfs.c    |  42 ------
 net/mac80211/rc80211_minstrel_ht.c         |  91 ++++++++++--
 net/mac80211/rc80211_minstrel_ht.h         |   8 --
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  16 +++
 10 files changed, 101 insertions(+), 258 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 76e30f4797fb..f869e35d0974 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -27,20 +27,6 @@ config MAC80211_RC_MINSTREL
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
-config MAC80211_RC_MINSTREL_HT
-	bool "Minstrel 802.11n support" if EXPERT
-	depends on MAC80211_RC_MINSTREL
-	default y
-	---help---
-	  This option enables the 'minstrel_ht' TX rate control algorithm
-
-config MAC80211_RC_MINSTREL_VHT
-	bool "Minstrel 802.11ac support" if EXPERT
-	depends on MAC80211_RC_MINSTREL_HT
-	default n
-	---help---
-	  This option enables VHT in the 'minstrel_ht' TX rate control algorithm
-
 choice
 	prompt "Default rate control algorithm"
 	depends on MAC80211_HAS_RC
@@ -62,8 +48,7 @@ endchoice
 
 config MAC80211_RC_DEFAULT
 	string
-	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
-	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
+	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL
 	default ""
 
 endif
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index bb707789ef2b..4f03ebe732fa 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -53,13 +53,14 @@ mac80211-$(CONFIG_PM) += pm.o
 
 CFLAGS_trace.o := -I$(src)
 
-rc80211_minstrel-y := rc80211_minstrel.o
-rc80211_minstrel-$(CONFIG_MAC80211_DEBUGFS) += rc80211_minstrel_debugfs.o
+rc80211_minstrel-y := \
+	rc80211_minstrel.o \
+	rc80211_minstrel_ht.o
 
-rc80211_minstrel_ht-y := rc80211_minstrel_ht.o
-rc80211_minstrel_ht-$(CONFIG_MAC80211_DEBUGFS) += rc80211_minstrel_ht_debugfs.o
+rc80211_minstrel-$(CONFIG_MAC80211_DEBUGFS) += \
+	rc80211_minstrel_debugfs.o \
+	rc80211_minstrel_ht_debugfs.o
 
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL) += $(rc80211_minstrel-y)
-mac80211-$(CONFIG_MAC80211_RC_MINSTREL_HT) += $(rc80211_minstrel_ht-y)
 
 ccflags-y += -DDEBUG
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e6375d035355..83e71e6b2ebe 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1375,18 +1375,12 @@ static int __init ieee80211_init(void)
 	if (ret)
 		return ret;
 
-	ret = rc80211_minstrel_ht_init();
-	if (ret)
-		goto err_minstrel;
-
 	ret = ieee80211_iface_init();
 	if (ret)
 		goto err_netdev;
 
 	return 0;
  err_netdev:
-	rc80211_minstrel_ht_exit();
- err_minstrel:
 	rc80211_minstrel_exit();
 
 	return ret;
@@ -1394,7 +1388,6 @@ static int __init ieee80211_init(void)
 
 static void __exit ieee80211_exit(void)
 {
-	rc80211_minstrel_ht_exit();
 	rc80211_minstrel_exit();
 
 	ieee80211s_stop();
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 8212bfeb71d6..d59198191a79 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -95,18 +95,5 @@ static inline void rc80211_minstrel_exit(void)
 }
 #endif
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_HT
-int rc80211_minstrel_ht_init(void);
-void rc80211_minstrel_ht_exit(void);
-#else
-static inline int rc80211_minstrel_ht_init(void)
-{
-	return 0;
-}
-static inline void rc80211_minstrel_ht_exit(void)
-{
-}
-#endif
-
 
 #endif /* IEEE80211_RATE_H */
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index eac61242238a..dead57ba9eac 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -572,138 +572,6 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	minstrel_update_rates(mp, mi);
 }
 
-static void *
-minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
-{
-	struct ieee80211_supported_band *sband;
-	struct minstrel_sta_info *mi;
-	struct minstrel_priv *mp = priv;
-	struct ieee80211_hw *hw = mp->hw;
-	int max_rates = 0;
-	int i;
-
-	mi = kzalloc(sizeof(struct minstrel_sta_info), gfp);
-	if (!mi)
-		return NULL;
-
-	for (i = 0; i < NUM_NL80211_BANDS; i++) {
-		sband = hw->wiphy->bands[i];
-		if (sband && sband->n_bitrates > max_rates)
-			max_rates = sband->n_bitrates;
-	}
-
-	mi->r = kcalloc(max_rates, sizeof(struct minstrel_rate), gfp);
-	if (!mi->r)
-		goto error;
-
-	mi->sample_table = kmalloc_array(max_rates, SAMPLE_COLUMNS, gfp);
-	if (!mi->sample_table)
-		goto error1;
-
-	mi->last_stats_update = jiffies;
-	return mi;
-
-error1:
-	kfree(mi->r);
-error:
-	kfree(mi);
-	return NULL;
-}
-
-static void
-minstrel_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
-{
-	struct minstrel_sta_info *mi = priv_sta;
-
-	kfree(mi->sample_table);
-	kfree(mi->r);
-	kfree(mi);
-}
-
-static void
-minstrel_init_cck_rates(struct minstrel_priv *mp)
-{
-	static const int bitrates[4] = { 10, 20, 55, 110 };
-	struct ieee80211_supported_band *sband;
-	u32 rate_flags = ieee80211_chandef_rate_flags(&mp->hw->conf.chandef);
-	int i, j;
-
-	sband = mp->hw->wiphy->bands[NL80211_BAND_2GHZ];
-	if (!sband)
-		return;
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
-
-		if (rate->flags & IEEE80211_RATE_ERP_G)
-			continue;
-
-		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
-			continue;
-
-		for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
-			if (rate->bitrate != bitrates[j])
-				continue;
-
-			mp->cck_rates[j] = i;
-			break;
-		}
-	}
-}
-
-static void *
-minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
-{
-	struct minstrel_priv *mp;
-
-	mp = kzalloc(sizeof(struct minstrel_priv), GFP_ATOMIC);
-	if (!mp)
-		return NULL;
-
-	/* contention window settings
-	 * Just an approximation. Using the per-queue values would complicate
-	 * the calculations and is probably unnecessary */
-	mp->cw_min = 15;
-	mp->cw_max = 1023;
-
-	/* number of packets (in %) to use for sampling other rates
-	 * sample less often for non-mrr packets, because the overhead
-	 * is much higher than with mrr */
-	mp->lookaround_rate = 5;
-	mp->lookaround_rate_mrr = 10;
-
-	/* maximum time that the hw is allowed to stay in one MRR segment */
-	mp->segment_size = 6000;
-
-	if (hw->max_rate_tries > 0)
-		mp->max_retry = hw->max_rate_tries;
-	else
-		/* safe default, does not necessarily have to match hw properties */
-		mp->max_retry = 7;
-
-	if (hw->max_rates >= 4)
-		mp->has_mrr = true;
-
-	mp->hw = hw;
-	mp->update_interval = 100;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	mp->fixed_rate_idx = (u32) -1;
-	debugfs_create_u32("fixed_rate_idx", 0666, debugfsdir,
-			   &mp->fixed_rate_idx);
-#endif
-
-	minstrel_init_cck_rates(mp);
-
-	return mp;
-}
-
-static void
-minstrel_free(void *priv)
-{
-	kfree(priv);
-}
-
 static u32 minstrel_get_expected_throughput(void *priv_sta)
 {
 	struct minstrel_sta_info *mi = priv_sta;
@@ -722,28 +590,8 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 }
 
 const struct rate_control_ops mac80211_minstrel = {
-	.name = "minstrel",
 	.tx_status_ext = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
 	.rate_init = minstrel_rate_init,
-	.alloc = minstrel_alloc,
-	.free = minstrel_free,
-	.alloc_sta = minstrel_alloc_sta,
-	.free_sta = minstrel_free_sta,
-#ifdef CONFIG_MAC80211_DEBUGFS
-	.add_sta_debugfs = minstrel_add_sta_debugfs,
-#endif
 	.get_expected_throughput = minstrel_get_expected_throughput,
 };
-
-int __init
-rc80211_minstrel_init(void)
-{
-	return ieee80211_rate_control_register(&mac80211_minstrel);
-}
-
-void
-rc80211_minstrel_exit(void)
-{
-	ieee80211_rate_control_unregister(&mac80211_minstrel);
-}
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 6abe8bf603e2..54b2b2c3e10a 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -158,7 +158,5 @@ int minstrel_get_tp_avg(struct minstrel_rate *mr, int prob_ewma);
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
 int minstrel_stats_csv_open(struct inode *inode, struct file *file);
-ssize_t minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos);
-int minstrel_stats_release(struct inode *inode, struct file *file);
 
 #endif
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 2e7266b81b19..698a668b5316 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -54,22 +54,6 @@
 #include <net/mac80211.h>
 #include "rc80211_minstrel.h"
 
-ssize_t
-minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
-{
-	struct minstrel_debugfs_info *ms;
-
-	ms = file->private_data;
-	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
-}
-
-int
-minstrel_stats_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-	return 0;
-}
-
 int
 minstrel_stats_open(struct inode *inode, struct file *file)
 {
@@ -135,14 +119,6 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations minstrel_stat_fops = {
-	.owner = THIS_MODULE,
-	.open = minstrel_stats_open,
-	.read = minstrel_stats_read,
-	.release = minstrel_stats_release,
-	.llseek = default_llseek,
-};
-
 int
 minstrel_stats_csv_open(struct inode *inode, struct file *file)
 {
@@ -200,21 +176,3 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 
 	return 0;
 }
-
-static const struct file_operations minstrel_stat_csv_fops = {
-	.owner = THIS_MODULE,
-	.open = minstrel_stats_csv_open,
-	.read = minstrel_stats_read,
-	.release = minstrel_stats_release,
-	.llseek = default_llseek,
-};
-
-void
-minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
-{
-	struct minstrel_sta_info *mi = priv_sta;
-
-	debugfs_create_file("rc_stats", 0444, dir, mi, &minstrel_stat_fops);
-	debugfs_create_file("rc_stats_csv", 0444, dir, mi,
-			    &minstrel_stat_csv_fops);
-}
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 818552ba61d0..0aec00990d1e 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -137,12 +137,10 @@
 		}					\
 	}
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 static bool minstrel_vht_only = true;
 module_param(minstrel_vht_only, bool, 0644);
 MODULE_PARM_DESC(minstrel_vht_only,
 		 "Use only VHT rates when VHT is supported by sta.");
-#endif
 
 /*
  * To enable sufficiently targeted rate sampling, MCS rates are divided into
@@ -171,7 +169,6 @@ const struct mcs_group minstrel_mcs_groups[] = {
 
 	CCK_GROUP,
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 	VHT_GROUP(1, 0, BW_20),
 	VHT_GROUP(2, 0, BW_20),
 	VHT_GROUP(3, 0, BW_20),
@@ -195,7 +192,6 @@ const struct mcs_group minstrel_mcs_groups[] = {
 	VHT_GROUP(1, 1, BW_80),
 	VHT_GROUP(2, 1, BW_80),
 	VHT_GROUP(3, 1, BW_80),
-#endif
 };
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
@@ -1146,12 +1142,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) != MINSTREL_GROUPS_NB);
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 	if (vht_cap->vht_supported)
 		use_vht = vht_cap->vht_mcs.tx_mcs_map != cpu_to_le16(~0);
 	else
-#endif
-	use_vht = 0;
+		use_vht = 0;
 
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
@@ -1224,10 +1218,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 		/* HT rate */
 		if (gflags & IEEE80211_TX_RC_MCS) {
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 			if (use_vht && minstrel_vht_only)
 				continue;
-#endif
+
 			mi->supported[i] = mcs->rx_mask[nss - 1];
 			if (mi->supported[i])
 				n_supported++;
@@ -1347,16 +1340,88 @@ minstrel_ht_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 	kfree(msp);
 }
 
+static void
+minstrel_ht_init_cck_rates(struct minstrel_priv *mp)
+{
+	static const int bitrates[4] = { 10, 20, 55, 110 };
+	struct ieee80211_supported_band *sband;
+	u32 rate_flags = ieee80211_chandef_rate_flags(&mp->hw->conf.chandef);
+	int i, j;
+
+	sband = mp->hw->wiphy->bands[NL80211_BAND_2GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
+
+		if (rate->flags & IEEE80211_RATE_ERP_G)
+			continue;
+
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
+			if (rate->bitrate != bitrates[j])
+				continue;
+
+			mp->cck_rates[j] = i;
+			break;
+		}
+	}
+}
+
 static void *
 minstrel_ht_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	return mac80211_minstrel.alloc(hw, debugfsdir);
+	struct minstrel_priv *mp;
+
+	mp = kzalloc(sizeof(struct minstrel_priv), GFP_ATOMIC);
+	if (!mp)
+		return NULL;
+
+	/* contention window settings
+	 * Just an approximation. Using the per-queue values would complicate
+	 * the calculations and is probably unnecessary */
+	mp->cw_min = 15;
+	mp->cw_max = 1023;
+
+	/* number of packets (in %) to use for sampling other rates
+	 * sample less often for non-mrr packets, because the overhead
+	 * is much higher than with mrr */
+	mp->lookaround_rate = 5;
+	mp->lookaround_rate_mrr = 10;
+
+	/* maximum time that the hw is allowed to stay in one MRR segment */
+	mp->segment_size = 6000;
+
+	if (hw->max_rate_tries > 0)
+		mp->max_retry = hw->max_rate_tries;
+	else
+		/* safe default, does not necessarily have to match hw properties */
+		mp->max_retry = 7;
+
+	if (hw->max_rates >= 4)
+		mp->has_mrr = true;
+
+	mp->hw = hw;
+	mp->update_interval = 100;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	mp->fixed_rate_idx = (u32) -1;
+	debugfs_create_u32("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
+			   &mp->fixed_rate_idx);
+#endif
+
+	minstrel_ht_init_cck_rates(mp);
+
+	return mp;
 }
 
 static void
 minstrel_ht_free(void *priv)
 {
-	mac80211_minstrel.free(priv);
+	kfree(priv);
 }
 
 static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
@@ -1415,14 +1480,14 @@ static void __init init_sample_table(void)
 }
 
 int __init
-rc80211_minstrel_ht_init(void)
+rc80211_minstrel_init(void)
 {
 	init_sample_table();
 	return ieee80211_rate_control_register(&mac80211_minstrel_ht);
 }
 
 void
-rc80211_minstrel_ht_exit(void)
+rc80211_minstrel_exit(void)
 {
 	ieee80211_rate_control_unregister(&mac80211_minstrel_ht);
 }
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 50f2a8d004c4..ad17df10a947 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -15,11 +15,7 @@
  */
 #define MINSTREL_MAX_STREAMS		3
 #define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 #define MINSTREL_VHT_STREAM_GROUPS	6 /* BW(=3) * SGI(=2) */
-#else
-#define MINSTREL_VHT_STREAM_GROUPS	0
-#endif
 
 #define MINSTREL_HT_GROUPS_NB	(MINSTREL_MAX_STREAMS *		\
 				 MINSTREL_HT_STREAM_GROUPS)
@@ -34,11 +30,7 @@
 #define MINSTREL_CCK_GROUP	(MINSTREL_HT_GROUP_0 + MINSTREL_HT_GROUPS_NB)
 #define MINSTREL_VHT_GROUP_0	(MINSTREL_CCK_GROUP + 1)
 
-#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
 #define MCS_GROUP_RATES		10
-#else
-#define MCS_GROUP_RATES		8
-#endif
 
 struct mcs_group {
 	u32 flags;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index afc7c65ebfad..5db0f4228875 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -15,6 +15,22 @@
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
+static ssize_t
+minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
+{
+	struct minstrel_debugfs_info *ms;
+
+	ms = file->private_data;
+	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
+}
+
+static int
+minstrel_stats_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
 static char *
 minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 {
-- 
2.17.0

