Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34112 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbHSG7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:39 -0400
Received: by pdbfa8 with SMTP id fa8so77335595pdb.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:38 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/13] staging: wilc1000: wilc_msgqueue.c: fix bool comparison style
Date: Wed, 19 Aug 2015 15:59:03 +0900
Message-Id: <1439967548-25876-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085941_963357_8F518883)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes bool comparison style found by checkpatch.pl
CHECK: Using comparison to true is error prone

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index d97dd70..f974f85 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -61,7 +61,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
-	if (pHandle->bExiting == true) {
+	if (pHandle->bExiting) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
 	}
 
@@ -123,7 +123,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
 	}
 
-	if (pHandle->bExiting == true) {
+	if (pHandle->bExiting) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_FAIL);
 	}
 
-- 
1.9.1

