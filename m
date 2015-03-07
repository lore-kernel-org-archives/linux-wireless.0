Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12101 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbbCGIDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:03:51 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: do not restrict thermal throttling to ap mode
Date: Sat, 7 Mar 2015 13:32:59 +0530
Message-ID: <1425715380-11200-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150307_090416_961932_FC1B3060)
In-Reply-To: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently thermal mitigation is validated in station mode as well.
Hence allowing thermal throttling for all interfaces. This enables
user to validate thermal mitigation with different modes.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 36 +------------------------------
 1 file changed, 1 insertion(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 61acdf0..7aef064 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -23,29 +23,6 @@
 #include "debug.h"
 #include "wmi-ops.h"
 
-static int ath10k_thermal_get_active_vifs(struct ath10k *ar,
-					  enum wmi_vdev_type type)
-{
-	struct ath10k_vif *arvif;
-	int count = 0;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	list_for_each_entry(arvif, &ar->arvifs, list) {
-		if (!arvif->is_started)
-			continue;
-
-		if (!arvif->is_up)
-			continue;
-
-		if (arvif->vdev_type != type)
-			continue;
-
-		count++;
-	}
-	return count;
-}
-
 static int
 ath10k_thermal_get_max_throttle_state(struct thermal_cooling_device *cdev,
 				      unsigned long *state)
@@ -73,7 +50,7 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 				      unsigned long throttle_state)
 {
 	struct ath10k *ar = cdev->devdata;
-	int num_bss, ret = 0;
+	int ret = 0;
 
 	mutex_lock(&ar->conf_mutex);
 	if (ar->state != ATH10K_STATE_ON) {
@@ -87,17 +64,6 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 		ret = -EINVAL;
 		goto out;
 	}
-	/* TODO: Right now, thermal mitigation is handled only for single/multi
-	 * vif AP mode. Since quiet param is not validated in STA mode, it needs
-	 * to be investigated further to handle multi STA and multi-vif (AP+STA)
-	 * mode properly.
-	 */
-	num_bss = ath10k_thermal_get_active_vifs(ar, WMI_VDEV_TYPE_AP);
-	if (!num_bss) {
-		ath10k_warn(ar, "no active AP interfaces\n");
-		ret = -ENETDOWN;
-		goto out;
-	}
 	ar->thermal.throttle_state = throttle_state;
 	ath10k_thermal_set_throttling(ar);
 out:
-- 
2.3.1

