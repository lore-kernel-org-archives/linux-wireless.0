Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33159 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbcEEK6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 06:58:54 -0400
Received: by mail-lf0-f46.google.com with SMTP id y84so92008904lfc.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 03:58:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv4 3/5] mac80211: add debug knobs for fair queuing
Date: Thu,  5 May 2016 13:00:37 +0200
Message-Id: <1462446039-1070-4-git-send-email-michal.kazior@tieto.com> (sfid-20160505_125904_216361_C92F2A2C)
In-Reply-To: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
 <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few debugfs entries and a module
parameter to make it easier to test, debug and
experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/debugfs.c        | 77 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c | 28 +++++++++++++++-
 net/mac80211/debugfs_sta.c    | 45 +++++++++++++++++++++++++
 net/mac80211/tx.c             |  8 ++++-
 4 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b251b2f7f8dd..43592b6f79f0 100644
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
@@ -70,6 +94,52 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
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
+DEBUGFS_READONLY_FILE(fq_flows_cnt, "%u",
+		      local->fq.flows_cnt);
+DEBUGFS_READONLY_FILE(fq_backlog, "%u",
+		      local->fq.backlog);
+DEBUGFS_READONLY_FILE(fq_overlimit, "%u",
+		      local->fq.overlimit);
+DEBUGFS_READONLY_FILE(fq_collisions, "%u",
+		      local->fq.collisions);
+
+DEBUGFS_RW_FILE(fq_limit,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.limit),
+		"%u", local->fq.limit);
+DEBUGFS_RW_FILE(fq_quantum,
+		DEBUGFS_RW_EXPR_FQ("%u", &local->fq.quantum),
+		"%u", local->fq.quantum);
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -257,6 +327,13 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
+	DEBUGFS_ADD(fq_flows_cnt);
+	DEBUGFS_ADD(fq_backlog);
+	DEBUGFS_ADD(fq_overlimit);
+	DEBUGFS_ADD(fq_collisions);
+	DEBUGFS_ADD(fq_limit);
+	DEBUGFS_ADD(fq_quantum);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index a5ba739cd2a7..369755b2b078 100644
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
@@ -236,6 +236,31 @@ ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
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
+			 "CAB backlog %ub %up flows %u overlimit %u collisions %u tx %ub %up\n",
+			 txqi->tin.backlog_bytes,
+			 txqi->tin.backlog_packets,
+			 txqi->tin.flows,
+			 txqi->tin.overlimit,
+			 txqi->tin.collisions,
+			 txqi->tin.tx_bytes,
+			 txqi->tin.tx_packets);
+
+	return len;
+}
+IEEE80211_IF_FILE_R(txq);
+
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
@@ -618,6 +643,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
+	DEBUGFS_ADD(txq);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 33dfcbc2bf9c..bae1c39517af 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -355,6 +355,50 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
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
+				 "TID %d AC %d backlog %ub %up flows %u overlimit %u collisions %u tx %ub %up\n",
+				 i,
+				 txqi->txq.ac,
+				 txqi->tin.backlog_bytes,
+				 txqi->tin.backlog_packets,
+				 txqi->tin.flows,
+				 txqi->tin.overlimit,
+				 txqi->tin.collisions,
+				 txqi->tin.tx_bytes,
+				 txqi->tin.tx_packets);
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
@@ -399,6 +443,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
+	DEBUGFS_ADD(txqs);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 56633b012ba1..47936b939591 100644
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
 #include "wme.h"
 #include "rate.h"
 
+static unsigned int fq_flows_cnt = 4096;
+module_param(fq_flows_cnt, uint, 0644);
+MODULE_PARM_DESC(fq_flows_cnt,
+		 "Maximum number of txq fair queuing flows. ");
+
 /* misc utils */
 
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
@@ -1342,7 +1348,7 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	if (!local->ops->wake_tx_queue)
 		return 0;
 
-	ret = fq_init(fq, 4096);
+	ret = fq_init(fq, max_t(u32, fq_flows_cnt, 1));
 	if (ret)
 		return ret;
 
-- 
2.1.4

