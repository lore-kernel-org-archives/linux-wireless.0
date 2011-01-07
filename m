Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42151 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1AGEtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 23:49:21 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/3] ath9k:  Keep track of stations for debugfs.
Date: Thu,  6 Jan 2011 20:49:12 -0800
Message-Id: <1294375752-3946-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The stations hold the ath_node, which holds the tid
and other xmit logic structures.  In order to debug
stuck xmit logic, we need a way to print out the tid
state for the stations.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v1 -> v2:  Use linked list instead of array.  Protect with spinlock.

:100644 100644 deda815... 3f5c513... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 faf84e4... 650f00f... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 23b2998... 59c01ca... M	drivers/net/wireless/ath/ath9k/init.c
:100644 100644 b716ffb... 8684afa... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    7 ++-
 drivers/net/wireless/ath/ath9k/debug.c |   94 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/init.c  |    4 ++
 drivers/net/wireless/ath/ath9k/main.c  |   13 +++++
 4 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index deda815..3f5c513 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -254,7 +254,10 @@ struct ath_atx_tid {
 };
 
 struct ath_node {
-	struct ath_common *common;
+#ifdef CONFIG_ATH9K_DEBUGFS
+	struct list_head list; /* for sc->nodes */
+	struct ieee80211_sta *sta; /* station struct we're part of */
+#endif
 	struct ath_atx_tid tid[WME_NUM_TID];
 	struct ath_atx_ac ac[WME_NUM_AC];
 	u16 maxampdu;
@@ -624,6 +627,8 @@ struct ath_softc {
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
+	spinlock_t nodes_lock;
+	struct list_head nodes; /* basically, stations */
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index faf84e4..650f00f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -587,6 +587,8 @@ static const struct file_operations fops_wiphy = {
 		sc->debug.stats.txstats[WME_AC_BK].elem, \
 		sc->debug.stats.txstats[WME_AC_VI].elem, \
 		sc->debug.stats.txstats[WME_AC_VO].elem); \
+		if (len >= size)			  \
+			goto done;			  \
 } while(0)
 
 #define PRX(str, elem)							\
@@ -597,6 +599,8 @@ do {									\
 			(unsigned int)(sc->tx.txq[WME_AC_BK].elem),	\
 			(unsigned int)(sc->tx.txq[WME_AC_VI].elem),	\
 			(unsigned int)(sc->tx.txq[WME_AC_VO].elem));	\
+	if (len >= size)						\
+		goto done;						\
 } while(0)
 
 #define PRQLE(str, elem)						\
@@ -607,6 +611,8 @@ do {									\
 			list_empty(&sc->tx.txq[WME_AC_BK].elem),	\
 			list_empty(&sc->tx.txq[WME_AC_VI].elem),	\
 			list_empty(&sc->tx.txq[WME_AC_VO].elem));	\
+	if (len >= size)						\
+		goto done;						\
 } while (0)
 
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
@@ -614,7 +620,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 4000;
+	unsigned int len = 0, size = 8000;
 	int i;
 	ssize_t retval = 0;
 	char tmp[32];
@@ -623,7 +629,10 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += sprintf(buf, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
+	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x\n"
+		       "%30s %10s%10s%10s\n\n",
+		       ATH9K_NUM_TX_QUEUES, sc->tx.txqsetup,
+		       "BE", "BK", "VI", "VO");
 
 	PR("MPDUs Queued:    ", queued);
 	PR("MPDUs Completed: ", completed);
@@ -644,6 +653,14 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("hw-put-tx-buf:   ", puttxbuf);
 	PR("hw-tx-start:     ", txstart);
 	PR("hw-tx-proc-desc: ", txprocdesc);
+	len += snprintf(buf + len, size - len,
+			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
+			&(sc->tx.txq[WME_AC_BE]),
+			&(sc->tx.txq[WME_AC_BK]),
+			&(sc->tx.txq[WME_AC_VI]),
+			&(sc->tx.txq[WME_AC_VO]));
+	if (len >= size)
+		goto done;
 
 	PRX("axq-qnum:        ", axq_qnum);
 	PRX("axq-depth:       ", axq_depth);
@@ -661,6 +678,68 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 		snprintf(tmp, sizeof(tmp) - 1, "txq_fifo[%i] empty: ", i);
 		PRQLE(tmp, txq_fifo[i]);
 	}
+
+done:
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static ssize_t read_file_stations(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 64000;
+	struct ath_node *an = NULL;
+	ssize_t retval = 0;
+	int q;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len,
+			"Stations:\n"
+			" tid: addr sched paused buf_q-empty an ac\n"
+			" ac: addr sched tid_q-empty txq\n");
+
+	spin_lock(&sc->nodes_lock);
+	list_for_each_entry(an, &sc->nodes, list) {
+		len += snprintf(buf + len, size - len,
+				"%pM\n", an->sta->addr);
+		if (len >= size)
+			goto done;
+
+		for (q = 0; q < WME_NUM_TID; q++) {
+			struct ath_atx_tid *tid = &(an->tid[q]);
+			len += snprintf(buf + len, size - len,
+					" tid: %p %s %s %i %p %p\n",
+					tid, tid->sched ? "sched" : "idle",
+					tid->paused ? "paused" : "running",
+					list_empty(&tid->buf_q),
+					tid->an, tid->ac);
+			if (len >= size)
+				goto done;
+		}
+
+		for (q = 0; q < WME_NUM_AC; q++) {
+			struct ath_atx_ac *ac = &(an->ac[q]);
+			len += snprintf(buf + len, size - len,
+					" ac: %p %s %i %p\n",
+					ac, ac->sched ? "sched" : "idle",
+					list_empty(&ac->tid_q), ac->txq);
+			if (len >= size)
+				goto done;
+		}
+	}
+
+done:
+	spin_unlock(&sc->nodes_lock);
 	if (len > size)
 		len = size;
 
@@ -708,6 +787,13 @@ static const struct file_operations fops_xmit = {
 	.llseek = default_llseek,
 };
 
+static const struct file_operations fops_stations = {
+	.read = read_file_stations,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -945,6 +1031,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc, &fops_xmit))
 		goto err;
 
+	if (!debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_stations))
+		goto err;
+
 	if (!debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy,
 			sc, &fops_recv))
 		goto err;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 23b2998..59c01ca 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -559,6 +559,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
+#ifdef CONFIG_ATH9K_DEBUGFS
+	spin_lock_init(&sc->nodes_lock);
+	INIT_LIST_HEAD(&sc->nodes);
+#endif
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
 		     (unsigned long)sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b716ffb..8684afa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -545,6 +545,12 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	struct ath_hw *ah = sc->sc_ah;
 	an = (struct ath_node *)sta->drv_priv;
 
+#ifdef CONFIG_ATH9K_DEBUGFS
+	spin_lock(&sc->nodes_lock);
+	list_add(&an->list, &sc->nodes);
+	spin_unlock(&sc->nodes_lock);
+	an->sta = sta;
+#endif
 	if ((ah->caps.hw_caps) & ATH9K_HW_CAP_APM)
 		sc->sc_flags |= SC_OP_ENABLE_APM;
 
@@ -560,6 +566,13 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
+#ifdef CONFIG_ATH9K_DEBUGFS
+	spin_lock(&sc->nodes_lock);
+	list_del(&an->list);
+	spin_unlock(&sc->nodes_lock);
+	an->sta = NULL;
+#endif
+
 	if (sc->sc_flags & SC_OP_TXAGGR)
 		ath_tx_node_cleanup(sc, an);
 }
-- 
1.7.2.3

