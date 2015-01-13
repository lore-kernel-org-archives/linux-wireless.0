Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57414 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbAMHOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 02:14:44 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: fix hwmon temperature input units
Date: Tue, 13 Jan 2015 12:44:24 +0530
Message-ID: <1421133264-21278-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150113_081447_208542_26F2759D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be compliant with the hwmon interface the unit needs to be
millidegree Celsius. Fix that.

Reported-by: Matthias Kaehlcke <mka@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: added new line for better readability.
 drivers/net/wireless/ath/ath10k/thermal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index b14ae8d..e915178 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -160,7 +160,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 	temperature = ar->thermal.temperature;
 	spin_unlock_bh(&ar->data_lock);
 
-	ret = snprintf(buf, PAGE_SIZE, "%d", temperature);
+	/* display in millidegree celcius */
+	ret = snprintf(buf, PAGE_SIZE, "%d\n", temperature * 1000);
 out:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
2.2.1

