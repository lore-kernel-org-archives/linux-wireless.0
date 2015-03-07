Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33876 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbCGIEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:04:06 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: cache throttle state when device is down
Date: Sat, 7 Mar 2015 13:33:00 +0530
Message-ID: <1425715380-11200-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150307_090417_280748_68AE7BA7)
In-Reply-To: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow driver to cache the throttle state when the devie is not
yet started. Configure the cached throttle state while powering
up the device. Since thermal daemon is unaware of the up/down cycle,
it assumes that device is throttled.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 7aef064..3720c86 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -52,19 +52,19 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	struct ath10k *ar = cdev->devdata;
 	int ret = 0;
 
+	if (throttle_state > ATH10K_THERMAL_THROTTLE_MAX) {
+		ath10k_warn(ar, "throttle state %ld is exceeding the limit %d\n",
+			    throttle_state, ATH10K_THERMAL_THROTTLE_MAX);
+		return -EINVAL;
+	}
 	mutex_lock(&ar->conf_mutex);
+	ar->thermal.throttle_state = throttle_state;
+
 	if (ar->state != ATH10K_STATE_ON) {
 		ret = -ENETDOWN;
 		goto out;
 	}
 
-	if (throttle_state > ATH10K_THERMAL_THROTTLE_MAX) {
-		ath10k_warn(ar, "throttle state %ld is exceeding the limit %d\n",
-			    throttle_state, ATH10K_THERMAL_THROTTLE_MAX);
-		ret = -EINVAL;
-		goto out;
-	}
-	ar->thermal.throttle_state = throttle_state;
 	ath10k_thermal_set_throttling(ar);
 out:
 	mutex_unlock(&ar->conf_mutex);
-- 
2.3.1

