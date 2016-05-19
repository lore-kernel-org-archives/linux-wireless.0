Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33934 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbcESIgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 04:36:06 -0400
Received: by mail-lf0-f43.google.com with SMTP id m64so31604437lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 01:36:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv5 3/5] mac80211: add debug knobs for fair queuing
Date: Thu, 19 May 2016 10:37:50 +0200
Message-Id: <1463647072-16201-4-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103618_084126_A402511F)
In-Reply-To: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
 <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a debugfs entry to read and modify some
fq parameters and inroduces a module parameter to
control number of flows mac80211 shuold maintain.

This makes it easy to debug, test and experiment.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v5:
     * expose a single "aqm" debugfs knob to maintain
       coherent stat values [Dave]

 net/mac80211/debugfs.c | 173 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c      |   8 ++-
 2 files changed, 180 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b251b2f7f8dd..2906c1004e1a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -10,6 +10,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/rtnetlink.h>
+#include <linux/vmalloc.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "rate.h"
@@ -70,6 +71,177 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
+struct aqm_info {
+	struct ieee80211_local *local;
+	size_t size;
+	size_t len;
+	unsigned char buf[0];
+};
+
+#define AQM_HDR_LEN 200
+#define AQM_HW_ENTRY_LEN 40
+#define AQM_TXQ_ENTRY_LEN 110
+
+static int aqm_open(struct inode *inode, struct file *file)
+{
+	struct ieee80211_local *local = inode->i_private;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	struct txq_info *txqi;
+	struct fq *fq = &local->fq;
+	struct aqm_info *info = NULL;
+	int len = 0;
+	int i;
+
+	if (!local->ops->wake_tx_queue)
+		return -EOPNOTSUPP;
+
+	len += AQM_HDR_LEN;
+	len += 6 * AQM_HW_ENTRY_LEN;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		len += AQM_TXQ_ENTRY_LEN;
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
+		len += AQM_TXQ_ENTRY_LEN * ARRAY_SIZE(sta->sta.txq);
+	rcu_read_unlock();
+
+	info = vmalloc(len);
+	if (!info)
+		return -ENOMEM;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	file->private_data = info;
+	info->local = local;
+	info->size = len;
+	len = 0;
+
+	len += scnprintf(info->buf + len, info->size - len,
+			 "* hw\n"
+			 "access name value\n"
+			 "R fq_flows_cnt %u\n"
+			 "R fq_backlog %u\n"
+			 "R fq_overlimit %u\n"
+			 "R fq_collisions %u\n"
+			 "RW fq_limit %u\n"
+			 "RW fq_quantum %u\n",
+			 fq->flows_cnt,
+			 fq->backlog,
+			 fq->overlimit,
+			 fq->collisions,
+			 fq->limit,
+			 fq->quantum);
+
+	len += scnprintf(info->buf + len,
+			 info->size - len,
+			 "* vif\n"
+			 "ifname addr ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		txqi = to_txq_info(sdata->vif.txq);
+		len += scnprintf(info->buf + len, info->size - len,
+				 "%s %pM %u %u %u %u %u %u %u %u\n",
+				 sdata->name,
+				 sdata->vif.addr,
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
+	len += scnprintf(info->buf + len,
+			 info->size - len,
+			 "* sta\n"
+			 "ifname addr tid ac backlog-bytes backlog-packets flows overlimit collisions tx-bytes tx-packets\n");
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		sdata = sta->sdata;
+		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+			txqi = to_txq_info(sta->sta.txq[i]);
+			len += scnprintf(info->buf + len, info->size - len,
+					 "%s %pM %d %d %u %u %u %u %u %u %u\n",
+					 sdata->name,
+					 sta->sta.addr,
+					 txqi->txq.tid,
+					 txqi->txq.ac,
+					 txqi->tin.backlog_bytes,
+					 txqi->tin.backlog_packets,
+					 txqi->tin.flows,
+					 txqi->tin.overlimit,
+					 txqi->tin.collisions,
+					 txqi->tin.tx_bytes,
+					 txqi->tin.tx_packets);
+		}
+	}
+
+	info->len = len;
+
+	rcu_read_unlock();
+	spin_unlock_bh(&local->fq.lock);
+
+	return 0;
+}
+
+static int aqm_release(struct inode *inode, struct file *file)
+{
+	vfree(file->private_data);
+	return 0;
+}
+
+static ssize_t aqm_read(struct file *file,
+			char __user *user_buf,
+			size_t count,
+			loff_t *ppos)
+{
+	struct aqm_info *info = file->private_data;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       info->buf, info->len);
+}
+
+static ssize_t aqm_write(struct file *file,
+			 const char __user *user_buf,
+			 size_t count,
+			 loff_t *ppos)
+{
+	struct aqm_info *info = file->private_data;
+	struct ieee80211_local *local = info->local;
+	char buf[100];
+	size_t len;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, user_buf, count))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] = '\0';
+	len = strlen(buf);
+	if (len > 0 && buf[len-1] == '\n')
+		buf[len-1] = 0;
+
+	if (sscanf(buf, "fq_limit %u", &local->fq.limit) == 1)
+		return count;
+	else if (sscanf(buf, "fq_quantum %u", &local->fq.quantum) == 1)
+		return count;
+
+	return -EINVAL;
+}
+
+static const struct file_operations aqm_ops = {
+	.write = aqm_write,
+	.read = aqm_read,
+	.open = aqm_open,
+	.release = aqm_release,
+	.llseek = default_llseek,
+};
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -256,6 +428,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD_MODE(aqm, 0600);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d8343fca6d4..2b60b10e6990 100644
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
@@ -1346,7 +1352,7 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	if (!local->ops->wake_tx_queue)
 		return 0;
 
-	ret = fq_init(fq, 4096);
+	ret = fq_init(fq, max_t(u32, fq_flows_cnt, 1));
 	if (ret)
 		return ret;
 
-- 
2.1.4

