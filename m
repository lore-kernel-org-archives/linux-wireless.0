Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40578 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbFPFOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:14:46 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 08/10] ath10k: Fix BMI communication timeout for QCA99X0
Date: Tue, 16 Jun 2015 10:42:20 +0530
Message-ID: <1434431542-14724-9-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150616_071449_198237_2AEDBBAB)
In-Reply-To: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is more than 1 sec delay in getting response from target
through BMI in QCA99X0. Increase the BMI communication timeout
to 2*HZ to fix BMI failures.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 31a9906..df7c761 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -178,7 +178,7 @@ struct bmi_target_info {
 };
 
 /* in msec */
-#define BMI_COMMUNICATION_TIMEOUT_HZ (1*HZ)
+#define BMI_COMMUNICATION_TIMEOUT_HZ (2 * HZ)
 
 #define BMI_CE_NUM_TO_TARG 0
 #define BMI_CE_NUM_TO_HOST 1
-- 
1.9.1

