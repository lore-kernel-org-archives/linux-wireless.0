Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44173 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaAMCEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 4/5] ath9k: Add a debugfs file "node_recv"
Date: Mon, 13 Jan 2014 07:29:30 +0530
Message-Id: <1389578371-23943-4-git-send-email-sujith@msujith.org> (sfid-20140113_030501_535372_9A1191E5)
In-Reply-To: <1389578371-23943-1-git-send-email-sujith@msujith.org>
References: <1389578371-23943-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This would be useful when debugging RX performance issues.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |   8 +-
 drivers/net/wireless/ath/ath9k/debug.h     |  34 +++++-
 drivers/net/wireless/ath/ath9k/debug_sta.c | 164 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c      |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c      |   2 -
 5 files changed, 203 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f622a98..cba7d77 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -146,7 +146,9 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
-#define IS_CCK_RATE(rate) ((rate >= 0x18) && (rate <= 0x1e))
+#define IS_HT_RATE(rate)   (rate & 0x80)
+#define IS_CCK_RATE(rate)  ((rate >= 0x18) && (rate <= 0x1e))
+#define IS_OFDM_RATE(rate) ((rate >= 0x8) && (rate <= 0xf))
 
 struct ath_txq {
 	int mac80211_qnum; /* mac80211 queue number, -1 means not mac80211 Q */
@@ -262,6 +264,10 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
+
+#ifdef CONFIG_ATH9K_STATION_STATISTICS
+	struct ath_rx_rate_stats rx_rate_stats;
+#endif
 };
 
 struct ath_tx_control {
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index ec02d38..b01b8c3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -27,11 +27,13 @@ struct fft_sample_tlv;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
+#define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
 #define RESET_STAT_INC(sc, type) sc->debug.stats.reset[type]++
 #define ANT_STAT_INC(i, c) sc->debug.stats.ant_stats[i].c++
 #define ANT_LNA_INC(i, c) sc->debug.stats.ant_stats[i].lna_recv_cnt[c]++;
 #else
 #define TX_STAT_INC(q, c) do { } while (0)
+#define RX_STAT_INC(c)
 #define RESET_STAT_INC(sc, type) do { } while (0)
 #define ANT_STAT_INC(i, c) do { } while (0)
 #define ANT_LNA_INC(i, c) do { } while (0)
@@ -201,7 +203,23 @@ struct ath_tx_stats {
 				 TXSTATS[PR_QNUM(IEEE80211_AC_VO)].elem); \
 	} while(0)
 
