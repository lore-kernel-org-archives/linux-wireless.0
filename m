Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:52423 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966278AbeCHFKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 00:10:39 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: m@bues.ch
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2] ssb: use put_device() if device_register fail
Date: Thu,  8 Mar 2018 10:39:49 +0530
Message-Id: <1520485789-8550-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20180308_061059_493086_2EB2A19D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Never directly free @dev after calling device_register(), even
if it returned an error! Always use put_device() to give up the
reference initialized.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2:
             Removed kfree() call for @dev.

 drivers/ssb/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 65420a9..a7a062b 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -521,8 +521,8 @@ static int ssb_devices_register(struct ssb_bus *bus)
 			ssb_err("Could not register %s\n", dev_name(dev));
 			/* Set dev to NULL to not unregister
 			 * dev on error unwinding. */
+			put_device(dev);
 			sdev->dev = NULL;
-			kfree(devwrap);
 			goto error;
 		}
 		dev_idx++;
-- 
1.9.1
