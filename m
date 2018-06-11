Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38196 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932139AbeFKTfu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 15:35:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id b74-v6so10775496pfl.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 12:35:50 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: snoc: use module_platform_driver() macro
Date: Mon, 11 Jun 2018 12:35:40 -0700
Message-Id: <20180611193540.190255-1-briannorris@chromium.org> (sfid-20180611_213606_946395_5072E3AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_snoc_init()/ath10k_snoc_exit() don't add much value;
module_platform_driver() can remove the boilerplate.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index a3a7042fe13a..ee74e0060504 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1388,25 +1388,7 @@ static struct platform_driver ath10k_snoc_driver = {
 			.of_match_table = ath10k_snoc_dt_match,
 		},
 };
-
-static int __init ath10k_snoc_init(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&ath10k_snoc_driver);
-	if (ret)
-		pr_err("failed to register ath10k snoc driver: %d\n",
-		       ret);
-
-	return ret;
-}
-module_init(ath10k_snoc_init);
-
-static void __exit ath10k_snoc_exit(void)
-{
-	platform_driver_unregister(&ath10k_snoc_driver);
-}
-module_exit(ath10k_snoc_exit);
+module_platform_driver(ath10k_snoc_driver);
 
 MODULE_AUTHOR("Qualcomm");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.18.0.rc1.242.g61856ae69a-goog
