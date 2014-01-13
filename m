Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59684 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAMCEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/5] ath9k: Add an option for station statistics
Date: Mon, 13 Jan 2014 07:29:27 +0530
Message-Id: <1389578371-23943-1-git-send-email-sujith@msujith.org> (sfid-20140113_030454_475562_0EEBD6AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Also, rename node_stat to node_aggr.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig     |  8 +++
 drivers/net/wireless/ath/ath9k/Makefile    |  2 +
 drivers/net/wireless/ath/ath9k/debug.c     | 80 ------------------------
 drivers/net/wireless/ath/ath9k/debug_sta.c | 97 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c      |  2 +-
 5 files changed, 108 insertions(+), 81 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/debug_sta.c

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 30d273c..7b96b3e 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -65,6 +65,14 @@ config ATH9K_DEBUGFS
 
 	  Also required for changing debug message flags at run time.
 
+config ATH9K_STATION_STATISTICS
+	bool "Detailed station statistics"
+	depends on ATH9K && ATH9K_DEBUGFS && DEBUG_FS
+	select MAC80211_DEBUGFS
+	default n
+	---help---
+	  This option enables detailed statistics for association stations.
+
 config ATH9K_DFS_CERTIFIED
 	bool "Atheros DFS support for certified platforms"
 	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index e9904e5..a40e5c5 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -19,6 +19,8 @@ ath9k-$(CONFIG_ATH9K_WOW) += wow.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o \
 				 spectral.o
 
+ath9k-$(CONFIG_ATH9K_STATION_STATISTICS) += debug_sta.o
+
 obj-$(CONFIG_ATH9K) += ath9k.o
 
 ath9k_hw-y:=	\
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index b041052..5bdc938 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1322,86 +1322,6 @@ static const struct file_operations fops_btcoex = {
 };
 #endif
 
-static ssize_t read_file_node_stat(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos)
-{
-	struct ath_node *an = file->private_data;
-	struct ath_softc *sc = an->sc;
-	struct ath_atx_tid *tid;
-	struct ath_atx_ac *ac;
-	struct ath_txq *txq;
-	u32 len = 0, size = 4096;
-	char *buf;
-	size_t retval;
-	int tidno, acno;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	if (!an->sta->ht_cap.ht_supported) {
-		len = scnprintf(buf, size, "%s\n",
-				"HT not supported");
-		goto exit;
-	}
-
-	len = scnprintf(buf, size, "Max-AMPDU: %d\n",
-			an->maxampdu);
-	len += scnprintf(buf + len, size - len, "MPDU Density: %d\n\n",
-			 an->mpdudensity);
-
-	len += scnprintf(buf + len, size - len,
-			 "%2s%7s\n", "AC", "SCHED");
-
-	for (acno = 0, ac = &an->ac[acno];
-	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
-		txq = ac->txq;
-		ath_txq_lock(sc, txq);
-		len += scnprintf(buf + len, size - len,
-				 "%2d%7d\n",
-				 acno, ac->sched);
-		ath_txq_unlock(sc, txq);
-	}
-
-	len += scnprintf(buf + len, size - len,
-			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
-			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
-			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
-
-	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
-		txq = tid->ac->txq;
-		ath_txq_lock(sc, txq);
-		len += scnprintf(buf + len, size - len,
-				 "%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
-				 tid->tidno, tid->seq_start, tid->seq_next,
-				 tid->baw_size, tid->baw_head, tid->baw_tail,
-				 tid->bar_index, tid->sched, tid->paused);
-		ath_txq_unlock(sc, txq);
-	}
-exit:
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static const struct file_operations fops_node_stat = {
-	.read = read_file_node_stat,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
-			   struct ieee80211_vif *vif,
-			   struct ieee80211_sta *sta,
-			   struct dentry *dir)
-{
-	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-	debugfs_create_file("node_stat", S_IRUGO, dir, an, &fops_node_stat);
-}
-
 /* Ethtool support for get-stats */
 
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
new file mode 100644
index 0000000..3fe2bab2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -0,0 +1,97 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath_node *an = file->private_data;
+	struct ath_softc *sc = an->sc;
+	struct ath_atx_tid *tid;
+	struct ath_atx_ac *ac;
+	struct ath_txq *txq;
+	u32 len = 0, size = 4096;
+	char *buf;
+	size_t retval;
+	int tidno, acno;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (!an->sta->ht_cap.ht_supported) {
+		len = scnprintf(buf, size, "%s\n",
+				"HT not supported");
+		goto exit;
+	}
+
+	len = scnprintf(buf, size, "Max-AMPDU: %d\n",
+			an->maxampdu);
+	len += scnprintf(buf + len, size - len, "MPDU Density: %d\n\n",
+			 an->mpdudensity);
+
+	len += scnprintf(buf + len, size - len,
+			 "%2s%7s\n", "AC", "SCHED");
+
+	for (acno = 0, ac = &an->ac[acno];
+	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
+		txq = ac->txq;
+		ath_txq_lock(sc, txq);
+		len += scnprintf(buf + len, size - len,
+				 "%2d%7d\n",
+				 acno, ac->sched);
+		ath_txq_unlock(sc, txq);
+	}
+
+	len += scnprintf(buf + len, size - len,
+			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
+			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
+			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
+
+	for (tidno = 0, tid = &an->tid[tidno];
+	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+		txq = tid->ac->txq;
+		ath_txq_lock(sc, txq);
+		len += scnprintf(buf + len, size - len,
+				 "%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
+				 tid->tidno, tid->seq_start, tid->seq_next,
+				 tid->baw_size, tid->baw_head, tid->baw_tail,
+				 tid->bar_index, tid->sched, tid->paused);
+		ath_txq_unlock(sc, txq);
+	}
+exit:
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_node_aggr = {
+	.read = read_file_node_aggr,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct dentry *dir)
+{
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d0c3aec..07fcf16 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2111,7 +2111,7 @@ struct ieee80211_ops ath9k_ops = {
 	.get_et_strings     = ath9k_get_et_strings,
 #endif
 
-#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_STATION_STATISTICS)
 	.sta_add_debugfs    = ath9k_sta_add_debugfs,
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
-- 
1.8.5.2

