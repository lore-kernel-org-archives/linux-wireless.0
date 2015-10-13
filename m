Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3493 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:55:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 43/54] staging: wilc1000: rename pu8Tail of struct beacon_attr
Date: Tue, 13 Oct 2015 19:50:08 +0900
Message-ID: <1444733419-17679-43-git-send-email-tony.cho@atmel.com> (sfid-20151013_125521_501543_6A28FEF6)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8Tail of struct beacon_attr to tail to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2a2361a..42081f8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -136,7 +136,7 @@ struct beacon_attr {
 	u32 head_len;
 	u8 *head;
 	u32 tail_len;
-	u8 *pu8Tail;
+	u8 *tail;
 };
 
 struct set_multicast {
@@ -2367,8 +2367,8 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
 
-	if (pstrSetBeaconParam->pu8Tail > 0)
-		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->tail_len);
+	if (pstrSetBeaconParam->tail > 0)
+		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
 	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
@@ -2379,7 +2379,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	kfree(strWID.val);
 	kfree(pstrSetBeaconParam->head);
-	kfree(pstrSetBeaconParam->pu8Tail);
+	kfree(pstrSetBeaconParam->tail);
 }
 
 static void Handle_DelBeacon(struct host_if_drv *hif_drv)
@@ -4653,14 +4653,14 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 	pstrSetBeaconParam->tail_len = u32TailLen;
 
 	if (u32TailLen > 0) {
-		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
-		if (pstrSetBeaconParam->pu8Tail == NULL) {
+		pstrSetBeaconParam->tail = kmalloc(u32TailLen, GFP_KERNEL);
+		if (pstrSetBeaconParam->tail == NULL) {
 			s32Error = -ENOMEM;
 			goto ERRORHANDLER;
 		}
-		memcpy(pstrSetBeaconParam->pu8Tail, pu8Tail, u32TailLen);
+		memcpy(pstrSetBeaconParam->tail, pu8Tail, u32TailLen);
 	} else {
-		pstrSetBeaconParam->pu8Tail = NULL;
+		pstrSetBeaconParam->tail = NULL;
 	}
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4672,8 +4672,8 @@ ERRORHANDLER:
 		if (pstrSetBeaconParam->head != NULL)
 			kfree(pstrSetBeaconParam->head);
 
-		if (pstrSetBeaconParam->pu8Tail != NULL)
-			kfree(pstrSetBeaconParam->pu8Tail);
+		if (pstrSetBeaconParam->tail != NULL)
+			kfree(pstrSetBeaconParam->tail);
 	}
 
 	return s32Error;
-- 
1.9.1

