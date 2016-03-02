Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44031 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbcCBOLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 09:11:03 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Remove debugfs support for Per STA total rx duration
Date: Wed, 2 Mar 2016 19:40:33 +0530
Message-ID: <1456927833-32231-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160302_151108_311264_167B54C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

cfg80211/nl80211 interface changes for per STA total rx-duration and
very basic 'ath10k_sta_statistics'  mac80211 callback is implemented
to extend support for per station statistics from the driver.

Also provision in 'iw dev wlan#N station dump' to parse rx-duration
is supported. So its safer to remove the debugfs entry for per STA
rx-duration

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
Dependencies:

1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION
2. iw: Add support for NL80211_STA_INFO_RX_DURATION netlink.
3. ath10k: Add support for ath10k_sta_statistics support

 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 8502cdb..083f259 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -271,28 +271,6 @@ static const struct file_operations fops_delba = {
 	.llseek = default_llseek,
 };
 
-static ssize_t ath10k_dbg_sta_read_rx_duration(struct file *file,
-					       char __user *user_buf,
-					       size_t count, loff_t *ppos)
-{
-	struct ieee80211_sta *sta = file->private_data;
-	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	char buf[100];
-	int len = 0;
-
-	len = scnprintf(buf, sizeof(buf),
-			"%llu usecs\n", arsta->rx_duration);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static const struct file_operations fops_rx_duration = {
-	.read = ath10k_dbg_sta_read_rx_duration,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
@@ -301,6 +279,4 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	debugfs_create_file("addba", S_IWUSR, dir, sta, &fops_addba);
 	debugfs_create_file("addba_resp", S_IWUSR, dir, sta, &fops_addba_resp);
 	debugfs_create_file("delba", S_IWUSR, dir, sta, &fops_delba);
-	debugfs_create_file("rx_duration", S_IRUGO, dir, sta,
-			    &fops_rx_duration);
 }
-- 
1.7.9.5

