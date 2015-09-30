Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13869 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbbI3Jrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:47:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/32] staging: wilc1000: rename strRcvdGnrlAsyncInfo
Date: Wed, 30 Sep 2015 18:44:23 +0900
Message-ID: <1443606289-25407-6-git-send-email-tony.cho@atmel.com> (sfid-20150930_114737_612785_E91EF293)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strRcvdGnrlAsyncInfo to async_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8a93112..b24c022 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -417,7 +417,7 @@ union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
-	struct rcvd_async_info strRcvdGnrlAsyncInfo;
+	struct rcvd_async_info async_info;
 	struct key_attr strHostIFkeyAttr;
 	struct cfg_param_attr strHostIFCfgParamAttr;
 	struct set_channel strHostIFSetChan;
@@ -4115,7 +4115,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.body.strRcvdGnrlAsyncInfo);
+			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.body.async_info);
 			break;
 
 		case HOST_IF_MSG_KEY:
@@ -6359,9 +6359,9 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.drvHandler = pstrWFIDrv;
 
 
-	msg.body.strRcvdGnrlAsyncInfo.u32Length = u32Length;
-	msg.body.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(msg.body.strRcvdGnrlAsyncInfo.pu8Buffer,
+	msg.body.async_info.u32Length = u32Length;
+	msg.body.async_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.body.async_info.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-- 
1.9.1

