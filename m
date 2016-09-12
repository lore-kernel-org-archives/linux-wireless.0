Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:48998 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932270AbcILN4F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:56:05 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v3] mac80211: Re-structure aqm debugfs output and keep CoDel
        stats per txq
Date: Mon, 12 Sep 2016 15:55:43 +0200
Message-Id: <20160912135543.26347-1-toke@toke.dk> (sfid-20160912_155610_196048_AB181E36)
In-Reply-To: <20160811151156.6485-1-toke@toke.dk>
References: <20160811151156.6485-1-toke@toke.dk>
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

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
Changes since v2:
  - Dynamically allocate buffer in per-station function.
  - Rebase on current mac80211-next.
 =20
 net/mac80211/debugfs.c        | 151 ++++++++----------------------------=
------
 net/mac80211/debugfs_netdev.c |  37 ++++++++++-
 net/mac80211/debugfs_sta.c    |  52 +++++++++++++++
 net/mac80211/ieee80211_i.h    |   2 +-
 net/mac80211/tx.c             |   4 +-
 5 files changed, 117 insertions(+), 129 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2906c10..5bbb470 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -71,138 +71,39 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
=20
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
-	struct ieee80211_local *local =3D inode->i_private;
-	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
-	struct txq_info *txqi;
+	struct ieee80211_local *local =3D file->private_data;
 	struct fq *fq =3D &local->fq;
-	struct aqm_info *info =3D NULL;
+	char buf[200];
 	int len =3D 0;
-	int i;
-
-	if (!local->ops->wake_tx_queue)
-		return -EOPNOTSUPP;
-
-	len +=3D AQM_HDR_LEN;
-	len +=3D 6 * AQM_HW_ENTRY_LEN;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		len +=3D AQM_TXQ_ENTRY_LEN;
-	list_for_each_entry_rcu(sta, &local->sta_list, list)
-		len +=3D AQM_TXQ_ENTRY_LEN * ARRAY_SIZE(sta->sta.txq);
-	rcu_read_unlock();
-
-	info =3D vmalloc(len);
-	if (!info)
-		return -ENOMEM;
=20
 	spin_lock_bh(&local->fq.lock);
 	rcu_read_lock();
