Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28554 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaLSG4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 01:56:48 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 6/8] ath10k: add support to send addba request
Date: Fri, 19 Dec 2014 12:24:57 +0530
Message-ID: <1418972099-5296-7-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141219_075651_161070_A57000A8)
In-Reply-To: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This per-station debugfs entry helps to send addba request in manual
mode. Need to pass two configuration parameters (tid, buffer size)
as input.

To send addba,

echo 1 32 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
	   stations/XX:XX:XX:XX:XX:XX/addba

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 56 +++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index d5fca70..89e5e5a 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -81,9 +81,65 @@ static const struct file_operations fops_aggr_mode = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_dbg_sta_write_addba(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	u32 tid, buf_size;
+	int ret;
+	char buf[64];
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = '\0';
+
+	ret = sscanf(buf, "%u %u", &tid, &buf_size);
+	if (ret != 2) {
+		ath10k_warn(ar, "ex: echo <tid> <buffer size> >addba\n");
+		return -EINVAL;
+	}
+
+	/* Valid TID values are 0 through 15 */
+	if (tid > HTT_DATA_TX_EXT_TID_MGMT - 2) {
+		ath10k_warn(ar, "Invalid TID %u\n", tid);
+		return -EINVAL;
+	}
+
+	mutex_lock(&ar->conf_mutex);
+	if ((ar->state != ATH10K_STATE_ON) ||
+	    (arsta->aggr_mode != ATH10K_DBG_AGGR_MODE_MANUAL)) {
+		ret = count;
+		goto out;
+	}
+
+	ret = ath10k_wmi_addba_send(ar, arsta->arvif->vdev_id, sta->addr,
+				    tid, buf_size);
+	if (ret) {
+		ath10k_warn(ar, "failed to send addba request: vdev_id %u peer %pM tid %u buf_size %u\n",
+			    arsta->arvif->vdev_id, sta->addr, tid, buf_size);
+	}
+
+	ret = count;
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_addba = {
+	.write = ath10k_dbg_sta_write_addba,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
 	debugfs_create_file("aggr_mode", S_IRUGO | S_IWUSR, dir, sta,
 			    &fops_aggr_mode);
+	debugfs_create_file("addba", S_IWUSR, dir, sta, &fops_addba);
 }
-- 
2.2.0

