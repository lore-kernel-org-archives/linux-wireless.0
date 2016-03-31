Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36337 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbcCaK0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 06:26:22 -0400
Received: by mail-lf0-f52.google.com with SMTP id e133so56198583lfe.3
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 03:26:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 2/2] mac80211: expose some txq/fq internals and knobs via debugfs
Date: Thu, 31 Mar 2016 12:28:24 +0200
Message-Id: <1459420104-31554-3-git-send-email-michal.kazior@tieto.com> (sfid-20160331_122628_870198_1BA2A738)
In-Reply-To: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
 <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it easier to debug, test and experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * add moduleparam.h to tx.c (fixes broken compilation with backports)

 net/mac80211/debugfs.c        | 86 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c | 29 ++++++++++++++-
 net/mac80211/debugfs_sta.c    | 46 +++++++++++++++++++++++
 net/mac80211/tx.c             |  8 +++-
 4 files changed, 167 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4ab5c522ceee..81d3f5a9910d 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -31,6 +31,30 @@ int mac80211_format_buffer(char __user *userbuf, size_t count,
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
+static int mac80211_parse_buffer(const char __user *userbuf,
+				 size_t count,
+				 loff_t *ppos,
+				 char *fmt, ...)
+{
+	va_list args;
+	char buf[DEBUGFS_FORMAT_BUFFER_SIZE] = {};
+	int res;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, userbuf, count))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] = '\0';
+
+	va_start(args, fmt);
+	res = vsscanf(buf, fmt, args);
+	va_end(args);
+
+	return count;
+}
+
 #define DEBUGFS_READONLY_FILE_FN(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -70,6 +94,59 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
+#define DEBUGFS_RW_FILE_FN(name, expr)				\
+static ssize_t name## _write(struct file *file,			\
+			     const char __user *userbuf,	\
+			     size_t count,			\
+			     loff_t *ppos)			\
+{								\
+	struct ieee80211_local *local = file->private_data;	\
+	return expr;						\
+}
+
+#define DEBUGFS_RW_FILE(name, expr, fmt, value...)	\
+	DEBUGFS_READONLY_FILE_FN(name, fmt, value)	\
+	DEBUGFS_RW_FILE_FN(name, expr)			\
+	DEBUGFS_RW_FILE_OPS(name)
+
+#define DEBUGFS_RW_FILE_OPS(name)			\
+static const struct file_operations name## _ops = {	\
+	.read = name## _read,				\
+	.write = name## _write,				\
+	.open = simple_open,				\
+	.llseek = generic_file_llseek,			\
+}
+
+#define DEBUGFS_RW_EXPR_FQ(args...)					\
+({									\
+	int res;							\
+	res = mac80211_parse_buffer(userbuf, count, ppos, args);	\
+	res;								\
+})
+
+DEBUGFS_READONLY_FILE(fq_drop_overlimit, "%u",
+		      local->fq.drop_overlimit);
+DEBUGFS_READONLY_FILE(fq_drop_codel, "%u",
+		      local->fq.drop_codel);
+DEBUGFS_READONLY_FILE(fq_backlog, "%u",
+		      local->fq.backlog);
+DEBUGFS_READONLY_FILE(fq_flows_cnt, "%u",
+		      local->fq.flows_cnt);
+
+DEBUGFS_RW_FILE(fq_target,
+		DEBUGFS_RW_EXPR_FQ("%llu", &local->fq.cparams.target),
+		"%llu", local->fq.cparams.target);
+DEBUGFS_RW_FILE(fq_interval,
+		DEBUGFS_RW_EXPR_FQ("%llu", &local->fq.cparams.interval),
+		"%llu", local->fq.cparams.interval);
+DEBUGFS_RW_FILE(fq_quantum,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.quantum),
+		"%u", local->fq.quantum);
+DEBUGFS_RW_FILE(fq_txq_limit,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.txq_limit),
+		"%u", local->fq.txq_limit);
+
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -254,6 +331,15 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
+	DEBUGFS_ADD(fq_drop_overlimit);
+	DEBUGFS_ADD(fq_drop_codel);
+	DEBUGFS_ADD(fq_backlog);
+	DEBUGFS_ADD(fq_flows_cnt);
+	DEBUGFS_ADD(fq_target);
+	DEBUGFS_ADD(fq_interval);
+	DEBUGFS_ADD(fq_quantum);
+	DEBUGFS_ADD(fq_txq_limit);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 37ea30e0754c..39ae13d19387 100644
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
@@ -236,6 +236,32 @@ ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
 }
 IEEE80211_IF_FILE_R(hw_queues);
 
