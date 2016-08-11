Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:40821 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbcHKPMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 11:12:12 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v2] mac80211: Re-structure aqm debugfs output and include
	CoDel drops
Date: Thu, 11 Aug 2016 17:11:56 +0200
Message-Id: <20160811151156.6485-1-toke@toke.dk> (sfid-20160811_171216_207117_5110F87B)
In-Reply-To: <20160720145442.1098-1-toke@toke.dk>
References: <20160720145442.1098-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the 'aqm' stats in mac80211 only keeps overlimit drop stats,
not CoDel stats. This moves the CoDel stats into the txqi structure to
keep them per txq in order to show them in debugfs.

In addition, the aqm debugfs output is restructured by splitting it up
into three files: One global per phy, one per netdev and one per
station, in the appropriate directories. The files are all called aqm,
and are only created if the driver supports the wake_tx_queue op (rather
than emitting an error on open as previously).

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/debugfs.c        | 151 ++++++++----------------------------------
 net/mac80211/debugfs_netdev.c |  37 ++++++++++-
 net/mac80211/debugfs_sta.c    |  45 +++++++++++++
 net/mac80211/ieee80211_i.h    |   2 +-
 net/mac80211/tx.c             |   4 +-
 5 files changed, 110 insertions(+), 129 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 27e6fb9..2f14141 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -71,138 +71,39 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
-struct aqm_info {
-	struct ieee80211_local *local;
-	size_t size;
-	size_t len;
-	unsigned char buf[0];
-};
-
-#define AQM_HDR_LEN 200
-#define AQM_HW_ENTRY_LEN 40
-#define AQM_TXQ_ENTRY_LEN 110
-
-static int aqm_open(struct inode *inode, struct file *file)
+static ssize_t aqm_read(struct file *file,
+			char __user *user_buf,
+			size_t count,
+			loff_t *ppos)
 {
-	struct ieee80211_local *local = inode->i_private;
-	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
-	struct txq_info *txqi;
+	struct ieee80211_local *local = file->private_data;
 	struct fq *fq = &local->fq;
-	struct aqm_info *info = NULL;
+	char buf[200];
 	int len = 0;
-	int i;
-
-	if (!local->ops->wake_tx_queue)
-		return -EOPNOTSUPP;
-
-	len += AQM_HDR_LEN;
-	len += 6 * AQM_HW_ENTRY_LEN;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		len += AQM_TXQ_ENTRY_LEN;
-	list_for_each_entry_rcu(sta, &local->sta_list, list)
-		len += AQM_TXQ_ENTRY_LEN * ARRAY_SIZE(sta->sta.txq);
-	rcu_read_unlock();
-
-	info = vmalloc(len);
-	if (!info)
-		return -ENOMEM;
 
 	spin_lock_bh(&local->fq.lock);
 	rcu_read_lock();
 
-	file->private_data = info;
-	info->local = local;
-	info->size = len;
-	len = 0;
-
-	len += scnprintf(info->buf + len, info->size - len,
-			 "* hw\n"
-			 "access name value\n"
-			 "R fq_flows_cnt %u\n"
-			 "R fq_backlog %u\n"
-			 "R fq_overlimit %u\n"
-			 "R fq_collisions %u\n"
-			 "RW fq_limit %u\n"
-			 "RW fq_quantum %u\n",
-			 fq->flows_cnt,
-			 fq->backlog,
-			 fq->overlimit,
-			 fq->collisions,
-			 fq->limit,
-			 fq->quantum);
-
-	len += scnprintf(info->buf + len,
-			 info->size - len,
-			 "* vif\n"
-			 "ifname addr ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
-
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		txqi = to_txq_info(sdata->vif.txq);
-		len += scnprintf(info->buf + len, info->size - len,
-				 "%s %pM %u %u %u %u %u %u %u %u\n",
-				 sdata->name,
-				 sdata->vif.addr,
-				 txqi->txq.ac,
-				 txqi->tin.backlog_bytes,
-				 txqi->tin.backlog_packets,
-				 txqi->tin.flows,
-				 txqi->tin.overlimit,
-				 txqi->tin.collisions,
-				 txqi->tin.tx_bytes,
-				 txqi->tin.tx_packets);
-	}
-
-	len += scnprintf(info->buf + len,
-			 info->size - len,
-			 "* sta\n"
-			 "ifname addr tid ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		sdata = sta->sdata;
-		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-			txqi = to_txq_info(sta->sta.txq[i]);
-			len += scnprintf(info->buf + len, info->size - len,
-					 "%s %pM %d %d %u %u %u %u %u %u %u\n",
-					 sdata->name,
-					 sta->sta.addr,
-					 txqi->txq.tid,
-					 txqi->txq.ac,
-					 txqi->tin.backlog_bytes,
-					 txqi->tin.backlog_packets,
-					 txqi->tin.flows,
-					 txqi->tin.overlimit,
-					 txqi->tin.collisions,
-					 txqi->tin.tx_bytes,
-					 txqi->tin.tx_packets);
-		}
-	}
-
-	info->len = len;
+	len = scnprintf(buf, sizeof(buf),
+			"access name value\n"
+			"R fq_flows_cnt %u\n"
+			"R fq_backlog %u\n"
+			"R fq_overlimit %u\n"
+			"R fq_collisions %u\n"
+			"RW fq_limit %u\n"
+			"RW fq_quantum %u\n",
+			fq->flows_cnt,
+			fq->backlog,
+			fq->overlimit,
+			fq->collisions,
+			fq->limit,
+			fq->quantum);
 
 	rcu_read_unlock();
 	spin_unlock_bh(&local->fq.lock);
 
