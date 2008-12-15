Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42026 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYLONRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 08:17:33 -0500
Received: from jm (a91-155-82-88.elisa-laajakaista.fi [91.155.82.88])
	(authenticated bits=0)
	by jmalinen.user.openhosting.com (8.13.8/8.13.8) with ESMTP id mBFDHSgM014944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 08:17:29 -0500
Date: Mon, 15 Dec 2008 15:17:27 +0200
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Add per-rate TX/RX statistics into debugfs
Message-ID: <20081215131727.GA14738@jm.kir.nu> (sfid-20081215_141742_229569_159AA1EA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collect per-rate statistics about TX/RX frames for each STA if
mac80211 debug counters are enabled and make this information
available in debugfs.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 net/mac80211/debugfs_sta.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c        |   20 ++++++++++++++++++++
 net/mac80211/rx.c          |   15 +++++++++++++++
 net/mac80211/sta_info.h    |   18 ++++++++++++++++++
 4 files changed, 98 insertions(+)

--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2008-12-04 12:52:40.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2008-12-15 15:11:10.000000000 +0200
@@ -163,6 +163,45 @@ static ssize_t sta_agg_status_read(struc
 }
 STA_OPS(agg_status);
 
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+static ssize_t sta_txrx_read(struct file *file, char __user *userbuf,
+			     size_t count, loff_t *ppos)
+{
+	char buf[500], *p = buf;
+	struct sta_info *sta = file->private_data;
+	int i;
+
+	p += scnprintf(p, sizeof(buf) - (p - buf),
+		       "rate\tRX\tTX\texc\tretries\n");
+	for (i = 0; i < NUM_STATS_RATES; i++) {
+		if (sta->rx_frames[i] == 0 &&
+		    sta->tx_frames[i] == 0 &&
+		    sta->tx_exc_retries[i] == 0 &&
+		    sta->tx_retries[i] == 0)
+			continue;
+		p += scnprintf(p, sizeof(buf) - (p - buf),
+			       "%d\t%lu\t%lu\t%lu\t%lu\n",
+			       i, sta->rx_frames[i], sta->tx_frames[i],
+			       sta->tx_exc_retries[i], sta->tx_retries[i]);
+	}
+	for (i = 0; i < NUM_STATS_MCS; i++) {
+		if (sta->rx_frames_mcs[i] == 0 &&
+		    sta->tx_frames_mcs[i] == 0 &&
+		    sta->tx_exc_retries_mcs[i] == 0 &&
+		    sta->tx_retries_mcs[i] == 0)
+			continue;
+		p += scnprintf(p, sizeof(buf) - (p - buf),
+			       "MCS%d\t%lu\t%lu\t%lu\t%lu\n",
+			       i, sta->rx_frames_mcs[i], sta->tx_frames_mcs[i],
+			       sta->tx_exc_retries_mcs[i],
+			       sta->tx_retries_mcs[i]);
+	}
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(txrx);
+#endif
+
 #define DEBUGFS_ADD(name) \
 	sta->debugfs.name = debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -203,6 +242,9 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
 	DEBUGFS_ADD(agg_status);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	DEBUGFS_ADD(txrx);
+#endif
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -212,6 +254,9 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
 	DEBUGFS_DEL(agg_status);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	DEBUGFS_DEL(txrx);
+#endif
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
--- wireless-testing.orig/net/mac80211/rx.c	2008-12-15 13:22:50.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2008-12-15 13:39:17.000000000 +0200
@@ -2252,6 +2252,21 @@ void __ieee80211_rx(struct ieee80211_hw 
 	 */
 	rcu_read_lock();
 
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	if (skb->len >= 16) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		struct sta_info *sta = sta_info_get(local, hdr->addr2);
+		if (sta) {
+			if (status->flag & RX_FLAG_HT &&
+			    status->rate_idx < NUM_STATS_MCS)
+				sta->rx_frames_mcs[status->rate_idx]++;
+			if (!(status->flag & RX_FLAG_HT) &&
+			    status->rate_idx < NUM_STATS_RATES)
+				sta->rx_frames[status->rate_idx]++;
+		}
+	}
+#endif
+
 	/*
 	 * Frames with failed FCS/PLCP checksum are not returned,
 	 * all other frames are returned without radiotap header
--- wireless-testing.orig/net/mac80211/sta_info.h	2008-12-04 12:52:40.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2008-12-15 15:03:34.000000000 +0200
@@ -151,6 +151,9 @@ struct sta_ampdu_mlme {
 #define STA_INFO_PIN_STAT_PINNED	1
 #define STA_INFO_PIN_STAT_DESTROY	2
 
+#define NUM_STATS_RATES 20
+#define NUM_STATS_MCS 76
+
 /**
  * struct sta_info - STA information
  *
@@ -255,6 +258,10 @@ struct sta_info {
 	int last_qual;
 	int last_noise;
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	unsigned long rx_frames[NUM_STATS_RATES];
+	unsigned long rx_frames_mcs[NUM_STATS_MCS];
+#endif
 
 	/* Updated from TX status path only, no locking requirements */
 	unsigned long tx_filtered_count;
@@ -268,6 +275,14 @@ struct sta_info {
 	unsigned long tx_fragments;
 	struct ieee80211_tx_rate last_tx_rate;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	unsigned long tx_frames[NUM_STATS_RATES];
+	unsigned long tx_retries[NUM_STATS_RATES];
+	unsigned long tx_exc_retries[NUM_STATS_RATES];
+	unsigned long tx_frames_mcs[NUM_STATS_MCS];
+	unsigned long tx_retries_mcs[NUM_STATS_MCS];
+	unsigned long tx_exc_retries_mcs[NUM_STATS_MCS];
+#endif
 
 	/*
 	 * Aggregation information, locked with lock.
@@ -298,6 +313,9 @@ struct sta_info {
 		struct dentry *num_ps_buf_frames;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+		struct dentry *txrx;
+#endif
 		struct dentry *agg_status;
 		bool add_has_run;
 	} debugfs;
--- wireless-testing.orig/net/mac80211/main.c	2008-12-15 10:08:12.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2008-12-15 15:10:48.000000000 +0200
@@ -501,6 +501,26 @@ void ieee80211_tx_status(struct ieee8021
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (sta) {
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+		int idx = info->status.rates[0].idx;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+			if (idx >= 0 && idx < NUM_STATS_MCS) {
+				sta->tx_frames_mcs[idx]++;
+				sta->tx_retries_mcs[idx] +=
+					info->status.rates[0].count;
+				if (!(info->flags & (IEEE80211_TX_CTL_NO_ACK |
+						     IEEE80211_TX_STAT_ACK)))
+					sta->tx_exc_retries_mcs[idx]++;
+			}
+		} else if (idx >= 0 && idx < NUM_STATS_RATES) {
+			sta->tx_frames[idx]++;
+			sta->tx_retries[idx] += info->status.rates[0].count;
+			if (!(info->flags & (IEEE80211_TX_CTL_NO_ACK |
+					     IEEE80211_TX_STAT_ACK)))
+				sta->tx_exc_retries[idx]++;
+		}
+#endif
+
 		if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
 		    test_sta_flags(sta, WLAN_STA_PS)) {
 			/*

-- 
Jouni Malinen                                            PGP id EFC895FA
