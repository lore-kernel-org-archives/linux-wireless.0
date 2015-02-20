Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40903 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbbBTNFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 08:05:24 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/3] ath10k: fix wrong symlink name on error path
Date: Fri, 20 Feb 2015 18:34:11 +0530
Message-ID: <1424437452-28161-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150220_140537_387905_2E986D22)
In-Reply-To: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrong symlink name is used on error path of thermal registration
and also correcting the error message.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 8992c17..7c54bb1 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -243,7 +243,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 	ret = sysfs_create_link(&ar->dev->kobj, &cdev->device.kobj,
 				"cooling_device");
 	if (ret) {
-		ath10k_err(ar, "failed to create thermal symlink\n");
+		ath10k_err(ar, "failed to create cooling device symlink\n");
 		goto err_cooling_destroy;
 	}
 
@@ -281,7 +281,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 err_remove_file:
 	sysfs_remove_file(&ar->dev->kobj, &dev_attr_quiet_period.attr);
 err_remove_link:
-	sysfs_remove_link(&ar->dev->kobj, "thermal_sensor");
+	sysfs_remove_link(&ar->dev->kobj, "cooling_device");
 err_cooling_destroy:
 	thermal_cooling_device_unregister(cdev);
 	return ret;
-- 
2.3.0

