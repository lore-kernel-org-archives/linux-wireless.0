Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23573 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZKZPIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:08:43 -0500
Subject: [PATCH 01/12] wl1251: add tx queue status to debugfs
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:08:29 +0200
Message-ID: <20091126150829.917.10297.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Sometimes when debugging the state is good info.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251.h         |    1 +
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 054533f..6301578 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -247,6 +247,7 @@ struct wl1251_debugfs {
 	struct dentry *rxpipe_tx_xfr_host_int_trig_rx_data;
 
 	struct dentry *tx_queue_len;
+	struct dentry *tx_queue_status;
 
 	struct dentry *retry_count;
 	struct dentry *excessive_retries;
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index a007230..0ccba57 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -237,6 +237,27 @@ static const struct file_operations tx_queue_len_ops = {
 	.open = wl1251_open_file_generic,
 };
 
+static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1251 *wl = file->private_data;
+	char buf[3], status;
+	int len;
+
+	if (wl->tx_queue_stopped)
+		status = 's';
+	else
+		status = 'r';
+
+	len = scnprintf(buf, sizeof(buf), "%c\n", status);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+
+static const struct file_operations tx_queue_status_ops = {
+	.read = tx_queue_status_read,
+	.open = wl1251_open_file_generic,
+};
+
 static void wl1251_debugfs_delete_files(struct wl1251 *wl)
 {
 	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
@@ -331,6 +352,7 @@ static void wl1251_debugfs_delete_files(struct wl1251 *wl)
 	DEBUGFS_FWSTATS_DEL(rxpipe, tx_xfr_host_int_trig_rx_data);
 
 	DEBUGFS_DEL(tx_queue_len);
+	DEBUGFS_DEL(tx_queue_status);
 	DEBUGFS_DEL(retry_count);
 	DEBUGFS_DEL(excessive_retries);
 }
@@ -431,6 +453,7 @@ static int wl1251_debugfs_add_files(struct wl1251 *wl)
 	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
 
 	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
+	DEBUGFS_ADD(tx_queue_status, wl->debugfs.rootdir);
 	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
 	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
 

