Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38867 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaKXO3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:29:41 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so12502680wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:29:40 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: move uart pin config into hw_params
Date: Mon, 24 Nov 2014 15:17:26 +0100
Message-Id: <1416838646-18801-3-git-send-email-michal.kazior@tieto.com> (sfid-20141124_152946_976931_F7B20934)
In-Reply-To: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
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
index 204aa04..0bce152 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -58,6 +58,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.supported_chips = qca988x_supported_chips,
 		.num_supported_chips = ARRAY_SIZE(qca988x_supported_chips),
+		.uart_pin = 7,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -708,7 +709,7 @@ static int ath10k_init_uart(struct ath10k *ar)
 	if (!uart_print)
 		return 0;
 
-	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, 7);
+	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, ar->hw_params.uart_pin);
 	if (ret) {
 		ath10k_warn(ar, "could not enable UART prints (%d)\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1cc81e8..f8dd904 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -477,6 +477,7 @@ struct ath10k {
 		u32 patch_load_addr;
 		const u32 *supported_chips;
 		int num_supported_chips;
+		int uart_pin;
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
-- 
1.8.5.3

