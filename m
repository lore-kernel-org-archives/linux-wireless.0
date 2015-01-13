Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22368 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbAMFu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 00:50:29 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix hwmon temperature input units
Date: Tue, 13 Jan 2015 11:20:07 +0530
Message-ID: <1421128207-28641-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150113_065033_360224_C03C8950)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be compliant with the hwmon interface the unit needs to be
millidegree Celsius. Fix that.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index b14ae8d..3c4a3d8 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -160,7 +160,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 	temperature = ar->thermal.temperature;
 	spin_unlock_bh(&ar->data_lock);
 
-	ret = snprintf(buf, PAGE_SIZE, "%d", temperature);
+	/* display in millidegree celcius */
+	ret = snprintf(buf, PAGE_SIZE, "%d", temperature * 1000);
 out:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
2.2.1

