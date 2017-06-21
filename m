Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33543 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751056AbdFUJZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 05:25:30 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kvalo@qca.qualcomm.com,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] ath10k: add const to thermal_cooling_device_ops structure
Date: Wed, 21 Jun 2017 14:53:30 +0530
Message-Id: <1498037010-21024-1-git-send-email-bhumirks@gmail.com> (sfid-20170621_112601_100129_F978EDAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare thermal_cooling_device_ops structure as const as it is only passed
as an argument to the function thermal_cooling_device_register and this
argument is of type const. So, declare the structure as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 87948af..ef717b6 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -63,7 +63,7 @@ ath10k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	return 0;
 }
 
-static struct thermal_cooling_device_ops ath10k_thermal_ops = {
+static const struct thermal_cooling_device_ops ath10k_thermal_ops = {
 	.get_max_state = ath10k_thermal_get_max_throttle_state,
 	.get_cur_state = ath10k_thermal_get_cur_throttle_state,
 	.set_cur_state = ath10k_thermal_set_cur_throttle_state,
-- 
2.7.4
