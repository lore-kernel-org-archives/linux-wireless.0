Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45106 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbeCGKCS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 05:02:18 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: m@bues.ch
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb:: use put_device() if device_register fail
Date: Wed,  7 Mar 2018 15:31:30 +0530
Message-Id: <bdd20c00cba68044d82e387072b39f0176448e97.1520416785.git.arvind.yadav.cs@gmail.com> (sfid-20180307_110248_558757_8572846C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if device_register() returned an error! Always use put_device()
to give up the reference initialized.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/ssb/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 65420a9..c4449e0 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -521,6 +521,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
 			ssb_err("Could not register %s\n", dev_name(dev));
 			/* Set dev to NULL to not unregister
 			 * dev on error unwinding. */
+			put_device(dev);
 			sdev->dev = NULL;
 			kfree(devwrap);
 			goto error;
-- 
1.9.1
