Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49812 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaCXTXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 15:23:14 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/4 v2] ath10k:  add otp and firmware boot error messages
Date: Mon, 24 Mar 2014 12:20:42 -0700
Message-Id: <1395688844-24640-3-git-send-email-greearb@candelatech.com> (sfid-20140324_202318_780670_DDF97405)
In-Reply-To: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If OTP or firmware fails to load properly, print out some
extra info in the kernel logs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 79c7d48..da59c8a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -255,7 +255,8 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	/* OTP is optional */
 
 	if (!ar->otp_data || !ar->otp_len) {
-		ath10k_warn("Not running otp, calibration will be incorrect!\n");
+		ath10k_warn("Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
+			    ar->otp_data, ar->otp_len);
 		return 0;
 	}
 
@@ -585,16 +586,22 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
 	int ret;
 
 	ret = ath10k_download_board_data(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to download board data: %d\n", ret);
 		return ret;
+	}
 
 	ret = ath10k_download_and_run_otp(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to run otp: %d\n", ret);
 		return ret;
+	}
 
 	ret = ath10k_download_fw(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to download firmware: %d\n", ret);
 		return ret;
+	}
 
 	return ret;
 }
-- 
1.7.11.7

