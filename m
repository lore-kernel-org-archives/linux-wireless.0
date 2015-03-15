Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2355 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbCOPHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 11:07:02 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/6] ath10k: add debugfs entry to configure quiet period
Date: Sun, 15 Mar 2015 20:36:20 +0530
Message-ID: <1426431985-16332-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150315_160707_864216_10C4DA76)
In-Reply-To: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to configure quiet period (in milliseconds) via debugfs.
This is useful to experiment different quiet period values along with
different throttle ratio.

echo 100 > /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c   | 46 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/thermal.c |  4 +--
 drivers/net/wireless/ath/ath10k/thermal.h |  1 +
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 301081d..812365c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1991,6 +1991,49 @@ static const struct file_operations fops_pktlog_filter = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_quiet_period(struct file *file,
+					 const char __user *ubuf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 period;
+
+	if (kstrtouint_from_user(ubuf, count, 0, &period))
+		return -EINVAL;
+
+	if (period < ATH10K_QUIET_PERIOD_MIN) {
+		ath10k_warn(ar, "Quiet period %u can not be lesser than 25ms\n",
+			    period);
+		return -EINVAL;
+	}
+	mutex_lock(&ar->conf_mutex);
+	ar->thermal.quiet_period = period;
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static ssize_t ath10k_read_quiet_period(struct file *file, char __user *ubuf,
+					size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			ar->thermal.quiet_period);
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_quiet_period = {
+	.read = ath10k_read_quiet_period,
+	.write = ath10k_write_quiet_period,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2088,6 +2131,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("pktlog_filter", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_pktlog_filter);
 
+	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 747fea7..d3fd2ab 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -96,8 +96,7 @@ static int ath10k_thermal_set_cur_dutycycle(struct thermal_cooling_device *cdev,
 		ret = -ENETDOWN;
 		goto out;
 	}
-	period = max(ATH10K_QUIET_PERIOD_MIN,
-		     (ATH10K_QUIET_PERIOD_DEFAULT / num_bss));
+	period = ar->thermal.quiet_period;
 	duration = (period * duty_cycle) / 100;
 	enabled = duration ? 1 : 0;
 
@@ -207,6 +206,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 	}
 
 	ar->thermal.cdev = cdev;
+	ar->thermal.quiet_period = ATH10K_QUIET_PERIOD_DEFAULT;
 
 	/* Do not register hwmon device when temperature reading is not
 	 * supported by firmware
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index 5e87d9a..050f41d 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -29,6 +29,7 @@ struct ath10k_thermal {
 
 	/* protected by conf_mutex */
 	u32 duty_cycle;
+	u32 quiet_period;
 	/* temperature value in Celcius degree
 	 * protected by data_lock
 	 */
-- 
2.3.2

