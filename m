Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13549 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2EVHWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 03:22:49 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix missing gpio pin 9 configuration
Date: Tue, 22 May 2012 12:52:48 +0530
Message-ID: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120522_092259_608717_5F53215E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GPIO pin 9 also needs to be configured along with other gpio
pins to avoid sdio crc errors. I've not experienced any issue
with missing this particular gpio pin configuration, found dunring
code review. This can potentially improve rx performance.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c   |    6 ++++++
 drivers/net/wireless/ath/ath6kl/target.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 10de132..241febc 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1392,6 +1392,12 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	    ar->version.target_ver == AR6003_HW_2_1_1_VERSION) {
 		ath6kl_err("temporary war to avoid sdio crc error\n");
 
+		param = 0x28;
+		address = GPIO_BASE_ADDRESS + GPIO_PIN9_ADDRESS;
+		status = ath6kl_bmi_reg_write(ar, address, param);
+		if (status)
+			return status;
+
 		param = 0x20;
 
 		address = GPIO_BASE_ADDRESS + GPIO_PIN10_ADDRESS;
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 78e0ef4..a98c12b 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -45,6 +45,7 @@
 #define LPO_CAL_ENABLE_S		20
 #define LPO_CAL_ENABLE			0x00100000
 
+#define GPIO_PIN9_ADDRESS		0x0000004c
 #define GPIO_PIN10_ADDRESS		0x00000050
 #define GPIO_PIN11_ADDRESS		0x00000054
 #define GPIO_PIN12_ADDRESS		0x00000058
-- 
1.7.0.4

