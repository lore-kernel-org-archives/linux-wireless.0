Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32060 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbbJHKdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 06:33:35 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix cleanup in ath10k_thermal_unregister
Date: Thu, 8 Oct 2015 16:03:03 +0530
Message-ID: <1444300383-9645-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20151008_123339_202012_98295150)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

First remove the 'cooling_device#n' syslink created
for ath10k and then unregsiter from the thermal subsystem(cooling)

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 1a899d7..60fe562 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -215,6 +215,6 @@ err_cooling_destroy:
 
 void ath10k_thermal_unregister(struct ath10k *ar)
 {
-	thermal_cooling_device_unregister(ar->thermal.cdev);
 	sysfs_remove_link(&ar->dev->kobj, "cooling_device");
+	thermal_cooling_device_unregister(ar->thermal.cdev);
 }
-- 
1.7.9.5

