Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36446 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbbHIPUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 11:20:30 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH] staging: wilc100: Remove pointer and integer comparision
Date: Sun,  9 Aug 2015 20:50:02 +0530
Message-Id: <1439133602-9654-1-git-send-email-csgorentla@gmail.com> (sfid-20150809_172046_965217_F31245BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed pointer check with integer; this fixes 'sparse' error -
error: incompatible types for operation (>)
   left side has type unsigned char [usertype] *[usertype] pu8Tail
   right side has type int

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc549c2..4ba1ad7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3471,7 +3471,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 24) & 0xFF);
 
 	/* Bug 4599 : if tail length = 0 skip copying */
-	if (pstrSetBeaconParam->pu8Tail > 0)
+	if (pstrSetBeaconParam->pu8Tail != NULL)
 		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
 	pu8CurrByte += pstrSetBeaconParam->u32TailLen;
 
-- 
2.5.0

