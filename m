Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3401 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbJMKzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:55:04 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 41/54] staging: wilc1000: rename pu8Head of struct beacon_attr
Date: Tue, 13 Oct 2015 19:50:06 +0900
Message-ID: <1444733419-17679-41-git-send-email-tony.cho@atmel.com> (sfid-20151013_125509_030214_D078FE7C)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8Head of struct beacon_attr to head to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70ba13f..dd07e11 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -134,7 +134,7 @@ struct beacon_attr {
 	u32 interval;
 	u32 dtim_period;
 	u32 head_len;
-	u8 *pu8Head;
+	u8 *head;
 	u32 u32TailLen;
 	u8 *pu8Tail;
 };
@@ -2359,7 +2359,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 24) & 0xFF);
 
-	memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Head, pstrSetBeaconParam->head_len);
+	memcpy(pu8CurrByte, pstrSetBeaconParam->head, pstrSetBeaconParam->head_len);
 	pu8CurrByte += pstrSetBeaconParam->head_len;
 
 	*pu8CurrByte++ = (pstrSetBeaconParam->u32TailLen & 0xFF);
@@ -2378,7 +2378,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 
 ERRORHANDLER:
 	kfree(strWID.val);
-	kfree(pstrSetBeaconParam->pu8Head);
+	kfree(pstrSetBeaconParam->head);
 	kfree(pstrSetBeaconParam->pu8Tail);
 }
 
@@ -4644,12 +4644,12 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	pstrSetBeaconParam->interval = u32Interval;
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
 	pstrSetBeaconParam->head_len = u32HeadLen;
-	pstrSetBeaconParam->pu8Head = kmalloc(u32HeadLen, GFP_KERNEL);
-	if (pstrSetBeaconParam->pu8Head == NULL) {
+	pstrSetBeaconParam->head = kmalloc(u32HeadLen, GFP_KERNEL);
+	if (pstrSetBeaconParam->head == NULL) {
 		s32Error = -ENOMEM;
 		goto ERRORHANDLER;
 	}
-	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
+	memcpy(pstrSetBeaconParam->head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
 	if (u32TailLen > 0) {
@@ -4669,8 +4669,8 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 
 ERRORHANDLER:
 	if (s32Error) {
-		if (pstrSetBeaconParam->pu8Head != NULL)
-			kfree(pstrSetBeaconParam->pu8Head);
+		if (pstrSetBeaconParam->head != NULL)
+			kfree(pstrSetBeaconParam->head);
 
 		if (pstrSetBeaconParam->pu8Tail != NULL)
 			kfree(pstrSetBeaconParam->pu8Tail);
-- 
1.9.1

