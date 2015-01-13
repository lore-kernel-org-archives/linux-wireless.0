Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50948 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbAMIwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 03:52:04 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix config_enabled check for hwmon
Date: Tue, 13 Jan 2015 14:21:45 +0530
Message-ID: <1421139105-32025-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150113_095208_104086_9CE86FCB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of wrong macro check in config_enabled, hwmon never be
enabled. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index e915178..edecc6c 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -216,7 +216,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 
 	/* Avoid linking error on devm_hwmon_device_register_with_groups, I
 	 * guess linux/hwmon.h is missing proper stubs. */
-	if (!config_enabled(HWMON))
+	if (!config_enabled(CONFIG_HWMON))
 		return 0;
 
 	hwmon_dev = devm_hwmon_device_register_with_groups(ar->dev,
-- 
2.2.1