=20
-	file->private_data =3D info;
-	info->local =3D local;
-	info->size =3D len;
-	len =3D 0;
-
-	len +=3D scnprintf(info->buf + len, info->size - len,
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
-	len +=3D scnprintf(info->buf + len,
-			 info->size - len,
-			 "* vif\n"
-			 "ifname addr ac backlog-bytes backlog-packets flows overlimit collis=
ions tx-bytes tx-packets\n");
-
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		txqi =3D to_txq_info(sdata->vif.txq);
-		len +=3D scnprintf(info->buf + len, info->size - len,
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
-	len +=3D scnprintf(info->buf + len,
-			 info->size - len,
-			 "* sta\n"
-			 "ifname addr tid ac backlog-bytes backlog-packets flows overlimit co=
llisions tx-bytes tx-packets\n");
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		sdata =3D sta->sdata;
-		for (i =3D 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-			txqi =3D to_txq_info(sta->sta.txq[i]);
-			len +=3D scnprintf(info->buf + len, info->size - len,
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
-	info->len =3D len;
+	len =3D scnprintf(buf, sizeof(buf),
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
=20
 	rcu_read_unlock();
 	spin_unlock_bh(&local->fq.lock);
=20
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
-	struct aqm_info *info =3D file->private_data;
-
 	return simple_read_from_buffer(user_buf, count, ppos,
-				       info->buf, info->len);
+				       buf, len);
 }
=20
 static ssize_t aqm_write(struct file *file,
@@ -210,8 +111,7 @@ static ssize_t aqm_write(struct file *file,
 			 size_t count,
 			 loff_t *ppos)
 {
-	struct aqm_info *info =3D file->private_data;
-	struct ieee80211_local *local =3D info->local;
+	struct ieee80211_local *local =3D file->private_data;
 	char buf[100];
 	size_t len;
=20
@@ -237,8 +137,7 @@ static ssize_t aqm_write(struct file *file,
 static const struct file_operations aqm_ops =3D {
 	.write =3D aqm_write,
 	.read =3D aqm_read,
-	.open =3D aqm_open,
-	.release =3D aqm_release,
+	.open =3D simple_open,
 	.llseek =3D default_llseek,
 };
=20
@@ -428,7 +327,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
-	DEBUGFS_ADD_MODE(aqm, 0600);
+
+	if (local->ops->wake_tx_queue)
+		DEBUGFS_ADD_MODE(aqm, 0600);
=20
 	statsd =3D debugfs_create_dir("statistics", phyd);
=20
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.=
c
index a5ba739..5d35c0f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -30,7 +30,7 @@ static ssize_t ieee80211_if_read(
 	size_t count, loff_t *ppos,
 	ssize_t (*format)(const struct ieee80211_sub_if_data *, char *, int))
 {
-	char buf[70];
+	char buf[200];
 	ssize_t ret =3D -EINVAL;
=20
 	read_lock(&dev_base_lock);
@@ -486,6 +486,38 @@ static ssize_t ieee80211_if_fmt_num_buffered_multica=
st(
 }
 IEEE80211_IF_FILE_R(num_buffered_multicast);
=20
+static ssize_t ieee80211_if_fmt_aqm(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	struct ieee80211_local *local =3D sdata->local;
+	struct txq_info *txqi =3D to_txq_info(sdata->vif.txq);
+	int len;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	len =3D scnprintf(buf,
+			buflen,
+			"ac backlog-bytes backlog-packets new-flows drops marks overlimit col=
lisions tx-bytes tx-packets\n"
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
@@ -618,6 +650,9 @@ static void add_common_files(struct ieee80211_sub_if_=
data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
+
+	if (sdata->local->ops->wake_tx_queue)
+		DEBUGFS_ADD(aqm);
 }
=20
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fd33413..fb26935 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -133,6 +133,55 @@ static ssize_t sta_last_seq_ctrl_read(struct file *f=
ile, char __user *userbuf,
 }
 STA_OPS(last_seq_ctrl);
=20
+#define AQM_TXQ_ENTRY_LEN 130
+
+static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
+			size_t count, loff_t *ppos)
+{
+	struct sta_info *sta =3D file->private_data;
+	struct ieee80211_local *local =3D sta->local;
+	size_t bufsz =3D AQM_TXQ_ENTRY_LEN*(IEEE80211_NUM_TIDS+1);
+	char *buf =3D kzalloc(bufsz, GFP_KERNEL), *p =3D buf;
+	struct txq_info *txqi;
+	ssize_t rv;
+	int i;
+
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	p +=3D scnprintf(p,
+		       bufsz+buf-p,
+		       "tid ac backlog-bytes backlog-packets new-flows drops marks ove=
rlimit collisions tx-bytes tx-packets\n");
+
+	for (i =3D 0; i < IEEE80211_NUM_TIDS; i++) {
+		txqi =3D to_txq_info(sta->sta.txq[i]);
+		p +=3D scnprintf(p, bufsz+buf-p,
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
+	rv =3D simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return rv;
+}
+STA_OPS(aqm);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userb=
uf,
 					size_t count, loff_t *ppos)
 {
@@ -478,6 +527,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
 	DEBUGFS_ADD_COUNTER(tx_filtered, status_stats.filtered);
=20
+	if (local->ops->wake_tx_queue)
+		DEBUGFS_ADD(aqm);
+
 	if (sizeof(sta->driver_buffered_tids) =3D=3D sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs_dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7576168..c71c735 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -818,6 +818,7 @@ struct txq_info {
 	struct fq_tin tin;
 	struct fq_flow def_flow;
 	struct codel_vars def_cvars;
+	struct codel_stats cstats;
 	unsigned long flags;
=20
 	/* keep last! */
@@ -1117,7 +1118,6 @@ struct ieee80211_local {
 	struct fq fq;
 	struct codel_vars *cvars;
 	struct codel_params cparams;
-	struct codel_stats cstats;
=20
 	const struct ieee80211_ops *ops;
=20
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index efc38e7..ee9e7d6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1343,7 +1343,7 @@ static struct sk_buff *fq_tin_dequeue_func(struct f=
q *fq,
 	local =3D container_of(fq, struct ieee80211_local, fq);
 	txqi =3D container_of(tin, struct txq_info, tin);
 	cparams =3D &local->cparams;
-	cstats =3D &local->cstats;
+	cstats =3D &txqi->cstats;
=20
 	if (flow =3D=3D &txqi->def_flow)
 		cvars =3D &txqi->def_cvars;
@@ -1403,6 +1403,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_dat=
a *sdata,
 	fq_tin_init(&txqi->tin);
 	fq_flow_init(&txqi->def_flow);
 	codel_vars_init(&txqi->def_cvars);
+	codel_stats_init(&txqi->cstats);
=20
 	txqi->txq.vif =3D &sdata->vif;
=20
@@ -1441,7 +1442,6 @@ int ieee80211_txq_setup_flows(struct ieee80211_loca=
l *local)
 		return ret;
=20
 	codel_params_init(&local->cparams);
-	codel_stats_init(&local->cstats);
 	local->cparams.interval =3D MS2TIME(100);
 	local->cparams.target =3D MS2TIME(20);
 	local->cparams.ecn =3D true;
--=20
2.9.3
