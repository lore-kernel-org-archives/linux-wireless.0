Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbBSRz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 12:55:27 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: increase duty cycle maximum limit
Date: Thu, 19 Feb 2015 23:25:05 +0530
Message-ID: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150219_185530_417077_F34900F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow user to configure the duty cycle upto 100%. Since thermal
mitigation algorithm is running in user space, remove the driver
level limitation and let the user to control the temperature.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index bccc17a..5e87d9a 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -19,7 +19,7 @@
 #define ATH10K_QUIET_PERIOD_DEFAULT     100
 #define ATH10K_QUIET_PERIOD_MIN         25
 #define ATH10K_QUIET_START_OFFSET       10
-#define ATH10K_QUIET_DUTY_CYCLE_MAX     70
+#define ATH10K_QUIET_DUTY_CYCLE_MAX     100
 #define ATH10K_HWMON_NAME_LEN           15
 #define ATH10K_THERMAL_SYNC_TIMEOUT_HZ (5*HZ)
 
-- 
2.3.0

