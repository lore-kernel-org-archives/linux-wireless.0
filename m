Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:59488
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752265Ab2K1Jj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:39:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Implement sta_add_debugfs/sta_remove_debugfs
Date: Wed, 28 Nov 2012 15:08:54 +0530
Message-Id: <1354095535-3564-3-git-send-email-sujith@msujith.org> (sfid-20121128_103939_015408_87785543)
In-Reply-To: <1354095535-3564-1-git-send-email-sujith@msujith.org>
References: <1354095535-3564-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  5 ++
 drivers/net/wireless/ath/ath9k/debug.c | 90 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |  9 +++-
 drivers/net/wireless/ath/ath9k/main.c  | 10 +++-
 4 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 60bf784..86e26a1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -259,6 +259,7 @@ struct ath_atx_tid {
 };
 
 struct ath_node {
+	struct ath_softc *sc;
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
 	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
@@ -269,6 +270,10 @@ struct ath_node {
 	u8 mpdudensity;
 
 	bool sleeping;
+
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
+	struct dentry *node_stat;
+#endif
 };
 
 #define AGGR_CLEANUP         BIT(1)
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index cb5e457..13ff9ed 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1509,6 +1509,96 @@ static const struct file_operations fops_btcoex = {
 };
 #endif
 
+static ssize_t read_file_node_stat(struct file *file, char __user *user_buf,
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
+		len = snprintf(buf, size, "%s\n",
+			       "HT not supported");
+		goto exit;
+	}
+
+	len = snprintf(buf, size, "Max-AMPDU: %d\n",
+		       an->maxampdu);
+	len += snprintf(buf + len, size - len, "MPDU Density: %d\n\n",
+			an->mpdudensity);
+
+	len += snprintf(buf + len, size - len,
+			"%2s%7s\n", "AC", "SCHED");
+
+	for (acno = 0, ac = &an->ac[acno];
+	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
+		txq = ac->txq;
+		ath_txq_lock(sc, txq);
+		len += snprintf(buf + len, size - len,
+				"%2d%7d\n",
+				acno, ac->sched);
+		ath_txq_unlock(sc, txq);
+	}
+
+	len += snprintf(buf + len, size - len,
+			"\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
+			"TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
+			"BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
+
+	for (tidno = 0, tid = &an->tid[tidno];
+	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+		txq = tid->ac->txq;
+		ath_txq_lock(sc, txq);
+		len += snprintf(buf + len, size - len,
+				"%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
+				tid->tidno, tid->seq_start, tid->seq_next,
+				tid->baw_size, tid->baw_head, tid->baw_tail,
+				tid->bar_index, tid->sched, tid->paused);
+		ath_txq_unlock(sc, txq);
+	}
+exit:
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_node_stat = {
+	.read = read_file_node_stat,
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
+	an->node_stat = debugfs_create_file("node_stat", S_IRUGO,
+					    dir, an, &fops_node_stat);
+}
+
+void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct dentry *dir)
+{
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	debugfs_remove(an->node_stat);
+}
+
 /* Ethtool support for get-stats */
 
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index bfc21b3..72d4893 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -315,7 +315,14 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 void ath9k_get_et_strings(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  u32 sset, u8 *data);
-
+void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct dentry *dir);
+void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct dentry *dir);
 #else
 
 #define RX_STAT_INC(c) /* NOP */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ffae384..be30a9a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -331,6 +331,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	u8 density;
 	an = (struct ath_node *)sta->drv_priv;
 
+	an->sc = sc;
 	an->sta = sta;
 	an->vif = vif;
 
@@ -2275,7 +2276,12 @@ struct ieee80211_ops ath9k_ops = {
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 	.get_et_sset_count  = ath9k_get_et_sset_count,
-	.get_et_stats  = ath9k_get_et_stats,
-	.get_et_strings  = ath9k_get_et_strings,
+	.get_et_stats       = ath9k_get_et_stats,
+	.get_et_strings     = ath9k_get_et_strings,
+#endif
+
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
+	.sta_add_debugfs    = ath9k_sta_add_debugfs,
+	.sta_remove_debugfs = ath9k_sta_remove_debugfs,
 #endif
 };
-- 
1.8.0.1

