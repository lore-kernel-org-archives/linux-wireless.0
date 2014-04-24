Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42033 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaDXIO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:14:27 -0400
Received: by mail-pa0-f52.google.com with SMTP id kx10so1674776pab.39
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 01:14:26 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
Date: Thu, 24 Apr 2014 16:14:10 +0800
Message-Id: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140424_101440_974856_22E98245)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware 999.999.0.636 does not allow stand alone monitor
mode. This means that bridging the STA mode and put it into
promiscuous mode will also cause the firmware to crash. Avoid
this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e2c01dc..f640328 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -647,10 +647,15 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
 
 static int ath10k_monitor_start(struct ath10k *ar)
 {
-	int ret;
+	int ret = -1;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (ar->fw_version_build == 636) {
+		ath10k_warn("stand alone monitor mode is not supported\n");
+		return ret;
+	}
+
 	if (!ath10k_monitor_is_enabled(ar)) {
 		ath10k_warn("trying to start monitor with no references\n");
 		return 0;
-- 
1.9.2

