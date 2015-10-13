Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4863 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbbJMLDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:03:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 52/54] staging: wilc1000: rename pu8Buffer of struct rcvd_net_info
Date: Tue, 13 Oct 2015 20:02:10 +0900
Message-ID: <1444734132-17858-7-git-send-email-tony.cho@atmel.com> (sfid-20151013_130318_290089_92977FCD)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8Buffer of struct rcvd_net_info to buffer to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 ++++++-------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8fb6ef5..432b275 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1450,7 +1450,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 
 	if (hif_drv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
-		parse_network_info(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
+		parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((pstrNetworkInfo == NULL)
 		    || (hif_drv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
 			PRINT_ER("driver is null\n");
@@ -1509,9 +1509,9 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 	}
 
 done:
-	if (pstrRcvdNetworkInfo->pu8Buffer != NULL) {
-		kfree(pstrRcvdNetworkInfo->pu8Buffer);
-		pstrRcvdNetworkInfo->pu8Buffer = NULL;
+	if (pstrRcvdNetworkInfo->buffer != NULL) {
+		kfree(pstrRcvdNetworkInfo->buffer);
+		pstrRcvdNetworkInfo->buffer = NULL;
 	}
 
 	if (pstrNetworkInfo != NULL) {
@@ -4440,9 +4440,8 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.drv = hif_drv;
 
 	msg.body.net_info.u32Length = u32Length;
-	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL);
-	memcpy(msg.body.net_info.pu8Buffer,
-		    pu8Buffer, u32Length);
+	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
+	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0c5f395..778dbf5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -199,7 +199,7 @@ typedef void (*wilc_remain_on_chan_ready)(void *); /*Remain on channel callback
  *  @version		1.0
  */
 struct rcvd_net_info {
-	u8 *pu8Buffer;
+	u8 *buffer;
 	u32 u32Length;
 };
 
-- 
1.9.1

