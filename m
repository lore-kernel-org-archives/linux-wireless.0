Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4709 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbbJMLC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:02:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 46/54] staging: wilc1000: rename bIsEnabled of struct set_multicast
Date: Tue, 13 Oct 2015 20:02:04 +0900
Message-ID: <1444734132-17858-1-git-send-email-tony.cho@atmel.com> (sfid-20151013_130231_700082_8C5552D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bIsEnabled of struct set_multicast to enabled to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 42f59fa..7ea9e01 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -140,7 +140,7 @@ struct beacon_attr {
 };
 
 struct set_multicast {
-	bool bIsEnabled;
+	bool enabled;
 	u32 u32count;
 };
 
@@ -2796,10 +2796,10 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 
 	pu8CurrByte = strWID.val;
-	*pu8CurrByte++ = (strHostIfSetMulti->bIsEnabled & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->bIsEnabled >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->bIsEnabled >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->bIsEnabled >> 24) & 0xFF);
+	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
 
 	*pu8CurrByte++ = (strHostIfSetMulti->u32count & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->u32count >> 8) & 0xFF);
@@ -4912,7 +4912,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.drv = hif_drv;
 
-	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
+	pstrMulticastFilterParam->enabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

