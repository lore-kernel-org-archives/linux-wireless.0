Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28428 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXLYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 06:24:22 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix build error when hwmon is off
Date: Wed, 24 Dec 2014 16:54:00 +0530
Message-ID: <1419420240-11208-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141224_122547_336010_64CB4FC7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Place hwmon APIs inside CONFIG_HWMON switch to fix undefined
errors when hwmon is not enabled.

ERROR: "devm_hwmon_device_register_with_groups"
[drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 8 ++++++++
 drivers/net/wireless/ath/ath10k/thermal.h | 7 +++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index d939135..7e982e4 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -121,6 +121,7 @@ static struct thermal_cooling_device_ops ath10k_thermal_ops = {
 	.set_cur_state = ath10k_thermal_set_cur_dutycycle,
 };
 
+#ifdef CONFIG_HWMON
 static ssize_t ath10k_thermal_show_temp(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
@@ -182,11 +183,14 @@ static struct attribute *ath10k_hwmon_attrs[] = {
 	NULL,
 };
 ATTRIBUTE_GROUPS(ath10k_hwmon);
+#endif
 
 int ath10k_thermal_register(struct ath10k *ar)
 {
 	struct thermal_cooling_device *cdev;
+#ifdef CONFIG_HWMON
 	struct device *hwmon_dev;
+#endif
 	int ret;
 
 	cdev = thermal_cooling_device_register("ath10k_thermal", ar,
@@ -207,6 +211,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 
 	ar->thermal.cdev = cdev;
 
+#ifdef CONFIG_HWMON
 	/* Do not register hwmon device when temperature reading is not
 	 * supported by firmware
 	 */
@@ -222,10 +227,13 @@ int ath10k_thermal_register(struct ath10k *ar)
 		ret = -EINVAL;
 		goto err_remove_link;
 	}
+#endif
 	return 0;
 
+#ifdef CONFIG_HWMON
 err_remove_link:
 	sysfs_remove_link(&ar->dev->kobj, "thermal_sensor");
+#endif
 err_cooling_destroy:
 	thermal_cooling_device_unregister(cdev);
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index bccc17a..9607e1a 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -38,7 +38,6 @@ struct ath10k_thermal {
 #ifdef CONFIG_THERMAL
 int ath10k_thermal_register(struct ath10k *ar);
 void ath10k_thermal_unregister(struct ath10k *ar);
-void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature);
 #else
 static inline int ath10k_thermal_register(struct ath10k *ar)
 {
@@ -49,10 +48,14 @@ static inline void ath10k_thermal_unregister(struct ath10k *ar)
 {
 }
 
+#endif /* CONFIG_THERMAL */
+#ifdef CONFIG_HWMON
+void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature);
+#else
 static inline void ath10k_thermal_event_temperature(struct ath10k *ar,
 						    int temperature)
 {
 }
 
-#endif
+#endif /* CONFIG_HWMON */
 #endif /* _THERMAL_ */
-- 
2.2.1

