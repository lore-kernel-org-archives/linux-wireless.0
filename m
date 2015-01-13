Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54228 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMJWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 04:22:36 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix duration calculation for quiet param
Date: Tue, 13 Jan 2015 14:52:14 +0530
Message-ID: <1421140934-16109-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150113_102241_630520_AC4E4E79)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The duty cycle (% of quiet duration) is used to put the device
in quiet mode for the given period. Currently the quiet duration
is wrongly calculated which results in not enabling quiet mode.
Fix the calculation as below

     duration = (period * duty cycle) / 100

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index edecc6c..aede750 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -98,7 +98,7 @@ static int ath10k_thermal_set_cur_dutycycle(struct thermal_cooling_device *cdev,
 	}
 	period = max(ATH10K_QUIET_PERIOD_MIN,
 		     (ATH10K_QUIET_PERIOD_DEFAULT / num_bss));
-	duration = period * (duty_cycle / 100);
+	duration = (period * duty_cycle) / 100;
 	enabled = duration ? 1 : 0;
 
 	ret = ath10k_wmi_pdev_set_quiet_mode(ar, period, duration,
-- 
2.2.1

