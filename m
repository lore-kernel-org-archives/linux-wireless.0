Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43918 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbeG0KEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:04:16 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: ath6kl: Replace GFP_ATOMIC with GFP_KERNEL in ath6kl_bmi_init()
Date: Fri, 27 Jul 2018 16:43:18 +0800
Message-Id: <20180727084318.3345-1-baijiaju1990@gmail.com> (sfid-20180727_104344_314514_6FC50F28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_bmi_init() is never called in atomic context.
It calls kzalloc() with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 334dbd834b3a..bde5a10d470c 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -534,7 +534,7 @@ int ath6kl_bmi_init(struct ath6kl *ar)
 	/* cmd + addr + len + data_size */
 	ar->bmi.max_cmd_size = ar->bmi.max_data_size + (sizeof(u32) * 3);
 
-	ar->bmi.cmd_buf = kzalloc(ar->bmi.max_cmd_size, GFP_ATOMIC);
+	ar->bmi.cmd_buf = kzalloc(ar->bmi.max_cmd_size, GFP_KERNEL);
 	if (!ar->bmi.cmd_buf)
 		return -ENOMEM;
 
-- 
2.17.0
