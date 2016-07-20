Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:44777 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbcGTOzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 10:55:38 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: Keep CoDel stats per txq, export them in debugfs.
Date: Wed, 20 Jul 2016 16:54:42 +0200
Message-Id: <20160720145442.1098-1-toke@toke.dk> (sfid-20160720_165542_917420_468D4AF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the 'aqm' stats in mac80211 only keeps overlimit drop stats,
not CoDel stats. This moves the CoDel stats into the txqi structure and
adds the drop and mark counts to the debug output.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/debugfs.c     | 12 ++++++++----
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/tx.c          |  4 ++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 27e6fb9..69bf2e5 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -137,18 +137,20 @@ static int aqm_open(struct inode *inode, struct file *file)
 	len += scnprintf(info->buf + len,
 			 info->size - len,
 			 "* vif\n"
-			 "ifname addr ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
+			 "ifname addr ac backlog-bytes backlog-packets flows drops marks overlimit collisions tx-bytes tx-packets\n");
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		txqi = to_txq_info(sdata->vif.txq);
 		len += scnprintf(info->buf + len, info->size - len,
-				 "%s %pM %u %u %u %u %u %u %u %u\n",
+				 "%s %pM %u %u %u %u %u %u %u %u %u %u\n",
 				 sdata->name,
 				 sdata->vif.addr,
 				 txqi->txq.ac,
 				 txqi->tin.backlog_bytes,
 				 txqi->tin.backlog_packets,
 				 txqi->tin.flows,
+				 txqi->cstats.drop_count,
+				 txqi->cstats.ecn_mark,
 				 txqi->tin.overlimit,
 				 txqi->tin.collisions,
 				 txqi->tin.tx_bytes,
@@ -158,14 +160,14 @@ static int aqm_open(struct inode *inode, struct file *file)
 	len += scnprintf(info->buf + len,
 			 info->size - len,
 			 "* sta\n"
-			 "ifname addr tid ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
+			 "ifname addr tid ac backlog-bytes backlog-packets flows drops marks overlimit collisions tx-bytes tx-packets\n");
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		sdata = sta->sdata;
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			txqi = to_txq_info(sta->sta.txq[i]);
 			len += scnprintf(info->buf + len, info->size - len,
-					 "%s %pM %d %d %u %u %u %u %u %u %u\n",
+					 "%s %pM %d %d %u %u %u %u %u %u %u %u %u\n",
 					 sdata->name,
 					 sta->sta.addr,
 					 txqi->txq.tid,
@@ -173,6 +175,8 @@ static int aqm_open(struct inode *inode, struct file *file)
 					 txqi->tin.backlog_bytes,
 					 txqi->tin.backlog_packets,
 					 txqi->tin.flows,
+					 txqi->cstats.drop_count,
+					 txqi->cstats.ecn_mark,
 					 txqi->tin.overlimit,
 					 txqi->tin.collisions,
 					 txqi->tin.tx_bytes,
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
2.9.0
