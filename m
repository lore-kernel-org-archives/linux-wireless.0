Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15733 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3CSES6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 00:18:58 -0400
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Check wmi ready event status before validating abi version
Date: Tue, 19 Mar 2013 09:48:35 +0530
Message-ID: <1363666715-10854-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20130319_051902_694925_B2D1AA48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point to check firmware ABI version when the driver
fails to wait for WMI_READY event during the boot time.

For such failures, the driver should assume the firmware is not
booted and start doing cleanup.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 072a229..4c54432 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1604,10 +1604,16 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 						    test_bit(WMI_READY,
 							     &ar->flag),
 						    WMI_TIMEOUT);
+	if (timeleft <= 0) {
+		clear_bit(WMI_READY, &ar->flag);
+		ath6kl_err("wmi is not ready or wait was interrupted: %ld\n",
+			   timeleft);
+		ret = -EIO;
+		goto err_htc_stop;
+	}
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "firmware booted\n");
 
-
 	if (test_and_clear_bit(FIRST_BOOT, &ar->flag)) {
 		ath6kl_info("%s %s fw %s api %d%s\n",
 			    ar->hw.name,
@@ -1624,12 +1630,6 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 		goto err_htc_stop;
 	}
 
-	if (!timeleft || signal_pending(current)) {
-		ath6kl_err("wmi is not ready or wait was interrupted\n");
-		ret = -EIO;
-		goto err_htc_stop;
-	}
-
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: wmi is ready\n", __func__);
 
 	/* communicate the wmi protocol verision to the target */
-- 
1.7.1

