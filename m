Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50346 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2JGH1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 03:27:07 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so2385503wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2012 00:27:05 -0700 (PDT)
Message-ID: <1349594820.3970.6.camel@Route3278> (sfid-20121007_093158_322434_A37D6E11)
Subject: [PATCH] staging: vt6656: [BUG] out of bound array reference in
 RFbSetPower.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 07 Oct 2012 08:27:00 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Calling RFbSetPower with uCH zero value will cause out of bound array reference.

This causes 64 bit kernels to oops on boot.

Note: Driver does not function on 64 bit kernels and should be
blacklisted on them.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3fd0478..8cf0881 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr = pDevice->byCCKPwr;
         return TRUE;
     }
 
+	if (uCH == 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:
-- 
1.7.10.4


