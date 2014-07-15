Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60324 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854AbaGOSz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:56 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so4889075wiv.11
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/12] staging: vt6656: int.c remove irrelevant function description
Date: Tue, 15 Jul 2014 19:54:36 +0100
Message-Id: <1405450483-2875-5-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205559_795773_DBC62027)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function does not directly poll from here

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 363e464..e78720c 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -53,28 +53,6 @@ static const u8 fallback_rate1[5][5] = {
 	{RATE_54M, RATE_54M, RATE_36M, RATE_18M, RATE_18M}
 };
 
-/*+
- *
- *  Function:   InterruptPollingThread
- *
- *  Synopsis:   Thread running at IRQL PASSIVE_LEVEL.
- *
- *  Arguments: Device Extension
- *
- *  Returns:
- *
- *  Algorithm:  Call USBD for input data;
- *
- *  History:    dd-mm-yyyy   Author    Comment
- *
- *
- *  Notes:
- *
- *  USB reads are by nature 'Blocking', and when in a read, the device looks
- *  like it's in a 'stall' condition, so we deliberately time out every second
- *  if we've gotten no data
- *
--*/
 void vnt_int_start_interrupt(struct vnt_private *priv)
 {
 	unsigned long flags;
-- 
2.0.1

