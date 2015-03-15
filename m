Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbCOPHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 11:07:30 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/6] ath10k: configure thermal throttle while powering up
Date: Sun, 15 Mar 2015 20:36:22 +0530
Message-ID: <1426431985-16332-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150315_160732_693351_4C1A437B)
In-Reply-To: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thermal throttling is not handled in software restart and device
bootup. Also it needs to be configured whenever quiet period got
updated. Fix that.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c   |  1 +
 drivers/net/wireless/ath/ath10k/mac.c     |  1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 34 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/thermal.h |  5 +++++
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 812365c..d684edf 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2008,6 +2008,7 @@ static ssize_t ath10k_write_quiet_period(struct file *file,
 	}
 	mutex_lock(&ar->conf_mutex);
 	ar->thermal.quiet_period = period;
+	ath10k_thermal_set_throttling(ar);
 	mutex_unlock(&ar->conf_mutex);
 
 	return count;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a2302bf..5cb0cb6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3159,6 +3159,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ath10k_regd_update(ar);
 
 	ath10k_spectral_start(ar);
+	ath10k_thermal_set_throttling(ar);
 
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index dc0ebf3..8640f41 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -73,7 +73,6 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 				      unsigned long throttle_state)
 {
 	struct ath10k *ar = cdev->devdata;
-	u32 period, duration, enabled;
 	int num_bss, ret = 0;
 
 	mutex_lock(&ar->conf_mutex);
@@ -99,19 +98,8 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 		ret = -ENETDOWN;
 		goto out;
 	}
-	period = ar->thermal.quiet_period;
-	duration = (period * throttle_state) / 100;
-	enabled = duration ? 1 : 0;
-
-	ret = ath10k_wmi_pdev_set_quiet_mode(ar, period, duration,
-					     ATH10K_QUIET_START_OFFSET,
-					     enabled);
-	if (ret) {
-		ath10k_warn(ar, "failed to set quiet mode period %u duarion %u enabled %u ret %d\n",
-			    period, duration, enabled, ret);
-		goto out;
-	}
 	ar->thermal.throttle_state = throttle_state;
+	ath10k_thermal_set_throttling(ar);
 out:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
@@ -186,6 +174,26 @@ static struct attribute *ath10k_hwmon_attrs[] = {
 };
 ATTRIBUTE_GROUPS(ath10k_hwmon);
 
+void ath10k_thermal_set_throttling(struct ath10k *ar)
+{
+	u32 period, duration, enabled;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	period = ar->thermal.quiet_period;
+	duration = (period * ar->thermal.throttle_state) / 100;
+	enabled = duration ? 1 : 0;
+
+	ret = ath10k_wmi_pdev_set_quiet_mode(ar, period, duration,
+					     ATH10K_QUIET_START_OFFSET,
+					     enabled);
+	if (ret) {
+		ath10k_warn(ar, "failed to set quiet mode period %u duarion %u enabled %u ret %d\n",
+			    period, duration, enabled, ret);
+	}
+}
+
 int ath10k_thermal_register(struct ath10k *ar)
 {
 	struct thermal_cooling_device *cdev;
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index 5728010..b610ea5 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -40,6 +40,7 @@ struct ath10k_thermal {
 int ath10k_thermal_register(struct ath10k *ar);
 void ath10k_thermal_unregister(struct ath10k *ar);
 void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature);
+void ath10k_thermal_set_throttling(struct ath10k *ar);
 #else
 static inline int ath10k_thermal_register(struct ath10k *ar)
 {
@@ -55,5 +56,9 @@ static inline void ath10k_thermal_event_temperature(struct ath10k *ar,
 {
 }
 
+static inline void ath10k_thermal_set_throttling(struct ath10k *ar)
+{
+}
+
 #endif
 #endif /* _THERMAL_ */
-- 
2.3.2