+static ssize_t
+ieee80211_if_fmt_txq(const struct ieee80211_sub_if_data *sdata,
+		     char *buf, int buflen)
+{
+	struct txq_info *txqi;
+	int len = 0;
+
+	if (!sdata->vif.txq)
+		return 0;
+
+	txqi = to_txq_info(sdata->vif.txq);
+	len += scnprintf(buf + len, buflen - len,
+			 "CAB backlog %ub %up flows %u drops %u overlimit %u collisions %u tx %ub %up\n",
+			 txqi->backlog_bytes,
+			 txqi->backlog_packets,
+			 txqi->flows,
+			 txqi->drop_codel,
+			 txqi->drop_overlimit,
+			 txqi->collisions,
+			 txqi->tx_bytes,
+			 txqi->tx_packets);
+
+	return len;
+}
+IEEE80211_IF_FILE_R(txq);
+
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
@@ -618,6 +644,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
+	DEBUGFS_ADD(txq);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a39512f09f9e..7322fb098f4d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -319,6 +319,51 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(vht_capa);
 
+static ssize_t sta_txqs_read(struct file *file,
+			     char __user *userbuf,
+			     size_t count,
+			     loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct txq_info *txqi;
+	char *buf;
+	int buflen;
+	int len;
+	int res;
+	int i;
+
+	len = 0;
+	buflen = 200 * IEEE80211_NUM_TIDS;
+	buf = kzalloc(buflen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		if (!sta->sta.txq[i])
+			break;
+
+		txqi = to_txq_info(sta->sta.txq[i]);
+		len += scnprintf(buf + len, buflen - len,
+				 "TID %d AC %d backlog %ub %up flows %u drops %u overlimit %u collisions %u tx %ub %up\n",
+				 i,
+				 txqi->txq.ac,
+				 txqi->backlog_bytes,
+				 txqi->backlog_packets,
+				 txqi->flows,
+				 txqi->drop_codel,
+				 txqi->drop_overlimit,
+				 txqi->collisions,
+				 txqi->tx_bytes,
+				 txqi->tx_packets);
+	}
+
+	res = simple_read_from_buffer(userbuf, count, ppos, buf, len);
+	kfree(buf);
+
+	return res;
+}
+STA_OPS(txqs);
+
 
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
@@ -365,6 +410,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
+	DEBUGFS_ADD(txqs);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dd65e34f7107..29ce9a110680 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <linux/moduleparam.h>
 #include <linux/bitmap.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
@@ -36,6 +37,11 @@
 #include "rate.h"
 #include "codel.h"
 
+static unsigned int fq_flows_cnt = 4096;
+module_param(fq_flows_cnt, uint, 0644);
+MODULE_PARM_DESC(fq_flows_cnt,
+		 "Maximum number of txq fair queuing flows. ");
+
 /* misc utils */
 
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
@@ -1347,7 +1353,7 @@ int ieee80211_setup_flows(struct ieee80211_local *local)
 	memset(fq, 0, sizeof(fq[0]));
 	INIT_LIST_HEAD(&fq->backlogs);
 	spin_lock_init(&fq->lock);
-	fq->flows_cnt = 4096;
+	fq->flows_cnt = max_t(u32, fq_flows_cnt, 1);
 	fq->perturbation = prandom_u32();
 	fq->quantum = 300;
 	fq->txq_limit = 8192;
-- 
2.1.4

