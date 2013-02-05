Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59656 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3BEUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 15:45:15 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi8so796677wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 12:45:14 -0800 (PST)
Message-ID: <1360097107.2856.3.camel@canaries64> (sfid-20130205_214521_340214_2E06608C)
Subject: [PATCH] staging: vt6656: Fix sparse warning constant
 0xffffffff00000000U is so big it is unsigned long
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Feb 2013 20:45:07 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


long long is needed for u64.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 7d725bb..4e8fcc9 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -790,7 +790,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval)
 	if ((~uLowNextTBTT) < uLowRemain)
 		qwTSF = ((qwTSF >> 32) + 1) << 32;
 
-	qwTSF = (qwTSF & 0xffffffff00000000U) |
+	qwTSF = (qwTSF & 0xffffffff00000000ULL) |
 		(u64)(uLowNextTBTT + uLowRemain);
 
     return (qwTSF);
-- 
1.8.0


