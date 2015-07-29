Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36126 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbG2OHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 10:07:45 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH] staging: wilc1000: host_interface.c: Fix build warning
Date: Wed, 29 Jul 2015 19:36:59 +0530
Message-Id: <1438178819-12740-1-git-send-email-csgorentla@gmail.com> (sfid-20150729_161115_318324_7D97C49A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed - warning: ‘*((void *)&strHostIFmsg+4).pu8Head’ may be used uninitialized 

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c089e73..f610903 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7113,7 +7113,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	tstrHostIFmsg strHostIFmsg;
+	tstrHostIFmsg strHostIFmsg = {};
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL)
-- 
2.4.5

