Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44387 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaLOFN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 00:13:58 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 5/5] ath10k: add thermal sensor device support
Date: Mon, 15 Dec 2014 10:41:14 +0530
Message-ID: <1418620274-3081-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141215_061401_843963_A2918082)
In-Reply-To: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Temperature sensor generates electrical analog voltage from temperature
of each chain. The analog voltage is converted to digital value through
ADC. For reading temperature values fom user space, hw monitoring device
is used.

Whenever the user requests for current temperature, the driver sends WMI
command and wait for response. For reading temperature,

cat /sys/class/ieee80211/phy*/device/hwmon/hwmon2/temp1_input

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c    |  2 +
 drivers/net/wireless/ath/ath10k/thermal.c | 83 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/thermal.h | 14 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  1 +
 4 files changed, 100 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2eb3f2c..ed2abc9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -840,6 +840,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	complete_all(&ar->offchan_tx_completed);
 	complete_all(&ar->install_key_done);
 	complete_all(&ar->vdev_setup_done);
+	complete_all(&ar->thermal.wmi_sync);
 	wake_up(&ar->htt.empty_tx_wq);
 	wake_up(&ar->wmi.tx_credits_wq);
 	wake_up(&ar->peer_mapping_wq);
@@ -1320,6 +1321,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
+	init_completion(&ar->thermal.wmi_sync);
 
 	INIT_DELAYED_WORK(&ar->scan.timeout, ath10k_scan_timeout_work);
 
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index e98ce8c..d939135 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -17,6 +17,8 @@
 #include <linux/device.h>
 #include <linux/sysfs.h>
 #include <linux/thermal.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
 #include "core.h"
 #include "debug.h"
 #include "wmi-ops.h"
@@ -119,9 +121,72 @@ static struct thermal_cooling_device_ops ath10k_thermal_ops = {
 	.set_cur_state = ath10k_thermal_set_cur_dutycycle,
 };
 
+static ssize_t ath10k_thermal_show_temp(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct ath10k *ar = dev_get_drvdata(dev);
+	int ret, temperature;
+
+	mutex_lock(&ar->conf_mutex);
+
+	/* Can't get temperature when the card is off */
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto out;
+	}
+
+	reinit_completion(&ar->thermal.wmi_sync);
+	ret = ath10k_wmi_pdev_get_temperature(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to read temperature %d\n", ret);
+		goto out;
+	}
+
+	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags)) {
+		ret = -ESHUTDOWN;
+		goto out;
+	}
+
+	ret = wait_for_completion_timeout(&ar->thermal.wmi_sync,
+					  ATH10K_THERMAL_SYNC_TIMEOUT_HZ);
+	if (ret == 0) {
+		ath10k_warn(ar, "failed to synchronize thermal read\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	spin_lock_bh(&ar->data_lock);
+	temperature = ar->thermal.temperature;
+	spin_unlock_bh(&ar->data_lock);
+
+	ret = snprintf(buf, PAGE_SIZE, "%d", temperature);
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature)
+{
+	spin_lock_bh(&ar->data_lock);
+	ar->thermal.temperature = temperature;
+	spin_unlock_bh(&ar->data_lock);
+	complete(&ar->thermal.wmi_sync);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, ath10k_thermal_show_temp,
+			  NULL, 0);
+
+static struct attribute *ath10k_hwmon_attrs[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(ath10k_hwmon);
+
 int ath10k_thermal_register(struct ath10k *ar)
 {
 	struct thermal_cooling_device *cdev;
+	struct device *hwmon_dev;
 	int ret;
 
 	cdev = thermal_cooling_device_register("ath10k_thermal", ar,
@@ -141,8 +206,26 @@ int ath10k_thermal_register(struct ath10k *ar)
 	}
 
 	ar->thermal.cdev = cdev;
+
+	/* Do not register hwmon device when temperature reading is not
+	 * supported by firmware
+	 */
+	if (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)
+		return 0;
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(ar->dev,
+							   "ath10k_hwmon", ar,
+							   ath10k_hwmon_groups);
+	if (IS_ERR(hwmon_dev)) {
+		ath10k_err(ar, "failed to register hwmon device: %ld\n",
+			   PTR_ERR(hwmon_dev));
+		ret = -EINVAL;
+		goto err_remove_link;
+	}
 	return 0;
 
+err_remove_link:
+	sysfs_remove_link(&ar->dev->kobj, "thermal_sensor");
 err_cooling_destroy:
 	thermal_cooling_device_unregister(cdev);
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index e20bb87..bccc17a 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -20,17 +20,25 @@
 #define ATH10K_QUIET_PERIOD_MIN         25
 #define ATH10K_QUIET_START_OFFSET       10
 #define ATH10K_QUIET_DUTY_CYCLE_MAX     70
+#define ATH10K_HWMON_NAME_LEN           15
+#define ATH10K_THERMAL_SYNC_TIMEOUT_HZ (5*HZ)
 
 struct ath10k_thermal {
 	struct thermal_cooling_device *cdev;
+	struct completion wmi_sync;
 
 	/* protected by conf_mutex */
 	u32 duty_cycle;
+	/* temperature value in Celcius degree
+	 * protected by data_lock
+	 */
+	int temperature;
 };
 
 #ifdef CONFIG_THERMAL
 int ath10k_thermal_register(struct ath10k *ar);
 void ath10k_thermal_unregister(struct ath10k *ar);
+void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature);
 #else
 static inline int ath10k_thermal_register(struct ath10k *ar)
 {
@@ -40,5 +48,11 @@ static inline int ath10k_thermal_register(struct ath10k *ar)
 static inline void ath10k_thermal_unregister(struct ath10k *ar)
 {
 }
+
+static inline void ath10k_thermal_event_temperature(struct ath10k *ar,
+						    int temperature)
+{
+}
+
 #endif
 #endif /* _THERMAL_ */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c32dc19..f6b0de3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2805,6 +2805,7 @@ static int ath10k_wmi_event_temperature(struct ath10k *ar, struct sk_buff *skb)
 	if (WARN_ON(skb->len < sizeof(*ev)))
 		return -EPROTO;
 
+	ath10k_thermal_event_temperature(ar, __le32_to_cpu(ev->temperature));
 	return 0;
 }
 
-- 
2.1.3

