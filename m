Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15698 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab2AJEUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 23:20:31 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20235.48490.12923.962906@gargle.gargle.HOWL> (sfid-20120110_052036_304303_39815764)
Date: Tue, 10 Jan 2012 09:54:10 +0530
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath6kl: Fix listen interval handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses a few problems with the commit:

"ath6kl: Implement support for listen interval from userspace"

* The debugfs file required for reading/writing the listen interval
  wasn't created. Fix this.

* The interface index was being hardcoded to zero. Fix this.

* Two separate parameters, "listen_interval_time and listen_interval_beacons"
  were being used. This fails to work as expected because the FW assigns
  higher precedence to "listen_interval_beacons" and "listen_interval_time"
  ends up being never used at all.

  To handle this, fix the host driver to exclusively use listen interval
  based on units of beacon intervals.

To set the listen interval, a user would now do something like this:

echo "10" > /sys/kernel/debug/ieee80211/*/ath6kl/listen_interval

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +-
 drivers/net/wireless/ath/ath6kl/debug.c    |   45 +++++++++++----------------
 drivers/net/wireless/ath/ath6kl/main.c     |    7 ++--
 4 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index cfe9cd5..1c6c867 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2725,8 +2725,7 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	clear_bit(SKIP_SCAN, &ar->flag);
 	clear_bit(DESTROY_IN_PROGRESS, &ar->flag);
 
-	ar->listen_intvl_t = A_DEFAULT_LISTEN_INTERVAL;
-	ar->listen_intvl_b = 0;
+	ar->listen_intvl_b = A_DEFAULT_LISTEN_INTERVAL;
 	ar->tx_pwr = 0;
 
 	ar->intra_bss = 1;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c095faf..dadda0b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -55,7 +55,7 @@
 #define MAX_DEFAULT_SEND_QUEUE_DEPTH      (MAX_DEF_COOKIE_NUM / WMM_NUM_AC)
 
 #define DISCON_TIMER_INTVAL               10000  /* in msec */
-#define A_DEFAULT_LISTEN_INTERVAL         100
+#define A_DEFAULT_LISTEN_INTERVAL         1      /* Number of beacon intervals */
 #define A_MAX_WOW_LISTEN_INTERVAL         1000
 
 /* includes also the null byte */
@@ -525,7 +525,6 @@ struct ath6kl {
 	spinlock_t lock;
 	struct semaphore sem;
 	u16 listen_intvl_b;
-	u16 listen_intvl_t;
 	u8 lrssi_roam_threshold;
 	struct ath6kl_version version;
 	u32 target_type;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index eb808b4..7e97e71 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1505,57 +1505,45 @@ static const struct file_operations fops_bgscan_int = {
 };
 
 static ssize_t ath6kl_listen_int_write(struct file *file,
-						const char __user *user_buf,
-						size_t count, loff_t *ppos)
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
-	u16 listen_int_t, listen_int_b;
+	struct ath6kl_vif *vif;
+	u16 listen_interval;
 	char buf[32];
-	char *sptr, *token;
 	ssize_t len;
 
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 
 	buf[len] = '\0';
-	sptr = buf;
-
-	token = strsep(&sptr, " ");
-	if (!token)
-		return -EINVAL;
-
-	if (kstrtou16(token, 0, &listen_int_t))
-		return -EINVAL;
-
-	if (kstrtou16(sptr, 0, &listen_int_b))
-		return -EINVAL;
-
-	if ((listen_int_t < 15) || (listen_int_t > 5000))
+	if (kstrtou16(buf, 0, &listen_interval))
 		return -EINVAL;
 
-	if ((listen_int_b < 1) || (listen_int_b > 50))
+	if ((listen_interval < 1) || (listen_interval > 50))
 		return -EINVAL;
 
-	ar->listen_intvl_t = listen_int_t;
-	ar->listen_intvl_b = listen_int_b;
-
-	ath6kl_wmi_listeninterval_cmd(ar->wmi, 0, ar->listen_intvl_t,
-				      ar->listen_intvl_b);
+	ar->listen_intvl_b = listen_interval;
+	ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx, 0, ar->listen_intvl_b);
 
 	return count;
 }
 
 static ssize_t ath6kl_listen_int_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos)
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
 	char buf[32];
 	int len;
 
-	len = scnprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
-					ar->listen_intvl_b);
+	len = scnprintf(buf, sizeof(buf), "%u\n", ar->listen_intvl_b);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
@@ -1710,6 +1698,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("bgscan_interval", S_IWUSR,
 				ar->debugfs_phy, ar, &fops_bgscan_int);
 
+	debugfs_create_file("listen_interval", S_IRUSR | S_IWUSR,
+			    ar->debugfs_phy, ar, &fops_listen_int);
+
 	debugfs_create_file("power_params", S_IWUSR, ar->debugfs_phy, ar,
 						&fops_power_params);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f74986d..f0c7d08 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -587,10 +587,11 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
 	vif->bss_ch = channel;
 
-	if ((vif->nw_type == INFRA_NETWORK))
+	if ((vif->nw_type == INFRA_NETWORK)) {
+		ar->listen_intvl_b = listen_int;
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
-					      ar->listen_intvl_t,
-					      ar->listen_intvl_b);
+					      0, ar->listen_intvl_b);
+	}
 
 	netif_wake_queue(vif->ndev);
 
-- 
1.7.8.3