-#define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
+struct ath_rx_rate_stats {
+	struct {
+		u32 ht20_cnt;
+		u32 ht40_cnt;
+		u32 sgi_cnt;
+		u32 lgi_cnt;
+	} ht_stats[24];
+
+	struct {
+		u32 ofdm_cnt;
+	} ofdm_stats[8];
+
+	struct {
+		u32 cck_lp_cnt;
+		u32 cck_sp_cnt;
+	} cck_stats[4];
+};
 
 /**
  * struct ath_rx_stats - RX Statistics
@@ -299,8 +317,6 @@ void ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause);
 
 #else
 
-#define RX_STAT_INC(c) /* NOP */
-
 static inline int ath9k_init_debug(struct ath_hw *ah)
 {
 	return 0;
@@ -338,4 +354,16 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 
 #endif /* CONFIG_ATH9K_DEBUGFS */
 
+#ifdef CONFIG_ATH9K_STATION_STATISTICS
+void ath_debug_rate_stats(struct ath_softc *sc,
+			  struct ath_rx_status *rs,
+			  struct sk_buff *skb);
+#else
+static inline void ath_debug_rate_stats(struct ath_softc *sc,
+					struct ath_rx_status *rs,
+					struct sk_buff *skb)
+{
+}
+#endif /* CONFIG_ATH9K_STATION_STATISTICS */
+
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 3d11968..d33cc88 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -16,6 +16,10 @@
 
 #include "ath9k.h"
 
+/*************/
+/* node_aggr */
+/*************/
+
 static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -95,11 +99,171 @@ static const struct file_operations fops_node_aggr = {
 	.llseek = default_llseek,
 };
 
+/*************/
+/* node_recv */
+/*************/
+
+void ath_debug_rate_stats(struct ath_softc *sc,
+			  struct ath_rx_status *rs,
+			  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ieee80211_rx_status *rxs;
+	struct ath_rx_rate_stats *rstats;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(sc->hw, hdr->addr2, NULL);
+	if (!sta)
+		goto exit;
+
+	an = (struct ath_node *) sta->drv_priv;
+	rstats = &an->rx_rate_stats;
+	rxs = IEEE80211_SKB_RXCB(skb);
+
+	if (IS_HT_RATE(rs->rs_rate)) {
+		if (rxs->rate_idx > ARRAY_SIZE(rstats->ht_stats))
+			goto exit;
+
+		if (rxs->flag & RX_FLAG_40MHZ)
+			rstats->ht_stats[rxs->rate_idx].ht40_cnt++;
+		else
+			rstats->ht_stats[rxs->rate_idx].ht20_cnt++;
+
+		if (rxs->flag & RX_FLAG_SHORT_GI)
+			rstats->ht_stats[rxs->rate_idx].sgi_cnt++;
+		else
+			rstats->ht_stats[rxs->rate_idx].lgi_cnt++;
+
+		goto exit;
+	}
+
+	if (IS_CCK_RATE(rs->rs_rate)) {
+		if (rxs->flag & RX_FLAG_SHORTPRE)
+			rstats->cck_stats[rxs->rate_idx].cck_sp_cnt++;
+		else
+			rstats->cck_stats[rxs->rate_idx].cck_lp_cnt++;
+
+		goto exit;
+	}
+
+	if (IS_OFDM_RATE(rs->rs_rate)) {
+		if (ah->curchan->chan->band == IEEE80211_BAND_2GHZ)
+			rstats->ofdm_stats[rxs->rate_idx - 4].ofdm_cnt++;
+		else
+			rstats->ofdm_stats[rxs->rate_idx].ofdm_cnt++;
+	}
+exit:
+	rcu_read_unlock();
+}
+
+#define PRINT_CCK_RATE(str, i, sp)					\
+	do {								\
+		len += scnprintf(buf + len, size - len,			\
+			 "%11s : %10u\n",				\
+			 str,						\
+			 (sp) ? rstats->cck_stats[i].cck_sp_cnt :	\
+			 rstats->cck_stats[i].cck_lp_cnt);		\
+	} while (0)
+
+#define PRINT_OFDM_RATE(str, i)					\
+	do {							\
+		len += scnprintf(buf + len, size - len,		\
+			 "%11s : %10u\n",			\
+			 str,					\
+			 rstats->ofdm_stats[i].ofdm_cnt);	\
+	} while (0)
+
+static ssize_t read_file_node_recv(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath_node *an = file->private_data;
+	struct ath_softc *sc = an->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_rx_rate_stats *rstats;
+	struct ieee80211_sta *sta = an->sta;
+	enum ieee80211_band band;
+	u32 len = 0, size = 4096;
+	char *buf;
+	size_t retval;
+	int i;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	band = ah->curchan->chan->band;
+	rstats = &an->rx_rate_stats;
+
+	if (!sta->ht_cap.ht_supported)
+		goto legacy;
+
+	len += scnprintf(buf + len, size - len,
+			 "%24s%10s%10s%10s\n",
+			 "HT20", "HT40", "SGI", "LGI");
+
+	for (i = 0; i < 24; i++) {
+		len += scnprintf(buf + len, size - len,
+				 "%8s%3u : %10u%10u%10u%10u\n",
+				 "MCS", i,
+				 rstats->ht_stats[i].ht20_cnt,
+				 rstats->ht_stats[i].ht40_cnt,
+				 rstats->ht_stats[i].sgi_cnt,
+				 rstats->ht_stats[i].lgi_cnt);
+	}
+
+	len += scnprintf(buf + len, size - len, "\n");
+
+legacy:
+	if (band == IEEE80211_BAND_2GHZ) {
+		PRINT_CCK_RATE("CCK-1M/LP", 0, false);
+		PRINT_CCK_RATE("CCK-2M/LP", 1, false);
+		PRINT_CCK_RATE("CCK-5.5M/LP", 2, false);
+		PRINT_CCK_RATE("CCK-11M/LP", 3, false);
+
+		PRINT_CCK_RATE("CCK-2M/SP", 1, true);
+		PRINT_CCK_RATE("CCK-5.5M/SP", 2, true);
+		PRINT_CCK_RATE("CCK-11M/SP", 3, true);
+	}
+
+	PRINT_OFDM_RATE("OFDM-6M", 0);
+	PRINT_OFDM_RATE("OFDM-9M", 1);
+	PRINT_OFDM_RATE("OFDM-12M", 2);
+	PRINT_OFDM_RATE("OFDM-18M", 3);
+	PRINT_OFDM_RATE("OFDM-24M", 4);
+	PRINT_OFDM_RATE("OFDM-36M", 5);
+	PRINT_OFDM_RATE("OFDM-48M", 6);
+	PRINT_OFDM_RATE("OFDM-54M", 7);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+#undef PRINT_OFDM_RATE
+#undef PRINT_CCK_RATE
+
+static const struct file_operations fops_node_recv = {
+	.read = read_file_node_recv,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
 			   struct dentry *dir)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+
 	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
+	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f7cc5b3..5bf3243 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1354,8 +1354,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 		ath9k_antenna_check(sc, &rs);
-
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
+		ath_debug_rate_stats(sc, &rs, skb);
 
 		ieee80211_rx(hw, skb);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e8d0e7f..0a75e2f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -47,8 +47,6 @@ static u16 bits_per_symbol[][2] = {
 	{   260,  540 },     /*  7: 64-QAM 5/6 */
 };
 
-#define IS_HT_RATE(_rate)     ((_rate) & 0x80)
-
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid, struct sk_buff *skb);
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-- 
1.8.5.2

