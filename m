Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37334 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaLAHaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:30:09 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so23600275wiv.0
        for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2014 23:30:08 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/3] ath10k: move uart pin config into hw_params
Date: Mon,  1 Dec 2014 08:17:46 +0100
Message-Id: <1417418266-21974-3-git-send-email-michal.kazior@tieto.com> (sfid-20141201_083016_253349_94D33649)
In-Reply-To: <1417418266-21974-1-git-send-email-michal.kazior@tieto.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
 <1417418266-21974-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make it possible to easily support
different hardware with different uart pin
configuration.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 ++-
 drivers/net/wireless/ath/ath10k/core.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8bb1657..7c913cc 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -48,6 +48,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA988X_HW_2_0_VERSION,
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
+		.uart_pin = 7,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -698,7 +699,7 @@ static int ath10k_init_uart(struct ath10k *ar)
 	if (!uart_print)
 		return 0;
 
-	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, 7);
+	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, ar->hw_params.uart_pin);
 	if (ret) {
 		ath10k_warn(ar, "could not enable UART prints (%d)\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f1a3edd..0188c84 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -479,6 +479,7 @@ struct ath10k {
 		u32 id;
 		const char *name;
 		u32 patch_load_addr;
+		int uart_pin;
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
-- 
1.8.5.3

