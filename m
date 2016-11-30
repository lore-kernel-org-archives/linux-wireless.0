Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:33014 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933302AbcK3MDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 07:03:35 -0500
Received: by mail-wj0-f195.google.com with SMTP id kp2so21899053wjc.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 04:03:34 -0800 (PST)
From: =?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: rfkill: Cleanup error handling in rfkill_init()
Date: Wed, 30 Nov 2016 13:03:16 +0100
Message-Id: <20161130120317.11851-1-kernel@kempniu.pl> (sfid-20161130_130438_092935_ED4024E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a separate label per error condition in rfkill_init() to make it a
bit cleaner and easier to extend.

Signed-off-by: Michał Kępień <kernel@kempniu.pl>
---
 net/rfkill/core.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 884027f..f28e441 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1266,24 +1266,25 @@ static int __init rfkill_init(void)
 
 	error = class_register(&rfkill_class);
 	if (error)
-		goto out;
+		goto error_class;
 
 	error = misc_register(&rfkill_miscdev);
-	if (error) {
-		class_unregister(&rfkill_class);
-		goto out;
-	}
+	if (error)
+		goto error_misc;
 
 #ifdef CONFIG_RFKILL_INPUT
 	error = rfkill_handler_init();
-	if (error) {
-		misc_deregister(&rfkill_miscdev);
-		class_unregister(&rfkill_class);
-		goto out;
-	}
+	if (error)
+		goto error_input;
 #endif
 
- out:
+	return 0;
+
+error_input:
+	misc_deregister(&rfkill_miscdev);
+error_misc:
+	class_unregister(&rfkill_class);
+error_class:
 	return error;
 }
 subsys_initcall(rfkill_init);
-- 
2.10.2
