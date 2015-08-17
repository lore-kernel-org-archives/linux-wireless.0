Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36170 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbHQNor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:44:47 -0400
Received: by pawq9 with SMTP id q9so11368252paw.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2015 06:44:47 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: return -EINVAL for invalid argument checking
Date: Mon, 17 Aug 2015 22:44:31 +0900
Message-Id: <1439819071-30000-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_154450_961208_906A9C65)
In-Reply-To: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses -EINVAL for invalid argument checking instead of using
WILC_ERRORREPORT with WILC_INVALID_ARGUMENT.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index dd87448..561ff88 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -61,7 +61,7 @@ s32 WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	Message *pstrMessage = NULL;
 
 	if ((pHandle == NULL) || (u32SendBufferSize == 0) || (pvSendBuffer == NULL)) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
+		return -EINVAL;
 	}
 
 	if (pHandle->bExiting == true) {
@@ -128,7 +128,7 @@ s32 WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 	unsigned long flags;
 	if ((pHandle == NULL) || (u32RecvBufferSize == 0)
 	    || (pvRecvBuffer == NULL) || (pu32ReceivedLength == NULL)) {
-		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
+		return -EINVAL;
 	}
 
 	if (pHandle->bExiting == true) {
-- 
1.9.1

