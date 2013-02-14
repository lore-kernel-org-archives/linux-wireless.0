Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3071 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3BNJhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 04:37:36 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 3/6] ath6kl: Return error from ath6kl_bmi_done()
Date: Thu, 14 Feb 2013 15:07:28 +0530
Message-ID: <1360834648-11062-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130214_103740_499442_9C57B243)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

This addresses a FIXME in the driver.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    6 ++----
 drivers/net/wireless/ath/ath6kl/sdio.c |    6 ++++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5d434cf..072a229 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1569,11 +1569,9 @@ static int __ath6kl_init_hw_start(struct ath6kl *ar)
 		goto err_power_off;
 
 	/* Do we need to finish the BMI phase */
-	/* FIXME: return error from ath6kl_bmi_done() */
-	if (ath6kl_bmi_done(ar)) {
-		ret = -EIO;
+	ret = ath6kl_bmi_done(ar);
+	if (ret)
 		goto err_power_off;
-	}
 
 	/*
 	 * The reason we have to wait for the target here is that the
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index d111980..0bd8ff6 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1123,10 +1123,12 @@ static int ath6kl_sdio_bmi_write(struct ath6kl *ar, u8 *buf, u32 len)
 
 	ret = ath6kl_sdio_read_write_sync(ar, addr, buf, len,
 					  HIF_WR_SYNC_BYTE_INC);
-	if (ret)
+	if (ret) {
 		ath6kl_err("unable to send the bmi data to the device\n");
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int ath6kl_sdio_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
-- 
1.7.9.5

