Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49913 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaFPQiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:12 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 01/25] wil6210: Tx mgmt frame from debugfs
Date: Mon, 16 Jun 2014 19:36:59 +0300
Message-ID: <1402936643-31819-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183817_567278_D793E546)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide 2 files on the debugfs:
- "rxon": write channel (1..4) to open Rx on it, 0 to rxoff
- "tx_mgmt": write binary frame, starting from MAC header

one need to care about turning receiver on/off before/after tx_mgmt

Correct sequence is:
 echo $channel > rxon
 cat mfmt_frame > tx_mgmt
 echo 0 > rxon

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  7 ++-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 80 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  3 ++
 3 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 820d4eb..1725dfc 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -443,10 +443,9 @@ static int wil_cfg80211_disconnect(struct wiphy *wiphy,
 	return rc;
 }
 
-static int wil_cfg80211_mgmt_tx(struct wiphy *wiphy,
-				struct wireless_dev *wdev,
-				struct cfg80211_mgmt_tx_params *params,
-				u64 *cookie)
+int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 struct cfg80211_mgmt_tx_params *params,
+			 u64 *cookie)
 {
 	const u8 *buf = params->buf;
 	size_t len = params->len;
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8d4bc4b..9d5db04 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -397,6 +397,84 @@ static const struct file_operations fops_reset = {
 	.write = wil_write_file_reset,
 	.open  = simple_open,
 };
+/*---write channel 1..4 to rxon for it, 0 to rxoff---*/
+static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
+				   size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	int rc;
+	long channel;
+	bool on;
+
+	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+	if (copy_from_user(kbuf, buf, len))
+		return -EIO;
+
+	kbuf[len] = '\0';
+	rc = kstrtol(kbuf, 0, &channel);
+	kfree(kbuf);
+	if (rc)
+		return rc;
+
+	if ((channel < 0) || (channel > 4)) {
+		wil_err(wil, "Invalid channel %ld\n", channel);
+		return -EINVAL;
+	}
+	on = !!channel;
+
+	if (on) {
+		rc = wmi_set_channel(wil, (int)channel);
+		if (rc)
+			return rc;
+	}
+
+	rc = wmi_rxon(wil, on);
+	if (rc)
+		return rc;
+
+	return len;
+}
+
+static const struct file_operations fops_rxon = {
+	.write = wil_write_file_rxon,
+	.open  = simple_open,
+};
+/*---tx_mgmt---*/
+/* Write mgmt frame to this file to send it */
+static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
+				     size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+	struct cfg80211_mgmt_tx_params params;
+	int rc;
+
+	void *frame = kmalloc(len, GFP_KERNEL);
+	if (!frame)
+		return -ENOMEM;
+
+	if (copy_from_user(frame, buf, len))
+		return -EIO;
+
+	params.buf = frame;
+	params.len = len;
+	params.chan = wdev->preset_chandef.chan;
+
+	rc = wil_cfg80211_mgmt_tx(wiphy, wdev, &params, NULL);
+
+	kfree(frame);
+	wil_info(wil, "%s() -> %d\n", __func__, rc);
+
+	return len;
+}
+
+static const struct file_operations fops_txmgmt = {
+	.write = wil_write_file_txmgmt,
+	.open  = simple_open,
+};
 
 static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
 			    const char *prefix)
@@ -719,6 +797,8 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
 
 	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
+	debugfs_create_file("rxon", S_IWUSR, dbg, wil, &fops_rxon);
+	debugfs_create_file("tx_mgmt", S_IWUSR, dbg, wil, &fops_txmgmt);
 	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
 
 	wil->rgf_blob.data = (void * __force)wil->csr + 0;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e25edc5..793675e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -504,6 +504,9 @@ int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
 void wil6210_disable_irq(struct wil6210_priv *wil);
 void wil6210_enable_irq(struct wil6210_priv *wil);
+int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 struct cfg80211_mgmt_tx_params *params,
+			 u64 *cookie);
 
 int wil6210_debugfs_init(struct wil6210_priv *wil);
 void wil6210_debugfs_remove(struct wil6210_priv *wil);
-- 
1.9.1

