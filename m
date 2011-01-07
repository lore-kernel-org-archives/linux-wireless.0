Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47301 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1AGAqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:46:14 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath9k:  Keep track of stations for debugfs.
Date: Thu,  6 Jan 2011 16:46:05 -0800
Message-Id: <1294361165-15308-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The stations hold the ath_node, which holds the tid
and other xmit logic structures.  In order to debug
stuck xmit logic, we need a way to print out the tid
state for the stations.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 deda815... a34141a... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 faf84e4... 8e29fb9... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 b716ffb... a3e5539... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +
 drivers/net/wireless/ath/ath9k/debug.c |  100 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c  |   20 ++++++-
 3 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index deda815..a34141a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -592,6 +592,10 @@ struct ath_softc {
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
 	struct completion paprd_complete;
+#ifdef CONFIG_ATH9K_DEBUGFS
+#define ATH9K_MAX_STATIONS 1024
+	struct ieee80211_sta *stations[ATH9K_MAX_STATIONS]; /* dbg purposes */
+#endif
 	bool paprd_pending;
 
 	u32 intrstatus;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index faf84e4..8e29fb9 100644
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
@@ -661,6 +678,74 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
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
+	int i;
+	ssize_t retval = 0;
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
+	for (i = 0; i < ATH9K_MAX_STATIONS; i++) {
+		if (sc->stations[i]) {
+			struct ath_node *an;
+			int q;
+			an = (struct ath_node *)(sc->stations[i]->drv_priv);
+
+			len += snprintf(buf + len, size - len,
+					"%pM\n", sc->stations[i]->addr);
+			if (len >= size)
+				goto done;
+
+			for (q = 0; q < WME_NUM_TID; q++) {
+				struct ath_atx_tid *tid = &(an->tid[q]);
+				len += snprintf(buf + len, size - len,
+						" tid: %p %s %s %i %p %p\n",
+						tid,
+						tid->sched ? "sched" : "idle",
+						tid->paused ? "pause" : "     ",
+						list_empty(&tid->buf_q),
+						tid->an, tid->ac);
+				if (len >= size)
+					goto done;
+			}
+
+			for (q = 0; q < WME_NUM_AC; q++) {
+				struct ath_atx_ac *ac = &(an->ac[q]);
+				len += snprintf(buf + len, size - len,
+						" ac: %p %s %i %p\n",
+						ac,
+						ac->sched ? "sched" : "idle",
+						list_empty(&ac->tid_q),
+						ac->txq);
+				if (len >= size)
+					goto done;
+			}
+		}
+	}
+
+done:
 	if (len > size)
 		len = size;
 
@@ -708,6 +793,13 @@ static const struct file_operations fops_xmit = {
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
@@ -945,6 +1037,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc, &fops_xmit))
 		goto err;
 
+	if (!debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_stations))
+		goto err;
+
 	if (!debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy,
 			sc, &fops_recv))
 		goto err;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b716ffb..a3e5539 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1769,7 +1769,15 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-
+#ifdef CONFIG_ATH9K_DEBUGFS
+	int i;
+	for (i = 0; i < ATH9K_MAX_STATIONS; i++) {
+		if (!sc->stations[i]) {
+			sc->stations[i] = sta;
+			break;
+		}
+	}
+#endif
 	ath_node_attach(sc, sta);
 
 	return 0;
@@ -1781,7 +1789,15 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-
+#ifdef CONFIG_ATH9K_DEBUGFS
+	int i;
+	for (i = 0; i < ATH9K_MAX_STATIONS; i++) {
+		if (sc->stations[i] == sta) {
+			sc->stations[i] = NULL;
+			break;
+		}
+	}
+#endif
 	ath_node_detach(sc, sta);
 
 	return 0;
-- 
1.7.2.3

