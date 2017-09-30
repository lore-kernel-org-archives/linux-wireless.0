Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38817 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdI3Ria (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 13:38:30 -0400
Received: by mail-pf0-f193.google.com with SMTP id a7so1758513pfj.5
        for <linux-wireless@vger.kernel.org>; Sat, 30 Sep 2017 10:38:30 -0700 (PDT)
From: silexcommon@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 02/11] ath10k_sdio: wb396 reference card fix
Date: Sat, 30 Sep 2017 23:07:39 +0530
Message-Id: <1506793068-27445-3-git-send-email-alagusankar@silex-india.com> (sfid-20170930_193756_816462_56160ECA)
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alagu Sankar <alagusankar@silex-india.com>

The QCA9377-3 WB396 sdio reference card does not get initialized
due to the conflict in uart gpio pins. This fix is not required
for other QCA9377 sdio cards.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b4f66cd..86247c8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1708,8 +1708,15 @@ static int ath10k_init_uart(struct ath10k *ar)
 		return ret;
 	}
 
-	if (!uart_print)
+	if (!uart_print) {
+		/* Hack: override dbg TX pin to avoid side effects of default
+		 * GPIO_6 in QCA9377 WB396 reference card
+		 */
+		if (ar->hif.bus == ATH10K_BUS_SDIO)
+			ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
+					   ar->hw_params.uart_pin);
 		return 0;
+	}
 
 	ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin, ar->hw_params.uart_pin);
 	if (ret) {
-- 
1.9.1
