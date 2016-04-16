Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34533 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbcDPAXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 20:23:43 -0400
Received: by mail-qg0-f50.google.com with SMTP id c6so90513539qga.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2016 17:23:42 -0700 (PDT)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH] ath6kl: Add ability to set debug uart baud rate
Date: Fri, 15 Apr 2016 17:19:46 -0700
Message-Id: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20160416_022345_891194_05A8ECC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's useful to permit the customization of the debug uart baud rate. Enable
this and send down the value to the chip if we're enabling debug.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/core.c | 3 +++
 drivers/net/wireless/ath/ath6kl/core.h | 1 +
 drivers/net/wireless/ath/ath6kl/init.c | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 4ec02ce..ebb9f16 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -31,6 +31,7 @@ unsigned int debug_mask;
 static unsigned int suspend_mode;
 static unsigned int wow_mode;
 static unsigned int uart_debug;
+static unsigned int uart_rate = 115200;
 static unsigned int ath6kl_p2p;
 static unsigned int testmode;
 static unsigned int recovery_enable;
@@ -40,6 +41,7 @@ module_param(debug_mask, uint, 0644);
 module_param(suspend_mode, uint, 0644);
 module_param(wow_mode, uint, 0644);
 module_param(uart_debug, uint, 0644);
+module_param(uart_rate, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 module_param(testmode, uint, 0644);
 module_param(recovery_enable, uint, 0644);
@@ -180,6 +182,7 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
+	ar->hw.uarttx_rate = uart_rate;
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 5f3acfe..80ce54d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -781,6 +781,7 @@ struct ath6kl {
 		u32 board_addr;
 		u32 refclk_hz;
 		u32 uarttx_pin;
+		u32 uarttx_rate;
 		u32 testscript_addr;
 		u8 tx_ant;
 		u8 rx_ant;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3daeb27..58fb227 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -651,6 +651,14 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	if (status)
 		return status;
 
+	/* Only set the baud rate if we're actually doing debug */
+	if (ar->conf_flags & ATH6KL_CONF_UART_DEBUG) {
+		status = ath6kl_bmi_write_hi32(ar, hi_desired_baud_rate,
+					       ar->hw.uarttx_rate);
+		if (status)
+			return status;
+	}
+
 	/* Configure target refclk_hz */
 	if (ar->hw.refclk_hz != 0) {
 		status = ath6kl_bmi_write_hi32(ar, hi_refclk_hz,
-- 
1.9.1

