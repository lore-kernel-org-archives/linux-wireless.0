Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:32951 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbJBNSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 09:18:21 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 1/3] drivers: staging: wilc1000: Check for errors before kfree
Date: Fri,  2 Oct 2015 18:47:35 +0530
Message-Id: <1443791857-7837-1-git-send-email-csgorentla@gmail.com> (sfid-20151002_151942_575556_29FB6839)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the clean-up of the function, it is need to check if
errors occurred, not the memory pointer.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d5ebd6d..1b73b63 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -105,7 +105,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 ERRORHANDLER:
 	/* error occured, free any allocations */
-	if (pstrMessage) {
+	if (result) {
 		kfree(pstrMessage->pvBuffer);
 		kfree(pstrMessage);
 	}
-- 
2.1.4

