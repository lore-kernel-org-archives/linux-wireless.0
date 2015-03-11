Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23515 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbCKSFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 14:05:16 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: move driver state check before setting throttle
Date: Wed, 11 Mar 2015 23:34:54 +0530
Message-ID: <1426097094-6225-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150311_190522_115035_58267DD3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since thermal daemon is unaware of the device state, it might
try to adjust the throttle state when the device is powered down.
So the driver caches the value and will configure it while
powering up the target. The cached value will be programed later
once the device is brought up. In such case, returning error
status is confusing and misleading the user application. Hence
moving the driver state check before sending wmi command to target.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 3720c86..c9475ac 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -50,7 +50,6 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 				      unsigned long throttle_state)
 {
 	struct ath10k *ar = cdev->devdata;
-	int ret = 0;
 
 	if (throttle_state > ATH10K_THERMAL_THROTTLE_MAX) {
 		ath10k_warn(ar, "throttle state %ld is exceeding the limit %d\n",
@@ -59,16 +58,9 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	}
 	mutex_lock(&ar->conf_mutex);
 	ar->thermal.throttle_state = throttle_state;
-
-	if (ar->state != ATH10K_STATE_ON) {
-		ret = -ENETDOWN;
-		goto out;
-	}
-
 	ath10k_thermal_set_throttling(ar);
-out:
 	mutex_unlock(&ar->conf_mutex);
-	return ret;
+	return 0;
 }
 
 static struct thermal_cooling_device_ops ath10k_thermal_ops = {
@@ -190,6 +182,9 @@ void ath10k_thermal_set_throttling(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (ar->state != ATH10K_STATE_ON)
+		return;
+
 	period = ar->thermal.quiet_period;
 	duration = (period * ar->thermal.throttle_state) / 100;
 	enabled = duration ? 1 : 0;
-- 
2.3.2

