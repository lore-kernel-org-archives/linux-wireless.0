Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62593 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbaGWUft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 16:35:49 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/2] staging: vt6655: Fix disassociated messages every 10 seconds
Date: Wed, 23 Jul 2014 21:35:12 +0100
Message-Id: <1406147712-3152-2-git-send-email-tvboxspy@gmail.com> (sfid-20140723_223555_407952_F46A0549)
In-Reply-To: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com>
References: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byReAssocCount is incremented every second resulting in
disassociated message being send every 10 seconds whether
connection or not.

byReAssocCount should only advance while eCommandState
is in WLAN_ASSOCIATE_WAIT

Change existing scope to if condition.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/staging/vt6655/bssdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index eb3474d..1bd7a5a 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -981,7 +981,7 @@ start:
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
 
-	{
+	if (pDevice->eCommandState == WLAN_ASSOCIATE_WAIT) {
 		pDevice->byReAssocCount++;
 		/* 10 sec timeout */
 		if ((pDevice->byReAssocCount > 10) && (!pDevice->bLinkPass)) {
-- 
1.9.1

