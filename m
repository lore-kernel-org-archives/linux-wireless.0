Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34779 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751884AbcLHHbB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 02:31:01 -0500
Received: by mail-wj0-f196.google.com with SMTP id xy5so53108457wjc.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 23:31:00 -0800 (PST)
From: =?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: rfkill: Cleanup error handling in rfkill_init()
Date: Thu,  8 Dec 2016 08:30:51 +0100
Message-Id: <20161208073052.12988-1-kernel@kempniu.pl> (sfid-20161208_083122_056850_3B9D2749)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a separate label per error condition in rfkill_init() to make it a
bit cleaner and easier to extend.

Signed-off-by: Michał Kępień <kernel@kempniu.pl>
---
No changes from v1.

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