-	return 0;
-}
-
-static int aqm_release(struct inode *inode, struct file *file)
-{
-	vfree(file->private_data);
-	return 0;
-}
-
-static ssize_t aqm_read(struct file *file,
-			char __user *user_buf,
-			size_t count,
-			loff_t *ppos)
-{
-	struct aqm_info *info = file->private_data;
-
 	return simple_read_from_buffer(user_buf, count, ppos,
-				       info->buf, info->len);
+				       buf, len);
 }
 
 static ssize_t aqm_write(struct file *file,
@@ -210,8 +111,7 @@ static ssize_t aqm_write(struct file *file,
 			 size_t count,
 			 loff_t *ppos)
 {
-	struct aqm_info *info = file->private_data;
-	struct ieee80211_local *local = info->local;
+	struct ieee80211_local *local = file->private_data;
 	char buf[100];
 	size_t len;
 
@@ -237,8 +137,7 @@ static ssize_t aqm_write(struct file *file,
 static const struct file_operations aqm_ops = {
 	.write = aqm_write,
 	.read = aqm_read,
-	.open = aqm_open,
-	.release = aqm_release,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -425,7 +324,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
-	DEBUGFS_ADD_MODE(aqm, 0600);
+
+	if (local->ops->wake_tx_queue)
+		DEBUGFS_ADD_MODE(aqm, 0600);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 37ea30e..30c5b47 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -30,7 +30,7 @@ static ssize_t ieee80211_if_read(
 	size_t count, loff_t *ppos,
 	ssize_t (*format)(const struct ieee80211_sub_if_data *, char *, int))
 {
-	char buf[70];
+	char buf[200];
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
@@ -486,6 +486,38 @@ static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 }
 IEEE80211_IF_FILE_R(num_buffered_multicast);
 
+static ssize_t ieee80211_if_fmt_aqm(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct txq_info *txqi = to_txq_info(sdata->vif.txq);
+	int len;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	len = scnprintf(buf,
+			buflen,
+			"ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n"
+			"%u %u %u %u %u %u %u %u %u %u\n",
+			txqi->txq.ac,
+			txqi->tin.backlog_bytes,
+			txqi->tin.backlog_packets,
+			txqi->tin.flows,
+			txqi->cstats.drop_count,
+			txqi->cstats.ecn_mark,
+			txqi->tin.overlimit,
+			txqi->tin.collisions,
+			txqi->tin.tx_bytes,
+			txqi->tin.tx_packets);
+
+	rcu_read_unlock();
+	spin_unlock_bh(&local->fq.lock);
+
+	return len;
+}
+IEEE80211_IF_FILE_R(aqm);
+
 /* IBSS attributes */
 static ssize_t ieee80211_if_fmt_tsf(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -618,6 +650,9 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
+
+	if (sdata->local->ops->wake_tx_queue)
+		DEBUGFS_ADD(aqm);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a39512f..634b41c 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -109,6 +109,48 @@ static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(last_seq_ctrl);
 
+#define AQM_TXQ_ENTRY_LEN 130
+
+static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
+			size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->local;
+	char buf[AQM_TXQ_ENTRY_LEN*(IEEE80211_NUM_TIDS+1)], *p = buf;
+	struct txq_info *txqi;
+	int i;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	p += scnprintf(p,
+		       sizeof(buf)+buf-p,
+		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n");
+
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		txqi = to_txq_info(sta->sta.txq[i]);
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%d %d %u %u %u %u %u %u %u %u %u\n",
+			       txqi->txq.tid,
+			       txqi->txq.ac,
+			       txqi->tin.backlog_bytes,
+			       txqi->tin.backlog_packets,
+			       txqi->tin.flows,
+			       txqi->cstats.drop_count,
+			       txqi->cstats.ecn_mark,
+			       txqi->tin.overlimit,
+			       txqi->tin.collisions,
+			       txqi->tin.tx_bytes,
+			       txqi->tin.tx_packets);
+	}
+
+	rcu_read_unlock();
+	spin_unlock_bh(&local->fq.lock);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(aqm);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -370,6 +412,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
 	DEBUGFS_ADD_COUNTER(tx_filtered, status_stats.filtered);
 
+	if (local->ops->wake_tx_queue)
+		DEBUGFS_ADD(aqm);
+
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs.dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c9f8c80..9f11b13 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,6 +812,7 @@ struct txq_info {
 	struct fq_tin tin;
 	struct fq_flow def_flow;
 	struct codel_vars def_cvars;
+	struct codel_stats cstats;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1106,7 +1107,6 @@ struct ieee80211_local {
 	struct fq fq;
 	struct codel_vars *cvars;
 	struct codel_params cparams;
-	struct codel_stats cstats;
 
 	const struct ieee80211_ops *ops;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 682011e..201167d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1339,7 +1339,7 @@ static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 	local = container_of(fq, struct ieee80211_local, fq);
 	txqi = container_of(tin, struct txq_info, tin);
 	cparams = &local->cparams;
-	cstats = &local->cstats;
+	cstats = &txqi->cstats;
 
 	if (flow == &txqi->def_flow)
 		cvars = &txqi->def_cvars;
@@ -1399,6 +1399,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	fq_tin_init(&txqi->tin);
 	fq_flow_init(&txqi->def_flow);
 	codel_vars_init(&txqi->def_cvars);
+	codel_stats_init(&txqi->cstats);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1437,7 +1438,6 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 		return ret;
 
 	codel_params_init(&local->cparams);
-	codel_stats_init(&local->cstats);
 	local->cparams.interval = MS2TIME(100);
 	local->cparams.target = MS2TIME(20);
 	local->cparams.ecn = true;
-- 
2.9.2
