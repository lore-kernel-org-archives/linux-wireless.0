Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:60464 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753014AbdEQQW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 12:22:59 -0400
To: linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] ssb: Delete an error message for a failed memory allocation
 in ssb_devices_register()
Message-ID: <b8db3326-5f45-04c0-a6c3-d5183d602e8d@users.sourceforge.net> (sfid-20170517_182315_385238_303D6A2C)
Date: Wed, 17 May 2017 18:22:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 May 2017 18:12:16 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/ssb/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index d1a750760cf3..65420a9f0e82 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -480,7 +480,6 @@ static int ssb_devices_register(struct ssb_bus *bus)
 
 		devwrap = kzalloc(sizeof(*devwrap), GFP_KERNEL);
 		if (!devwrap) {
-			ssb_err("Could not allocate device\n");
 			err = -ENOMEM;
 			goto error;
 		}
-- 
2.13.0
