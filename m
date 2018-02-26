Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:21756 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751022AbeBZSNC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 13:13:02 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 8/8] wil6210: add debugfs 'mids' file
Date: Mon, 26 Feb 2018 20:12:18 +0200
Message-Id: <1519668738-16912-9-git-send-email-merez@codeaurora.org> (sfid-20180226_191306_690089_34505B1C)
In-Reply-To: <1519668738-16912-1-git-send-email-merez@codeaurora.org>
References: <1519668738-16912-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

Added a new debugfs file 'mids' to print the list of
virtual interfaces by MAC ID (MID). Allows mapping
between the internal MID used by FW and the actual
network interface used by the VIF. This is needed by
debugging tools.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 37 ++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 93a99a1..8c90b31 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1495,6 +1495,42 @@ static int wil_sta_seq_open(struct inode *inode, struct file *file)
 	.llseek		= seq_lseek,
 };
 
+static int wil_mids_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	struct wil6210_vif *vif;
+	struct net_device *ndev;
+	int i;
+
+	mutex_lock(&wil->vif_mutex);
+	for (i = 0; i < wil->max_vifs; i++) {
+		vif = wil->vifs[i];
+
+		if (vif) {
+			ndev = vif_to_ndev(vif);
+			seq_printf(s, "[%d] %pM %s\n", i, ndev->dev_addr,
+				   ndev->name);
+		} else {
+			seq_printf(s, "[%d] unused\n", i);
+		}
+	}
+	mutex_unlock(&wil->vif_mutex);
+
+	return 0;
+}
+
+static int wil_mids_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_mids_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_mids = {
+	.open		= wil_mids_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 static ssize_t wil_read_file_led_cfg(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
@@ -1749,6 +1785,7 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 	{"mbox",	0444,		&fops_mbox},
 	{"vrings",	0444,		&fops_vring},
 	{"stations", 0444,		&fops_sta},
+	{"mids",	0444,		&fops_mids},
 	{"desc",	0444,		&fops_txdesc},
 	{"bf",		0444,		&fops_bf},
 	{"mem_val",	0644,		&fops_memread},
-- 
1.9.1
