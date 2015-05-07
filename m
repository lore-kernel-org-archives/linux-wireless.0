Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36017 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbbEGKbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 06:31:24 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v3] ath10k: Bypass PLL setting on target init for QCA9888
Date: Thu, 7 May 2015 16:01:03 +0530
Message-ID: <1430994663-30006-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150507_123132_298917_E0A757E1)
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
index bcccae1..cb34619 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1084,6 +1084,16 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	if (status)
 		goto err;
 
+	if ((ar->hw_rev == ATH10K_HW_QCA988X) &&
+	    (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
+		status = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
+		if (status) {
+			ath10k_err(ar, "could not write skip_clock_init (%d)\n",
+				   status);
+			goto err;
+		}
+	}
+
 	status = ath10k_download_fw(ar, mode);
 	if (status)
 		goto err;
-- 
2.3.7

