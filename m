Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23565 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbbBTNFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 08:05:39 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/3] ath10k: add symlink for hwmon device
Date: Fri, 20 Feb 2015 18:34:12 +0530
Message-ID: <1424437452-28161-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150220_140553_092021_C8E08CF6)
In-Reply-To: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add symbloic link "thermal_sensors" for hwmon devices for better
readability.

/sys/class/ieee80211/phyX/device/thermal_sensors ->
sys/class/ieee80211/phyX/device/hwmon/hwmonY

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 7c54bb1..f601e3e 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -276,6 +276,13 @@ int ath10k_thermal_register(struct ath10k *ar)
 		ret = -EINVAL;
 		goto err_remove_file;
 	}
+	ret = sysfs_create_link(&ar->dev->kobj, &hwmon_dev->kobj,
+				"thermal_sensors");
+	if (ret) {
+		ath10k_err(ar, "failed to create hwmon symlink\n");
+		goto err_remove_file;
+	}
+
 	return 0;
 
 err_remove_file:
@@ -292,4 +299,5 @@ void ath10k_thermal_unregister(struct ath10k *ar)
 	thermal_cooling_device_unregister(ar->thermal.cdev);
 	sysfs_remove_link(&ar->dev->kobj, "cooling_device");
 	sysfs_remove_file(&ar->dev->kobj, &dev_attr_quiet_period.attr);
+	sysfs_remove_link(&ar->dev->kobj, "thermal_sensors");
 }
-- 
2.3.0

