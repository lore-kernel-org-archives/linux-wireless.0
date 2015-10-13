Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3353 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbJMKy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 40/54] staging: wilc1000: rename u32HeadLen of struct beacon_attr
Date: Tue, 13 Oct 2015 19:50:05 +0900
Message-ID: <1444733419-17679-40-git-send-email-tony.cho@atmel.com> (sfid-20151013_125500_293699_F09B3D1C)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32HeadLen of struct beacon_attr to head_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 03ce060..70ba13f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -133,7 +133,7 @@ struct channel_attr {
 struct beacon_attr {
 	u32 interval;
 	u32 dtim_period;
-	u32 u32HeadLen;
+	u32 head_len;
 	u8 *pu8Head;
 	u32 u32TailLen;
 	u8 *pu8Tail;
@@ -2338,7 +2338,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_ADD_BEACON;
 	strWID.type = WID_BIN;
-	strWID.size = pstrSetBeaconParam->u32HeadLen + pstrSetBeaconParam->u32TailLen + 16;
+	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->u32TailLen + 16;
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.val == NULL)
 		goto ERRORHANDLER;
@@ -2354,13 +2354,13 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 24) & 0xFF);
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->u32HeadLen & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32HeadLen >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32HeadLen >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32HeadLen >> 24) & 0xFF);
+	*pu8CurrByte++ = (pstrSetBeaconParam->head_len & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 8) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 16) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 24) & 0xFF);
 
-	memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Head, pstrSetBeaconParam->u32HeadLen);
-	pu8CurrByte += pstrSetBeaconParam->u32HeadLen;
+	memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Head, pstrSetBeaconParam->head_len);
+	pu8CurrByte += pstrSetBeaconParam->head_len;
 
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32TailLen & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 8) & 0xFF);
@@ -4643,7 +4643,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	msg.drv = hif_drv;
 	pstrSetBeaconParam->interval = u32Interval;
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
-	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
+	pstrSetBeaconParam->head_len = u32HeadLen;
 	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
 	if (pstrSetBeaconParam->pu8Head == NULL) {
 		s32Error = -ENOMEM;
-- 
1.9.1

