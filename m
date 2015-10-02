Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35270 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbJBNS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 09:18:28 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 2/3] drivers: staging: wilc1000: Remove ineffective code
Date: Fri,  2 Oct 2015 18:47:36 +0530
Message-Id: <1443791857-7837-2-git-send-email-csgorentla@gmail.com> (sfid-20151002_151858_687455_5ACC633A)
In-Reply-To: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
References: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value of 'result' is not modified from 0 after initialization.
Hence no need to check it.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 1b73b63..a9c28ad 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -145,11 +145,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	down(&pHandle->hSem);
 
 	/* other non-timeout scenarios */
-	if (result) {
-		PRINT_ER("Non-timeout\n");
-		return result;
-	}
-
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
 		return -EFAULT;
-- 
2.1.4

