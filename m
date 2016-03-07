Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbcCGQVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 11:21:30 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
	<kvalo@codeaurora.org>, <mohammed@codeaurora.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [RFC] mac80211: Add support for per station rx stats histogram
Date: Mon, 7 Mar 2016 21:50:50 +0530
Message-ID: <1457367650-13319-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160307_172142_676085_DED69EE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable a provision in mac80211 'MAC80211_DEBUG_PER_STA_RX_STATS'
to keep track and dump per station stats.

Dump rx pkts / bytes per {MCS, BW, NSS, GI} per station
in histogram format. Rx stats provides a history
of the receive stats of the stations connected to us.
Information such as how consistently we received the packet
in higher MCS index / Bandwidth is very useful to assess the
performance of us(AP) and the connected clients

By default this feature is disabled though there is no impact
in performance (based on our test results)

This change is based on the design of Yanbo Li and HT packet
rate table fix by Anil

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 net/mac80211/Kconfig       |   12 +++
 net/mac80211/debugfs_sta.c |  231 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_sta.h |    5 +
 net/mac80211/rx.c          |    2 +
 net/mac80211/sta_info.h    |   23 +++++
 5 files changed, 273 insertions(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 3891cbd..89fb17c 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -309,6 +309,18 @@ config MAC80211_DEBUG_COUNTERS
 
 	  If unsure, say N.
 
+config MAC80211_DEBUG_PER_STA_RX_STATS
+	bool "Per Station Receive Stats Histogram"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_DEBUGFS
+	---help---
+	  Selecting this option causes mac80211 to keep track of
+	  per station received packets, classify them based
+	  on Bandwidth, Rate index (legacy, HT, VHT) and dump
+	  a histogram of the same
+
+	  If unsure, say N.
+
 config MAC80211_STA_HASH_MAX_SIZE
 	int "Station hash table maximum size" if MAC80211_DEBUG_MENU
 	default 0
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a39512f..85c66ef 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -289,6 +289,136 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(ht_capa);
 
+static ssize_t sta_rx_stats_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
+#define RX_STATS_HIST_FMT(n) \
+	do { \
+		if ((i + 1) % n == 0) \
+			len += scnprintf(buf + len, size - len, "\n\t\t"); \
+	} while (0)
+	int retval = 0, len = 0;
+	char *buf;
+	const int size = 3072;
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->local;
+	int i;
+	char *bw_str[IEEE80211_BW_NUM] = {"20", "40", "80", "160"};
+	char *nss_str[IEEE80211_NSS_NUM] = {"1x1", "2x2", "3x3", "4x4"};
+	char *gi_str[IEEE80211_GI_NUM] = {"LGI", "SGI"};
+	char *legacy_str[IEEE80211_LEGACY_RATE_NUM] = {"1", "2", "5.5",
+						       "11", "6", "9",
+						       "12", "18", "24",
+						       "36", "48", "54"};
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, size - len, "VHT MCS packets: ");
+	for (i = 0; i < IEEE80211_VHT_MCS_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "MCS %d: %llu, ",
+				 i, sta->rx_vht_pkt[i]);
+		RX_STATS_HIST_FMT(5);
+	}
+
+	len += scnprintf(buf + len, size - len, "\nHT MCS packets: ");
+	for (i = 0; i < IEEE80211_HT_MCS_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "MCS %d: %llu, ",
+				 i, sta->rx_ht_pkt[i]);
+		RX_STATS_HIST_FMT(5);
+	}
+
+	len += scnprintf(buf + len, size - len, "\n\nBW packets: ");
+	for (i = 0; i < IEEE80211_BW_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%sMhz: %llu",
+				 bw_str[i], sta->rx_bw_pkt[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nNSS packets: ");
+	for (i = 0; i < IEEE80211_NSS_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%s: %llu",
+				 nss_str[i], sta->rx_nss_pkt[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nGI packets: ");
+	for (i = 0; i < IEEE80211_GI_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%s: %llu",
+				 gi_str[i], sta->rx_gi_pkt[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nLegacy rate packets: ");
+	for (i = 0; i < IEEE80211_LEGACY_RATE_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "\t%sMbps: %llu",
+				 legacy_str[i], sta->rx_legacy_pkt[i]);
+		RX_STATS_HIST_FMT(4);
+	}
+
+	len += scnprintf(buf + len, size - len, "\nRate table packets:  ");
+	for (i = 0; i < IEEE80211_RATE_TABLE_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "\t%llu",
+				 sta->rx_rate_pkt[i]);
+		RX_STATS_HIST_FMT(8);
+	}
+
+	len += scnprintf(buf + len, size - len, "\nVHT MCS bytes: ");
+	for (i = 0; i < IEEE80211_VHT_MCS_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "MCS %d: %llu, ",
+				 i, sta->rx_vht_byte[i]);
+		RX_STATS_HIST_FMT(5);
+	}
+
+	len += scnprintf(buf + len, size - len, "\nHT MCS bytes: ");
+	for (i = 0; i < IEEE80211_HT_MCS_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "MCS %d: %llu, ",
+				 i, sta->rx_ht_byte[i]);
+		RX_STATS_HIST_FMT(5);
+	}
+
+	len += scnprintf(buf + len, size - len, "\n\nNSS bytes: ");
+	for (i = 0; i < IEEE80211_NSS_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%s: %llu",
+				 nss_str[i], sta->rx_nss_byte[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nBW bytes: ");
+	for (i = 0; i < IEEE80211_BW_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%sMhz: %llu",
+				 bw_str[i], sta->rx_bw_byte[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nGI bytes: ");
+	for (i = 0; i < IEEE80211_GI_NUM; i++)
+		len += scnprintf(buf + len, size - len, "\t%s: %llu",
+				 gi_str[i], sta->rx_gi_byte[i]);
+
+	len += scnprintf(buf + len, size - len, "\n\nLegacy rate bytes: ");
+	for (i = 0; i < IEEE80211_LEGACY_RATE_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "\t%sMbps: %llu",
+				 legacy_str[i], sta->rx_legacy_byte[i]);
+		RX_STATS_HIST_FMT(4);
+	}
+
+	len += scnprintf(buf + len, size - len, "\nRate table bytes:  ");
+	for (i = 0; i < IEEE80211_RATE_TABLE_NUM; i++) {
+		len += scnprintf(buf + len, size - len, "\t%llu",
+				 sta->rx_rate_byte[i]);
+		RX_STATS_HIST_FMT(8);
+	}
+
+	if (len > size)
+		len = size;
+	retval = simple_read_from_buffer(userbuf, count, ppos, buf, len);
+	kfree(buf);
+
+#undef RX_STATS_HIST_FMT
+	return retval;
+#endif
+	return -EINVAL;
+}
+STA_OPS(rx_stats);
+
+static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	char buf[128], *p = buf;
+	struct sta_info *sta = file->private_data;
+
 static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
@@ -332,6 +462,106 @@ STA_OPS(vht_capa);
 		debugfs_create_u64(#name, 0400, sta->debugfs.dir,	\
 			(u64 *) &sta->field);
 
+#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
+static int legacy_rate_to_index(u16 rate)
+{
+	int legacy_rate[] = {10, 20, 55, 110, 60, 90, 120,
+			     180, 240, 360, 480, 540};
+	int i;
+
+	for (i = 0; i < IEEE80211_LEGACY_RATE_NUM - 1; i++)
+		if (rate == legacy_rate[i])
+			return i;
+	return -1;
+}
+#endif
+
+void ieee80211_rx_h_sta_stats(struct sta_info *sta, struct sk_buff *skb)
+{
+#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	unsigned int pkt_len = skb->len;
+	unsigned int bw_idx, gi_idx, mcs_idx = 0, nss_idx = 0, i;
+
+	/* Not support 5Mhz and 10Mhz currently  */
+	if (status->flag & (RX_FLAG_5MHZ | RX_FLAG_10MHZ))
+		goto out;
+
+	if (status->vht_flag & RX_VHT_FLAG_160MHZ)
+		bw_idx = 3;
+	else if (status->vht_flag & RX_VHT_FLAG_80MHZ)
+		bw_idx = 2;
+	else if (status->flag & RX_FLAG_40MHZ)
+		bw_idx = 1;
+	else
+		bw_idx = 0;
+
+	if (status->flag & RX_FLAG_HT) {
+		mcs_idx = status->rate_idx;
+		nss_idx = (mcs_idx >> 3) - 1;
+
+		if (status->rate_idx > IEEE80211_HT_MCS_NUM - 1 ||
+		    nss_idx > IEEE80211_NSS_NUM - 1)
+			goto out;
+
+		sta->rx_ht_pkt[mcs_idx]++;
+		sta->rx_ht_byte[mcs_idx] += pkt_len;
+		sta->rx_nss_pkt[nss_idx]++;
+		sta->rx_nss_byte[nss_idx] += pkt_len;
+		/* To fit into rate table for HT packets */
+		mcs_idx = mcs_idx % 8;
+	} else if (status->flag & RX_FLAG_VHT) {
+		mcs_idx = status->rate_idx;
+		nss_idx = status->vht_nss - 1;
+
+		if (nss_idx > IEEE80211_NSS_NUM - 1 ||
+		    mcs_idx > (IEEE80211_VHT_MCS_NUM - 1))
+			goto out;
+
+		sta->rx_vht_pkt[mcs_idx]++;
+		sta->rx_vht_byte[mcs_idx] += pkt_len;
+		sta->rx_nss_pkt[nss_idx]++;
+		sta->rx_nss_byte[nss_idx] += pkt_len;
+	}
+
+	gi_idx = (status->flag & RX_FLAG_SHORT_GI) ? 1 : 0;
+	sta->rx_gi_pkt[gi_idx]++;
+	sta->rx_gi_byte[gi_idx] += pkt_len;
+	sta->rx_bw_pkt[bw_idx]++;
+	sta->rx_bw_byte[bw_idx] += pkt_len;
+
+	if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) {
+		/* Update Rate table based on http://mcsindex.com/ */
+		i = mcs_idx * 8 + 8 * 10 * nss_idx;
+		i += bw_idx * 2 + gi_idx;
+		sta->rx_rate_pkt[i]++;
+		sta->rx_rate_byte[i] += pkt_len;
+	} else {
+		struct ieee80211_local *local = sta->local;
+		struct ieee80211_sub_if_data *sdata = sta->sdata;
+		enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+		struct ieee80211_supported_band *sband;
+		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
+		u16 brate, legacy_rate;
+
+		if (status->rate_idx > IEEE80211_LEGACY_RATE_NUM - 1)
+			goto out;
+
+		sband = local->hw.wiphy->bands[band];
+		brate = sband->bitrates[status->rate_idx].bitrate;
+		legacy_rate = DIV_ROUND_UP(brate, 1 << shift);
+		i = legacy_rate_to_index(legacy_rate);
+		if (i < 0)
+			goto out;
+
+		sta->rx_legacy_pkt[i]++;
+		sta->rx_legacy_byte[i] += pkt_len;
+	}
+out:
+	return;
+#endif
+}
+
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
@@ -365,6 +595,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
+	DEBUGFS_ADD(rx_stats);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
diff --git a/net/mac80211/debugfs_sta.h b/net/mac80211/debugfs_sta.h
index 8b60890..c7a3424 100644
--- a/net/mac80211/debugfs_sta.h
+++ b/net/mac80211/debugfs_sta.h
@@ -6,9 +6,14 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_sta_debugfs_add(struct sta_info *sta);
 void ieee80211_sta_debugfs_remove(struct sta_info *sta);
+void ieee80211_rx_h_sta_stats(struct sta_info *sta, struct sk_buff *skb);
 #else
 static inline void ieee80211_sta_debugfs_add(struct sta_info *sta) {}
 static inline void ieee80211_sta_debugfs_remove(struct sta_info *sta) {}
+static inline void ieee80211_rx_h_sta_stats(struct sta_info *sta,
+					    struct sk_buff *skb)
+{
+}
 #endif
 
 #endif /* __MAC80211_DEBUGFS_STA_H */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc08185..c5e8559 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -31,6 +31,7 @@
 #include "tkip.h"
 #include "wme.h"
 #include "rate.h"
+#include "debugfs_sta.h"
 
 static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
 {
@@ -1421,6 +1422,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			sta->rx_stats.last_rate_flag = status->flag;
 			sta->rx_stats.last_rate_vht_flag = status->vht_flag;
 			sta->rx_stats.last_rate_vht_nss = status->vht_nss;
+			ieee80211_rx_h_sta_stats(sta, skb);
 		}
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d605162..2c0d806 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -248,6 +248,13 @@ struct sta_ampdu_mlme {
 
 #define IEEE80211_FAST_XMIT_MAX_IV	18
 
+#define IEEE80211_HT_MCS_NUM		32
+#define IEEE80211_VHT_MCS_NUM		10
+#define IEEE80211_BW_NUM		4
+#define IEEE80211_NSS_NUM		4
+#define IEEE80211_GI_NUM		2
+#define IEEE80211_RATE_TABLE_NUM	320
+#define IEEE80211_LEGACY_RATE_NUM	12
 /**
  * struct ieee80211_fast_tx - TX fastpath information
  * @key: key to use for hw crypto
@@ -495,6 +502,22 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
+	u64 rx_legacy_pkt[IEEE80211_LEGACY_RATE_NUM];
+	u64 rx_ht_pkt[IEEE80211_HT_MCS_NUM];
+	u64 rx_vht_pkt[IEEE80211_VHT_MCS_NUM];
+	u64 rx_bw_pkt[IEEE80211_BW_NUM];
+	u64 rx_nss_pkt[IEEE80211_NSS_NUM];
+	u64 rx_gi_pkt[IEEE80211_GI_NUM];
+	u64 rx_rate_pkt[IEEE80211_RATE_TABLE_NUM];
+	u64 rx_legacy_byte[IEEE80211_LEGACY_RATE_NUM];
+	u64 rx_ht_byte[IEEE80211_HT_MCS_NUM];
+	u64 rx_vht_byte[IEEE80211_VHT_MCS_NUM];
+	u64 rx_bw_byte[IEEE80211_BW_NUM];
+	u64 rx_nss_byte[IEEE80211_NSS_NUM];
+	u64 rx_gi_byte[IEEE80211_GI_NUM];
+	u64 rx_rate_byte[IEEE80211_RATE_TABLE_NUM];
+#endif
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
1.7.9.5

