Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:35397 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753362AbdHXVI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 17:08:57 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: activate user space firmware loading again
Date: Thu, 24 Aug 2017 23:06:41 +0200
Message-Id: <20170824210641.19595-1-hauke@hauke-m.de> (sfid-20170824_230900_911101_69270BC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 9f5bcfe93315 ("ath10k: silence firmware file probing
warnings") the firmware loading was changed from request_firmware() to
request_firmware_direct() to silence some warnings in case it fails.
request_firmware_direct() directly searches in the file system only and
does not send a hotplug event to user space in case it could not find
the firmware directly.
In LEDE we use a user space script to extract the calibration data from
the flash memory which gets triggered by the hotplug event. This way the
firmware gets extracted from some vendor specific partition when the
driver requests this firmware. This mechanism does not work any more
after this change.

Fixes: 9f5bcfe93315 ("ath10k: silence firmware file probing warnings")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 75c5c903c8a6..1ff662d6a703 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -519,7 +519,7 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 		dir = ".";
 
 	snprintf(filename, sizeof(filename), "%s/%s", dir, file);
-	ret = request_firmware_direct(&fw, filename, ar->dev);
+	ret = request_firmware(&fw, filename, ar->dev);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot fw request '%s': %d\n",
 		   filename, ret);
 
-- 
2.11.0
