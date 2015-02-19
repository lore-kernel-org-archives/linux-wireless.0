Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49186 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbBSRzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 12:55:44 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: fix quiet duration configuration
Date: Thu, 19 Feb 2015 23:25:06 +0530
Message-ID: <1424368506-18193-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150219_185546_482125_5C540122)
In-Reply-To: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Duty cycle is nothing but percentage of one period in which a
signal is active. But it is wrongly interpreted as ratio of quiet
duration. So fix the quiet duration to the remaining percentage
of duty cycle (active ratio).

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index aede750..0d89ab5 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -98,7 +98,7 @@ static int ath10k_thermal_set_cur_dutycycle(struct thermal_cooling_device *cdev,
 	}
 	period = max(ATH10K_QUIET_PERIOD_MIN,
 		     (ATH10K_QUIET_PERIOD_DEFAULT / num_bss));
-	duration = (period * duty_cycle) / 100;
+	duration = (period * (100 - duty_cycle)) / 100;
 	enabled = duration ? 1 : 0;
 
 	ret = ath10k_wmi_pdev_set_quiet_mode(ar, period, duration,
-- 
2.3.0

