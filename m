Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14281 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbbBIFrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 00:47:14 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/2] ath10k: Bypass PLL setting on target init for QCA9888
Date: Mon, 9 Feb 2015 11:16:53 +0530
Message-ID: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150209_064718_780041_BCEF5E4F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of of qca988x solutions are having global reset issue
during target initialization. Bypassing PLL setting before
downloading firmware and letting the SoC run on REF_CLK is fixing
the problem. Corresponding firmware change is also needed to set
the clock source once the target is initialized. Since 10.2.4
firmware is having this ROM patch, applying skip_clock_init only
for 10.2.4 firmware versions.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 310e12b..cd20805 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -797,6 +797,16 @@ static int ath10k_download_cal_data(struct ath10k *ar)
 	ar->cal_mode = ATH10K_CAL_MODE_OTP;
 
 done:
+	if ((ar->hw_rev == ATH10K_HW_QCA988X) &&
+	    (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
+		ret = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
+		if (ret) {
+			ath10k_err(ar, "could not write skip_clock_init (%d)\n",
+				   ret);
+			return ret;
+		}
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using calibration mode %s\n",
 		   ath10k_cal_mode_str(ar->cal_mode));
 	return 0;
-- 
2.2.2

