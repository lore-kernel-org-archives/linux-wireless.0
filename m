Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2KMPlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 10:41:23 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so5180100pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 07:41:23 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/1] ath5k: Use module_platform_driver macro for ahb.c
Date: Tue, 13 Nov 2012 21:09:50 +0530
Message-Id: <1352821190-6478-1-git-send-email-s.syam@samsung.com> (sfid-20121113_164130_556957_09DF8781)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the code by make use of module_platform_driver macro.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index aec33cc..8e8bcc7 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -236,17 +236,4 @@ static struct platform_driver ath_ahb_driver = {
 	},
 };
 
-static int __init
-ath5k_ahb_init(void)
-{
-	return platform_driver_register(&ath_ahb_driver);
-}
-
-static void __exit
-ath5k_ahb_exit(void)
-{
-	platform_driver_unregister(&ath_ahb_driver);
-}
-
-module_init(ath5k_ahb_init);
-module_exit(ath5k_ahb_exit);
+module_platform_driver(ath_ahb_driver);
-- 
1.7.4.1

