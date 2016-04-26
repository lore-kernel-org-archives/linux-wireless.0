Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14993 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbcDZInx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:43:53 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: release pre_cal_file while unloading driver
Date: Tue, 26 Apr 2016 14:13:37 +0530
Message-ID: <1461660217-23046-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160426_104357_447922_8679A39D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Failing to release pre_cal_file caldata on deinit causes memory leak.

Fixes: b131129d9657 ("ath10k: fix calibration init sequence of qca99x0")
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5f846bd4054c..6e37184abab6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -712,6 +712,9 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	if (!IS_ERR(ar->cal_file))
 		release_firmware(ar->cal_file);
 
+	if (!IS_ERR(ar->pre_cal_file))
+		release_firmware(ar->pre_cal_file);
+
 	ath10k_swap_code_seg_release(ar);
 
 	ar->otp = NULL;
@@ -723,6 +726,7 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	ar->firmware_len = 0;
 
 	ar->cal_file = NULL;
+	ar->pre_cal_file = NULL;
 }
 
 static int ath10k_fetch_cal_file(struct ath10k *ar)
-- 
2.8.0

