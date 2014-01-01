Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40333 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaAATTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jan 2014 14:19:40 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so18101870wid.5
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jan 2014 11:19:39 -0800 (PST)
Message-ID: <1388603968.29916.5.camel@canaries32-MCP7A> (sfid-20140101_201944_536136_04D91DB2)
Subject: [PATCH 1/2] staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Jan 2014 19:19:28 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

value uLowNextTBTT yields wrong value.

ULL is needed with qwTSF

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.9+
---
 drivers/staging/vt6656/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index bb91ffa..ce7ee45 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -727,7 +727,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval)
 
     uBeaconInterval = wBeaconInterval * 1024;
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-	uLowNextTBTT = ((qwTSF & 0xffffffffU) >> 10) << 10;
+	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
 	uHighRemain = ((0x80000000 % uBeaconInterval) * 2 * (u32)(qwTSF >> 32))
 		% uBeaconInterval;
-- 
1.8.5.2

