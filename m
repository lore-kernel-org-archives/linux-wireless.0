Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:49190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760371AbYEMUMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 16:12:30 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1325587nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 13:12:28 -0700 (PDT)
Message-ID: <4829F62B.8030003@gmail.com> (sfid-20080513_221254_291140_B40DBA10)
Date: Tue, 13 May 2008 22:12:27 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: breed@users.sourceforge.net
CC: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless, airo: waitbusy() won't delay
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There will be no delay even when COMMAND_BUSY (defined 0x8000) is set:
0x8000 & (delay < 10000) will evaluate to 0 - when delay is 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 45f47c1..efb7444 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2904,7 +2904,7 @@ EXPORT_SYMBOL(init_airo_card);
 
 static int waitbusy (struct airo_info *ai) {
 	int delay = 0;
-	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) & (delay < 10000)) {
+	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
 		udelay (10);
 		if ((++delay % 20) == 0)
 			OUT4500(ai, EVACK, EV_CLEARCOMMANDBUSY);



