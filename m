Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab3DYNbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 09:31:34 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] wireless: ath6kl: re-use native helper to parse MAC
Date: Thu, 25 Apr 2013 16:31:22 +0300
Message-Id: <1366896682-2023-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20130425_153137_889165_D2FE1EDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is native mac_pton() function which helps to parse MAC.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index fe38b83..dbfd17d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1240,20 +1240,14 @@ static ssize_t ath6kl_force_roam_write(struct file *file,
 	char buf[20];
 	size_t len;
 	u8 bssid[ETH_ALEN];
-	int i;
-	int addr[ETH_ALEN];
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 	buf[len] = '\0';
 
-	if (sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
-		   &addr[0], &addr[1], &addr[2], &addr[3], &addr[4], &addr[5])
-	    != ETH_ALEN)
+	if (!mac_pton(buf, bssid))
 		return -EINVAL;
-	for (i = 0; i < ETH_ALEN; i++)
-		bssid[i] = addr[i];
 
 	ret = ath6kl_wmi_force_roam_cmd(ar->wmi, bssid);
 	if (ret)
-- 
1.8.2.rc0.22.gb3600c3

