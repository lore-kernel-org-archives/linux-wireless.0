Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:42759 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756428Ab0ESBb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:31:57 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-087562716
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:31:56 +0900 (JST)
Subject: [PATCH v2 01/20] ath5k: add debugfs file for queue debugging
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:30:44 +0900
Message-ID: <20100519013044.22206.90019.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
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
index 6fb5c5f..c77a6ad 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -729,6 +729,66 @@ static const struct file_operations fops_ani = {
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
@@ -772,6 +832,11 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
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
@@ -790,6 +855,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_antenna);
 	debugfs_remove(sc->debug.debugfs_frameerrors);
 	debugfs_remove(sc->debug.debugfs_ani);
+	debugfs_remove(sc->debug.debugfs_queue);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index ddd5b3a..c7a0769 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -77,6 +77,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_antenna;
 	struct dentry		*debugfs_frameerrors;
 	struct dentry		*debugfs_ani;
+	struct dentry		*debugfs_queue;
 };
 
 /**

