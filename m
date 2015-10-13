Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3448 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbJMKzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:55:10 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 42/54] staging: wilc1000: rename u32TailLen of struct beacon_attr
Date: Tue, 13 Oct 2015 19:50:07 +0900
Message-ID: <1444733419-17679-42-git-send-email-tony.cho@atmel.com> (sfid-20151013_125515_147504_83F1EC10)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32TailLen of struct beacon_attr to tail_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dd07e11..2a2361a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -135,7 +135,7 @@ struct beacon_attr {
 	u32 dtim_period;
 	u32 head_len;
 	u8 *head;
-	u32 u32TailLen;
+	u32 tail_len;
 	u8 *pu8Tail;
 };
 
@@ -2338,7 +2338,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_ADD_BEACON;
 	strWID.type = WID_BIN;
-	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->u32TailLen + 16;
+	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
 	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
 	if (strWID.val == NULL)
 		goto ERRORHANDLER;
@@ -2362,14 +2362,14 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	memcpy(pu8CurrByte, pstrSetBeaconParam->head, pstrSetBeaconParam->head_len);
 	pu8CurrByte += pstrSetBeaconParam->head_len;
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->u32TailLen & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 24) & 0xFF);
+	*pu8CurrByte++ = (pstrSetBeaconParam->tail_len & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 8) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
+	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
 
 	if (pstrSetBeaconParam->pu8Tail > 0)
-		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
-	pu8CurrByte += pstrSetBeaconParam->u32TailLen;
+		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->tail_len);
+	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(hif_drv));
@@ -4650,7 +4650,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 		goto ERRORHANDLER;
 	}
 	memcpy(pstrSetBeaconParam->head, pu8Head, u32HeadLen);
-	pstrSetBeaconParam->u32TailLen = u32TailLen;
+	pstrSetBeaconParam->tail_len = u32TailLen;
 
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
-- 
1.9.1

