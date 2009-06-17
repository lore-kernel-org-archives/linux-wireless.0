Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZFQP3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 11:29:13 -0400
Subject: [PATCH v2] mac80211: improve per-sta debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1245251964.31588.16.camel@johannes.local>
References: <1245251964.31588.16.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 17:28:45 +0200
Message-Id: <1245252525.31588.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We had code for a number of files, that we didn't publish
in debugfs, fix that. Also make the agg_status file layout
more readable and add more information to it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c |   98 ++++++++++++++++++++++++++++-----------------
 net/mac80211/sta_info.h    |   17 +++++++
 2 files changed, 79 insertions(+), 36 deletions(-)

--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-06-17 17:18:01.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-06-17 17:26:20.000000000 +0200
@@ -120,45 +120,38 @@ STA_OPS(last_seq_ctrl);
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
-	char buf[768], *p = buf;
+	char buf[30 + STA_TID_NUM * 70], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
-	p += scnprintf(p, sizeof(buf)+buf-p, "Agg state for STA is:\n");
-	p += scnprintf(p, sizeof(buf)+buf-p, " STA next dialog_token is %d \n "
-			"TIDs info is: \n TID :",
-			(sta->ampdu_mlme.dialog_token_allocator + 1));
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d", i);
-
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n RX  :");
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_state_rx[i]);
-
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_state_rx[i] ?
-			sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
-
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n TX  :");
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_state_tx[i]);
-
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_state_tx[i] ?
-			sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
-
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n SSN :");
-	for (i = 0; i < STA_TID_NUM; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_state_tx[i] ?
-			sta->ampdu_mlme.tid_tx[i]->ssn : 0);
 
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+	spin_lock_bh(&sta->lock);
+	p += scnprintf(p, sizeof(buf)+buf-p, "next dialog_token is %#02x\n",
+			sta->ampdu_mlme.dialog_token_allocator + 1);
+	for (i = 0; i < STA_TID_NUM; i++) {
+		p += scnprintf(p, sizeof(buf)+buf-p, "TID %02d:", i);
+		p += scnprintf(p, sizeof(buf)+buf-p, " RX=%x",
+				sta->ampdu_mlme.tid_state_rx[i]);
+		p += scnprintf(p, sizeof(buf)+buf-p, "/DTKN=%#.2x",
+				sta->ampdu_mlme.tid_state_rx[i] ?
+				sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
+		p += scnprintf(p, sizeof(buf)+buf-p, "/SSN=%#.3x",
+				sta->ampdu_mlme.tid_state_rx[i] ?
+				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
+
+		p += scnprintf(p, sizeof(buf)+buf-p, " TX=%x",
+				sta->ampdu_mlme.tid_state_tx[i]);
+		p += scnprintf(p, sizeof(buf)+buf-p, "/DTKN=%#.2x",
+				sta->ampdu_mlme.tid_state_tx[i] ?
+				sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
+		p += scnprintf(p, sizeof(buf)+buf-p, "/SSN=%#.3x",
+				sta->ampdu_mlme.tid_state_tx[i] ?
+				sta->ampdu_mlme.tid_tx[i]->ssn : 0);
+		p += scnprintf(p, sizeof(buf)+buf-p, "/pending=%03d",
+				sta->ampdu_mlme.tid_state_tx[i] ?
+				skb_queue_len(&sta->ampdu_mlme.tid_tx[i]->pending) : 0);
+		p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+	}
+	spin_unlock_bh(&sta->lock);
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
@@ -203,6 +196,22 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
 	DEBUGFS_ADD(agg_status);
+	DEBUGFS_ADD(dev);
+	DEBUGFS_ADD(rx_packets);
+	DEBUGFS_ADD(tx_packets);
+	DEBUGFS_ADD(rx_bytes);
+	DEBUGFS_ADD(tx_bytes);
+	DEBUGFS_ADD(rx_duplicates);
+	DEBUGFS_ADD(rx_fragments);
+	DEBUGFS_ADD(rx_dropped);
+	DEBUGFS_ADD(tx_fragments);
+	DEBUGFS_ADD(tx_filtered);
+	DEBUGFS_ADD(tx_retry_failed);
+	DEBUGFS_ADD(tx_retry_count);
+	DEBUGFS_ADD(last_signal);
+	DEBUGFS_ADD(last_qual);
+	DEBUGFS_ADD(last_noise);
+	DEBUGFS_ADD(wep_weak_iv_count);
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -212,6 +221,23 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
 	DEBUGFS_DEL(agg_status);
+	DEBUGFS_DEL(aid);
+	DEBUGFS_DEL(dev);
+	DEBUGFS_DEL(rx_packets);
+	DEBUGFS_DEL(tx_packets);
+	DEBUGFS_DEL(rx_bytes);
+	DEBUGFS_DEL(tx_bytes);
+	DEBUGFS_DEL(rx_duplicates);
+	DEBUGFS_DEL(rx_fragments);
+	DEBUGFS_DEL(rx_dropped);
+	DEBUGFS_DEL(tx_fragments);
+	DEBUGFS_DEL(tx_filtered);
+	DEBUGFS_DEL(tx_retry_failed);
+	DEBUGFS_DEL(tx_retry_count);
+	DEBUGFS_DEL(last_signal);
+	DEBUGFS_DEL(last_qual);
+	DEBUGFS_DEL(last_noise);
+	DEBUGFS_DEL(wep_weak_iv_count);
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-06-17 17:18:02.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-06-17 17:18:05.000000000 +0200
@@ -308,6 +308,23 @@ struct sta_info {
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
 		struct dentry *agg_status;
+		struct dentry *aid;
+		struct dentry *dev;
+		struct dentry *rx_packets;
+		struct dentry *tx_packets;
+		struct dentry *rx_bytes;
+		struct dentry *tx_bytes;
+		struct dentry *rx_duplicates;
+		struct dentry *rx_fragments;
+		struct dentry *rx_dropped;
+		struct dentry *tx_fragments;
+		struct dentry *tx_filtered;
+		struct dentry *tx_retry_failed;
+		struct dentry *tx_retry_count;
+		struct dentry *last_signal;
+		struct dentry *last_qual;
+		struct dentry *last_noise;
+		struct dentry *wep_weak_iv_count;
 		bool add_has_run;
 	} debugfs;
 #endif


