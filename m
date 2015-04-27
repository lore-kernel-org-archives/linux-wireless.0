Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60321 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbbD0OYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 10:24:46 -0400
Subject: [PATCH] ath10k: add ATH10K_FW_FEATURE_IGNORE_OTP_RESULT
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 27 Apr 2015 17:24:38 +0300
Message-ID: <20150427142438.25600.26537.stgit@potku.adurom.net> (sfid-20150427_162449_951509_49C82CEE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 otp binary seems to always return an error to the host, even if the
calibration succeeded. Add a firmware feature flag to detect if the firmware
image which have this problem and workaround the issue in ath10k by ignoring
the error code.

I was also considering making this hw specific flag but as this is strictly a
firmware issue it's best to handle this via a firmware feature flag so that it
will be easy to disable the workaround.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    4 +++-
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 987b266278a8..bcccae19325d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -387,7 +387,9 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
 
-	if (!skip_otp && result != 0) {
+	if (!(skip_otp || test_bit(ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+				   ar->fw_features))
+	    && result != 0) {
 		ath10k_err(ar, "otp calibration failed: %d", result);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8444adf42195..827b3d79ed0c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -460,6 +460,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
 
+	/* Don't trust error code from otp.bin */
+	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };

