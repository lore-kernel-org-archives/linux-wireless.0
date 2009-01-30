Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55937 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZA3JFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 04:05:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 01:05:48 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18818.49681.687141.290386@gargle.gargle.HOWL> (sfid-20090130_100555_582417_4CF4C0CB)
Date: Fri, 30 Jan 2009 14:32:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/3] ath9k: Add debugfs files for printing TX rate details
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h  |   17 ++++++
 drivers/net/wireless/ath9k/debug.c |  100 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/rc.c    |    1 +
 3 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b006d46..ab6dae0 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -131,8 +131,18 @@ struct ath_interrupt_stats {
 	u32 dtim;
 };
 
+struct ath_legacy_rc_stats {
+	u32 success;
+};
+
+struct ath_11n_rc_stats {
+	u32 success;
+};
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
+	struct ath_legacy_rc_stats legacy_rcstats[12]; /* max(11a,11b,11g) */
+	struct ath_11n_rc_stats n_rcstats[16]; /* 0..15 MCS rates */
 };
 
 struct ath9k_debug {
@@ -141,6 +151,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	struct dentry *debugfs_dma;
 	struct dentry *debugfs_interrupt;
+	struct dentry *debugfs_rcstat;
 	struct ath_stats stats;
 };
 
@@ -148,6 +159,7 @@ void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
 int ath9k_init_debug(struct ath_softc *sc);
 void ath9k_exit_debug(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
+void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
 
 #else
 
@@ -170,6 +182,11 @@ static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 {
 }
 
+static inline void ath_debug_stat_rc(struct ath_softc *sc,
+				     struct sk_buff *skb)
+{
+}
+
 #endif /* CONFIG_ATH9K_DEBUG */
 
 struct ath_config {
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 1680164..6181e49 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -222,6 +222,98 @@ static const struct file_operations fops_interrupt = {
 	.owner = THIS_MODULE
 };
 
+static void ath_debug_stat_11n_rc(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ath_tx_info_priv *tx_info_priv = NULL;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rates = tx_info->status.rates;
+	int final_ts_idx, idx;
+
+	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	final_ts_idx = tx_info_priv->tx.ts_rateindex;
+	idx = sc->cur_rate_table->info[rates[final_ts_idx].idx].dot11rate;
+
+	sc->sc_debug.stats.n_rcstats[idx].success++;
+}
+
+static void ath_debug_stat_legacy_rc(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ath_tx_info_priv *tx_info_priv = NULL;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rates = tx_info->status.rates;
+	int final_ts_idx, idx;
+
+	tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	final_ts_idx = tx_info_priv->tx.ts_rateindex;
+	idx = rates[final_ts_idx].idx;
+
+	sc->sc_debug.stats.legacy_rcstats[idx].success++;
+}
+
+void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
+{
+	if (conf_is_ht(&sc->hw->conf))
+		ath_debug_stat_11n_rc(sc, skb);
+	else
+		ath_debug_stat_legacy_rc(sc, skb);
+}
+
+static ssize_t ath_read_file_stat_11n_rc(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+	int i = 0;
+
+	len += sprintf(buf, "%7s %13s\n\n", "Rate", "Success");
+
+	for (i = 0; i <= 15; i++) {
+		len += snprintf(buf + len, sizeof(buf) - len,
+				"%5s%3d: %8u\n", "MCS", i,
+				sc->sc_debug.stats.n_rcstats[i].success);
+	}
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath_read_file_stat_legacy_rc(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+	int i = 0;
+
+	len += sprintf(buf, "%7s %13s\n\n", "Rate", "Success");
+
+	for (i = 0; i < sc->cur_rate_table->rate_cnt; i++) {
+		len += snprintf(buf + len, sizeof(buf) - len, "%5u: %12u\n",
+				sc->cur_rate_table->info[i].ratekbps / 1000,
+				sc->sc_debug.stats.legacy_rcstats[i].success);
+	}
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+
+	if (conf_is_ht(&sc->hw->conf))
+		return ath_read_file_stat_11n_rc(file, user_buf, count, ppos);
+	else
+		return ath_read_file_stat_legacy_rc(file, user_buf, count ,ppos);
+}
+
+static const struct file_operations fops_rcstat = {
+	.read = read_file_rcstat,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
 
 int ath9k_init_debug(struct ath_softc *sc)
 {
@@ -248,6 +340,13 @@ int ath9k_init_debug(struct ath_softc *sc)
 	if (!sc->sc_debug.debugfs_interrupt)
 		goto err;
 
+	sc->sc_debug.debugfs_rcstat = debugfs_create_file("rcstat",
+						  S_IRUGO,
+						  sc->sc_debug.debugfs_phy,
+						  sc, &fops_rcstat);
+	if (!sc->sc_debug.debugfs_rcstat)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -256,6 +355,7 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->sc_debug.debugfs_rcstat);
 	debugfs_remove(sc->sc_debug.debugfs_interrupt);
 	debugfs_remove(sc->sc_debug.debugfs_dma);
 	debugfs_remove(sc->sc_debug.debugfs_phy);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8a278f7..ddf7c27 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1530,6 +1530,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			 (is_underrun) ? ATH_11N_TXMAXTRY :
 			 tx_info_priv->tx.ts_longretry);
 
+	ath_debug_stat_rc(sc, skb);
 exit:
 	kfree(tx_info_priv);
 }
-- 
1.6.1

