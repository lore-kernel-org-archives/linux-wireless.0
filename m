Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55564 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbCGIDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:03:35 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: configure thermal throttle while powering up
Date: Sat, 7 Mar 2015 13:32:58 +0530
Message-ID: <1425715380-11200-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150307_090337_778110_11F9C8A1)
In-Reply-To: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
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
 drivers/net/wireless/ath/ath10k/mac.c     |  1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 35 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/thermal.h |  5 +++++
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 561d848..0fef865 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2940,6 +2940,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ath10k_regd_update(ar);
 
 	ath10k_spectral_start(ar);
+	ath10k_thermal_set_throttling(ar);
 
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 246387c..61acdf0 100644
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
@@ -219,6 +207,7 @@ static ssize_t ath10k_thermal_store_quiet_period(struct device *dev,
 	}
 	mutex_lock(&ar->conf_mutex);
 	ar->thermal.quiet_period = period;
+	ath10k_thermal_set_throttling(ar);
 	mutex_unlock(&ar->conf_mutex);
 
 	return count;
@@ -228,6 +217,26 @@ static DEVICE_ATTR(quiet_period, S_IRUGO | S_IWUSR,
 		   ath10k_thermal_show_quiet_period,
 		   ath10k_thermal_store_quiet_period);
 
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
2.3.1

