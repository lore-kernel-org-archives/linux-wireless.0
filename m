Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1L2Kfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 05:35:39 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/3] ath6kl: Add a module parameter to enable uart debug
Date: Thu, 29 Dec 2011 16:05:38 +0530
Message-ID: <1325154939-6986-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111229_113543_107286_3F682DFF)
In-Reply-To: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable firmware debug messages through uart interface,

modprobe ath6kl_sdio uart_debug=1.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 57e0312..fcac538 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -28,10 +28,12 @@
 unsigned int debug_mask;
 static unsigned int testmode;
 static bool suspend_cutpower;
+static unsigned int uart_debug;
 
 module_param(debug_mask, uint, 0644);
 module_param(testmode, uint, 0644);
 module_param(suspend_cutpower, bool, 0444);
+module_param(uart_debug, uint, 0644);
 
 static const struct ath6kl_hw hw_list[] = {
 	{
@@ -464,6 +466,13 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	u8 fw_iftype, fw_mode = 0, fw_submode = 0;
 	int i, status;
 
+	param = uart_debug;
+	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
+			     HI_ITEM(hi_serial_enable)), (u8 *)&param, 4)) {
+		ath6kl_err("bmi_write_memory for uart debug failed\n");
+		return -EIO;
+	}
+
 	/*
 	 * Note: Even though the firmware interface type is
 	 * chosen as BSS_STA for all three interfaces, can
-- 
1.7.0.4

