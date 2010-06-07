Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:40554 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751385Ab0FGEL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:29 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0997623888
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:28 +0900 (JST)
Subject: [PATCH 5/5] ath5k: add debugfs file for queue debugging
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:40 +0900
Message-ID: <20100607041140.18667.66832.stgit@tt-desk>
In-Reply-To: <20100607041012.18667.6859.stgit@tt-desk>
References: <20100607041012.18667.6859.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/debug.c |   66 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    1 
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 41817a2..0f2e37d 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -735,6 +735,66 @@ static const struct file_operations fops_ani = {
 };
 
 
+/* debugfs: queues etc */
+
+static ssize_t read_file_queue(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[700];
+	unsigned int len = 0;
+
+	struct ath5k_txq *txq;
+	struct ath5k_buf *bf, *bf0;
+	int i, n = 0;
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"available txbuffers: %d\n", sc->txbuf_len);
+
+	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
+		txq = &sc->txqs[i];
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"%02d: %ssetup\n", i, txq->setup ? "" : "not ");
+
+		if (!txq->setup)
+			continue;
+
+		list_for_each_entry_safe(bf, bf0, &txq->q, list)
+			n++;
+		len += snprintf(buf+len, sizeof(buf)-len, "  len: %d\n", n);
+	}
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_queue(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+		return -EFAULT;
+
+	if (strncmp(buf, "start", 5) == 0)
+		ieee80211_wake_queues(sc->hw);
+	else if (strncmp(buf, "stop", 4) == 0)
+		ieee80211_stop_queues(sc->hw);
+
+	return count;
+}
+
+
+static const struct file_operations fops_queue = {
+	.read = read_file_queue,
+	.write = write_file_queue,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
 /* init */
 
 void
@@ -778,6 +838,11 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc,
 				&fops_ani);
+
+	sc->debug.debugfs_queue = debugfs_create_file("queue",
+				S_IWUSR | S_IRUSR,
+				sc->debug.debugfs_phydir, sc,
+				&fops_queue);
 }
 
 void
@@ -796,6 +861,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_antenna);
 	debugfs_remove(sc->debug.debugfs_frameerrors);
 	debugfs_remove(sc->debug.debugfs_ani);
+	debugfs_remove(sc->debug.debugfs_queue);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index bd16587..606ae94 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -77,6 +77,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_antenna;
 	struct dentry		*debugfs_frameerrors;
 	struct dentry		*debugfs_ani;
+	struct dentry		*debugfs_queue;
 };
 
 /**

