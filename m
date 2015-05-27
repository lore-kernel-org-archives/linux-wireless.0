Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50810 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbE0OSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 10:18:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v4] ath10k: bypass PLL setting on target init for QCA9888
Date: Wed, 27 May 2015 17:17:33 +0300
Message-ID: <1432736253-30040-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20150527_161816_931914_259D4423)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Some of of qca988x solutions are having global reset issue
during target initialization. Bypassing PLL setting before
downloading firmware and letting the SoC run on REF_CLK is fixing
the problem. Corresponding firmware change is also needed to set
the clock source once the target is initialized. Since 10.2.4
firmware is having this ROM patch, applying skip_clock_init only
for 10.2.4 firmware versions.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
v4:

* add ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT
* add comment to ath10k_core_start()

 drivers/net/wireless/ath/ath10k/core.c |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bcccae19325d..e3249630d9d5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1084,6 +1084,22 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	if (status)
 		goto err;
 
+	/* Some of of qca988x solutions are having global reset issue
+         * during target initialization. Bypassing PLL setting before
+         * downloading firmware and letting the SoC run on REF_CLK is
+         * fixing the problem. Corresponding firmware change is also needed
+         * to set the clock source once the target is initialized.
+	 */
+	if (test_bit(ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT,
+		     ar->fw_features)) {
+		status = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
+		if (status) {
+			ath10k_err(ar, "could not write to skip_clock_init: %d\n",
+				   status);
+			goto err;
+		}
+	}
+
 	status = ath10k_download_fw(ar, mode);
 	if (status)
 		goto err;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 70fcdc9c2758..21a8bf166005 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -468,6 +468,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING,
 
+	/* Firmware supports bypassing PLL setting on init. */ 
+	ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT = 9,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
-- 
1.7.9.5

