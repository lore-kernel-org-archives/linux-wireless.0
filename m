Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:64028 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaE2NgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 09:36:14 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so425688wes.10
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 06:36:13 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: fix vdev map size for 10.x firmware
Date: Thu, 29 May 2014 15:36:07 +0200
Message-Id: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140529_153618_372217_A47C5B5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware 10.x supports up to 8 virtual AP interfaces
(comparing to 7 for main firmware). Previous vdev map
initialization was missing enough space for 8 + 1 vdevs
(we may spent one for mac monitor), due to wrong define used.

Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 82017f5..e6c56c5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -795,7 +795,11 @@ int ath10k_core_start(struct ath10k *ar)
 	if (status)
 		goto err_htc_stop;
 
-	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		ar->free_vdev_map = (1 << TARGET_10X_NUM_VDEVS) - 1;
+	else
+		ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+
 	INIT_LIST_HEAD(&ar->arvifs);
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-- 
1.8.2

