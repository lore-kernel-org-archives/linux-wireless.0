Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29490 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1LMJOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:14:03 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: [PATCH v3 1/1] ath6kl: Support different uart_tx pin and refclk configuration
Date: Tue, 13 Dec 2011 17:11:07 +0800
Message-ID: <1323767467-5952-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20111213_101409_873858_388003F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

    AR6003 family use uart_tx=8 and refclk=26Mhz by default, and AR6004 family
    uses different uart_tx pin and could also support various xtal source,
    moves these per hw configuration.

Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +
 drivers/net/wireless/ath/ath6kl/init.c |   39 ++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8278d87..a11ed9c 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -558,6 +558,8 @@ struct ath6kl {
 		u32 board_ext_data_addr;
 		u32 reserved_ram_size;
 		u32 board_addr;
+		u32 refclk_hz;
+		u32 uarttx_pin;
 
 		const char *fw_otp;
 		const char *fw;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 01fd5a0..f89aa36 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -41,6 +41,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_load_addr			= 0x543180,
 		.board_ext_data_addr		= 0x57e500,
 		.reserved_ram_size		= 6912,
+		.refclk_hz			= 26000000,
+		.uarttx_pin			= 8,
 
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
@@ -60,6 +62,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x542330,
 		.reserved_ram_size		= 512,
+		.refclk_hz			= 26000000,
+		.uarttx_pin			= 8,
 
 		.fw_otp			= AR6003_HW_2_1_1_OTP_FILE,
 		.fw			= AR6003_HW_2_1_1_FIRMWARE_FILE,
@@ -77,6 +81,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 19456,
 		.board_addr			= 0x433900,
+		.refclk_hz			= 26000000,
+		.uarttx_pin			= 11,
 
 		.fw			= AR6004_HW_1_0_FIRMWARE_FILE,
 		.fw_api2		= AR6004_HW_1_0_FIRMWARE_2_FILE,
@@ -91,6 +97,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 11264,
 		.board_addr			= 0x43d400,
+		.refclk_hz			= 40000000,
+		.uarttx_pin			= 11,
 
 		.fw			= AR6004_HW_1_1_FIRMWARE_FILE,
 		.fw_api2		= AR6004_HW_1_1_FIRMWARE_2_FILE,
@@ -124,7 +132,6 @@ static const struct ath6kl_hw hw_list[] = {
  */
 #define WLAN_CONFIG_DISCONNECT_TIMEOUT 10
 
-#define CONFIG_AR600x_DEBUG_UART_TX_PIN 8
 
 #define ATH6KL_DATA_OFFSET    64
 struct sk_buff *ath6kl_buf_alloc(int size)
@@ -444,7 +451,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 {
 	u32 param, ram_reserved_size;
 	u8 fw_iftype, fw_mode = 0, fw_submode = 0;
-	int i;
+	int i, status;
 
 	/*
 	 * Note: Even though the firmware interface type is
@@ -549,6 +556,24 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		/* use default number of control buffers */
 		return -EIO;
 
+	/* Configure GPIO AR600x UART */
+	param = ar->hw.uarttx_pin;
+	status = ath6kl_bmi_write(ar,
+				ath6kl_get_hi_item_addr(ar,
+				HI_ITEM(hi_dbg_uart_txpin)),
+				(u8 *)&param, 4);
+	if (status)
+		return status;
+
+	/* Configure target refclk_hz */
+	param =  ar->hw.refclk_hz;
+	status = ath6kl_bmi_write(ar,
+				ath6kl_get_hi_item_addr(ar,
+				HI_ITEM(hi_refclk_hz)),
+				(u8 *)&param, 4);
+	if (status)
+		return status;
+
 	return 0;
 }
 
@@ -1345,13 +1370,6 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	if (status)
 		return status;
 
-	/* Configure GPIO AR6003 UART */
-	param = CONFIG_AR600x_DEBUG_UART_TX_PIN;
-	status = ath6kl_bmi_write(ar,
-				  ath6kl_get_hi_item_addr(ar,
-				  HI_ITEM(hi_dbg_uart_txpin)),
-				  (u8 *)&param, 4);
-
 	return status;
 }
 
@@ -1383,6 +1401,9 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		   "app_start_override_addr 0x%x board_ext_data_addr 0x%x reserved_ram_size 0x%x",
 		   ar->hw.app_start_override_addr, ar->hw.board_ext_data_addr,
 		   ar->hw.reserved_ram_size);
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
+		   "refclk_hz %d uarttx_pin %d",
+		   ar->hw.refclk_hz, ar->hw.uarttx_pin);
 
 	return 0;
 }
-- 
1.7.0.4

