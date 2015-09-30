Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13826 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbbI3JrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:47:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/32] staging: wilc1000: rename strRcvdNetworkInfo
Date: Wed, 30 Sep 2015 18:44:22 +0900
Message-ID: <1443606289-25407-5-git-send-email-tony.cho@atmel.com> (sfid-20150930_114726_097138_C93B5225)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strRcvdNetworkInfo to net_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 96f0b69..8a93112 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -416,7 +416,7 @@ struct sta_inactive_t {
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
-	struct rcvd_net_info strRcvdNetworkInfo;
+	struct rcvd_net_info net_info;
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;
 	struct key_attr strHostIFkeyAttr;
 	struct cfg_param_attr strHostIFCfgParamAttr;
@@ -4111,7 +4111,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.body.strRcvdNetworkInfo);
+			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.body.net_info);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
@@ -6302,9 +6302,9 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drvHandler = pstrWFIDrv;
 
-	msg.body.strRcvdNetworkInfo.u32Length = u32Length;
-	msg.body.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(msg.body.strRcvdNetworkInfo.pu8Buffer,
+	msg.body.net_info.u32Length = u32Length;
+	msg.body.net_info.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.body.net_info.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-- 
1.9.1

