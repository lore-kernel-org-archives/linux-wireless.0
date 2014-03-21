Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43414 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaCUS45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 14:56:57 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath10k:  add otp and firmware boot error messages.
Date: Fri, 21 Mar 2014 11:55:50 -0700
Message-Id: <1395428150-31996-3-git-send-email-greearb@candelatech.com> (sfid-20140321_195700_689022_83BD1E79)
In-Reply-To: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If OTP or firmware fails to load properly, print out some
extra info in the kernel logs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bf5119f..6b61aa7 100644
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
 
@@ -597,12 +598,16 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
 		return ret;
 
 	ret = ath10k_download_and_run_otp(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("boot otp execute result %d\n", ret);
 		return ret;
+	}
 
 	ret = ath10k_download_fw(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("boot download firmware result %d\n", ret);
 		return ret;
+	}
 
 	return ret;
 }
-- 
1.7.11.7

