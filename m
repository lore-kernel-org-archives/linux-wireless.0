Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:46172 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933452AbeFKSTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 14:19:45 -0400
Received: by mail-pf0-f196.google.com with SMTP id q1-v6so10660459pff.13
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 11:19:45 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: use crash_dump enum instead of magic numbers
Date: Mon, 11 Jun 2018 11:19:35 -0700
Message-Id: <20180611181935.155032-1-briannorris@chromium.org> (sfid-20180611_202000_299652_C0654B46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comments are telling you what the enum could tell you instead.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4cf54a7ef09a..eae46a04f503 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -41,10 +41,8 @@ static bool uart_print;
 static bool skip_otp;
 static bool rawmode;
 
-/* Enable ATH10K_FW_CRASH_DUMP_REGISTERS and ATH10K_FW_CRASH_DUMP_CE_DATA
- * by default.
- */
-unsigned long ath10k_coredump_mask = 0x3;
+unsigned long ath10k_coredump_mask = BIT(ATH10K_FW_CRASH_DUMP_REGISTERS) |
+				     BIT(ATH10K_FW_CRASH_DUMP_CE_DATA);
 
 /* FIXME: most of these should be readonly */
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
-- 
2.18.0.rc1.242.g61856ae69a-goog
