Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbaFPQij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:39 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 15/25] wil6210: add 'freq' and 'link' debugfs entries
Date: Mon, 16 Jun 2014 19:37:13 +0300
Message-ID: <1402936643-31819-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190458_478101_3D95EA22)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose operational frequency and link info

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 76 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 850a2f1..4ac2c20 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -104,8 +104,8 @@ int wil_iftype_nl2wmi(enum nl80211_iftype type)
 	return -EOPNOTSUPP;
 }
 
-static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
-			      struct station_info *sinfo)
+int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
+		       struct station_info *sinfo)
 {
 	struct wmi_notify_req_cmd cmd = {
 		.cid = cid,
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 89f0d09..d6acb30 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -773,6 +773,80 @@ static const struct file_operations fops_temp = {
 	.llseek		= seq_lseek,
 };
 
+/*---------freq------------*/
+static int wil_freq_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+	u16 freq = wdev->chandef.chan ? wdev->chandef.chan->center_freq : 0;
+
+	seq_printf(s, "Freq = %d\n", freq);
+
+	return 0;
+}
+
+static int wil_freq_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_freq_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_freq = {
+	.open		= wil_freq_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+/*---------link------------*/
+static int wil_link_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	struct station_info sinfo;
+	int i, rc;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		struct wil_sta_info *p = &wil->sta[i];
+		char *status = "unknown";
+		switch (p->status) {
+		case wil_sta_unused:
+			status = "unused   ";
+			break;
+		case wil_sta_conn_pending:
+			status = "pending  ";
+			break;
+		case wil_sta_connected:
+			status = "connected";
+			break;
+		}
+		seq_printf(s, "[%d] %pM %s%s\n", i, p->addr, status,
+			   (p->data_port_open ? " data_port_open" : ""));
+
+		if (p->status == wil_sta_connected) {
+			rc = wil_cid_fill_sinfo(wil, i, &sinfo);
+			if (rc)
+				return rc;
+
+			seq_printf(s, "  Tx_mcs = %d\n", sinfo.txrate.mcs);
+			seq_printf(s, "  Rx_mcs = %d\n", sinfo.rxrate.mcs);
+			seq_printf(s, "  SQ     = %d\n", sinfo.signal);
+		}
+	}
+
+	return 0;
+}
+
+static int wil_link_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_link_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_link = {
+	.open		= wil_link_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*---------Station matrix------------*/
 static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 {
@@ -880,6 +954,8 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("tx_mgmt", S_IWUSR, dbg, wil, &fops_txmgmt);
 	debugfs_create_file("wmi_send", S_IWUSR, dbg, wil, &fops_wmi);
 	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
+	debugfs_create_file("freq", S_IRUGO, dbg, wil, &fops_freq);
+	debugfs_create_file("link", S_IRUGO, dbg, wil, &fops_link);
 
 	wil->rgf_blob.data = (void * __force)wil->csr + 0;
 	wil->rgf_blob.size = 0xa000;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4cbb8ce..fd6ff09 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -512,6 +512,8 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 int wil6210_debugfs_init(struct wil6210_priv *wil);
 void wil6210_debugfs_remove(struct wil6210_priv *wil);
+int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
+		       struct station_info *sinfo);
 
 struct wireless_dev *wil_cfg80211_init(struct device *dev);
 void wil_wdev_free(struct wil6210_priv *wil);
-- 
1.9.1

