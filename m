Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:43153 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266AbZE0Msh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:48:37 -0400
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 12:48:28 +0000
Message-Id: <1243428510-14931-2-git-send-email-x@jeffhansen.com>
In-Reply-To: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
References: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
Subject: [PATCH 2/4] ath9k: Combine legacy and 11n rc statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch combines the legacy and 11n rcstats into one, using the normal
rate table indices instead of two separate indices for each mode.  Legacy
rates also get all of the PER and retry information, now, too.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |  111 ++++++++++----------------------
 drivers/net/wireless/ath/ath9k/debug.h |    9 +--
 2 files changed, 35 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 97df20c..80115ea 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -224,111 +224,66 @@ static const struct file_operations fops_interrupt = {
 	.owner = THIS_MODULE
 };
 
-static void ath_debug_stat_11n_rc(struct ath_softc *sc, struct sk_buff *skb)
-{
-	struct ath_tx_info_priv *tx_info_priv = NULL;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_rate *rates = tx_info->status.rates;
-	int final_ts_idx, idx;
-
-	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-	final_ts_idx = tx_info_priv->tx.ts_rateindex;
-	idx = sc->cur_rate_table->info[rates[final_ts_idx].idx].dot11rate;
-
-	sc->debug.stats.n_rcstats[idx].success++;
-}
-
-static void ath_debug_stat_legacy_rc(struct ath_softc *sc, struct sk_buff *skb)
+void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ath_tx_info_priv *tx_info_priv = NULL;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
 	int final_ts_idx, idx;
+	struct ath_rc_stats *stats;
 
 	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 	idx = rates[final_ts_idx].idx;
-
-	sc->debug.stats.legacy_rcstats[idx].success++;
+	stats = &sc->debug.stats.rcstats[idx];
+	stats->success++;
 }
 
-void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
-{
-	if (conf_is_ht(&sc->hw->conf))
-		ath_debug_stat_11n_rc(sc, skb);
-	else
-		ath_debug_stat_legacy_rc(sc, skb);
-}
-
-/* FIXME: legacy rates, later on .. */
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 			    int xretries, int retries, u8 per)
 {
-	if (conf_is_ht(&sc->hw->conf)) {
-		int idx = sc->cur_rate_table->info[rix].dot11rate;
+	struct ath_rc_stats *stats = &sc->debug.stats.rcstats[rix];
 
-		sc->debug.stats.n_rcstats[idx].xretries += xretries;
-		sc->debug.stats.n_rcstats[idx].retries += retries;
-		sc->debug.stats.n_rcstats[idx].per = per;
-	}
+	stats->xretries += xretries;
+	stats->retries += retries;
+	stats->per = per;
 }
 
-static ssize_t ath_read_file_stat_11n_rc(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
+static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	char buf[1024];
-	unsigned int len = 0;
+	char *buf;
+	unsigned int len = 0, max;
 	int i = 0;
+	ssize_t retval;
 
-	len += sprintf(buf, "%7s %13s %8s %8s %6s\n\n", "Rate", "Success",
-		       "Retries", "XRetries", "PER");
-
-	for (i = 0; i <= 15; i++) {
-		len += snprintf(buf + len, sizeof(buf) - len,
-				"%5s%3d: %8u %8u %8u %8u\n", "MCS", i,
-				sc->debug.stats.n_rcstats[i].success,
-				sc->debug.stats.n_rcstats[i].retries,
-				sc->debug.stats.n_rcstats[i].xretries,
-				sc->debug.stats.n_rcstats[i].per);
-	}
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
+	if (sc->cur_rate_table == NULL)
+		return 0;
 
-static ssize_t ath_read_file_stat_legacy_rc(struct file *file,
-					    char __user *user_buf,
-					    size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	char buf[512];
-	unsigned int len = 0;
-	int i = 0;
+	max = 80 + sc->cur_rate_table->rate_cnt * 64;
+	buf = kmalloc(max + 1, GFP_KERNEL);
+	if (buf == NULL)
+		return 0;
+	buf[max] = 0;
 
-	len += sprintf(buf, "%7s %13s\n\n", "Rate", "Success");
+	len += sprintf(buf, "%5s %15s %8s %9s %3s\n\n", "Rate", "Success",
+		       "Retries", "XRetries", "PER");
 
 	for (i = 0; i < sc->cur_rate_table->rate_cnt; i++) {
-		len += snprintf(buf + len, sizeof(buf) - len, "%5u: %12u\n",
-				sc->cur_rate_table->info[i].ratekbps / 1000,
-				sc->debug.stats.legacy_rcstats[i].success);
+		u32 ratekbps = sc->cur_rate_table->info[i].ratekbps;
+		struct ath_rc_stats *stats = &sc->debug.stats.rcstats[i];
+
+		len += snprintf(buf + len, max - len,
+			"%3u.%d: %8u %8u %8u %8u\n", ratekbps / 1000,
+			(ratekbps % 1000) / 100, stats->success,
+			stats->retries, stats->xretries,
+			stats->per);
 	}
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-
-	if (sc->cur_rate_table == NULL)
-		return 0;
-
-	if (conf_is_ht(&sc->hw->conf))
-		return ath_read_file_stat_11n_rc(file, user_buf, count, ppos);
-	else
-		return ath_read_file_stat_legacy_rc(file, user_buf, count ,ppos);
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return retval;
 }
 
 static const struct file_operations fops_rcstat = {
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index db845cf..cf9146a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -80,11 +80,7 @@ struct ath_interrupt_stats {
 	u32 dtim;
 };
 
-struct ath_legacy_rc_stats {
-	u32 success;
-};
-
-struct ath_11n_rc_stats {
+struct ath_rc_stats {
 	u32 success;
 	u32 retries;
 	u32 xretries;
@@ -93,8 +89,7 @@ struct ath_11n_rc_stats {
 
 struct ath_stats {
 	struct ath_interrupt_stats istats;
-	struct ath_legacy_rc_stats legacy_rcstats[12];	/* max(11a,11b,11g) */
-	struct ath_11n_rc_stats n_rcstats[16];		/* 0..15 MCS rates */
+	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
 struct ath9k_debug {
-- 
1.6.0.4

