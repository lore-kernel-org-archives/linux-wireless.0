Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13973 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbI3JsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:22 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/32] staging: wilc1000: rename strHostIFCfgParamAttr
Date: Wed, 30 Sep 2015 18:44:25 +0900
Message-ID: <1443606289-25407-8-git-send-email-tony.cho@atmel.com> (sfid-20150930_114825_038995_C633E3D9)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFCfgParamAttr to cfg_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d4e8122..76e82e6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -419,7 +419,7 @@ union message_body {
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
-	struct cfg_param_attr strHostIFCfgParamAttr;
+	struct cfg_param_attr cfg_info;
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
 	struct set_beacon strHostIFSetBeacon;
@@ -4124,7 +4124,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_CFG_PARAMS:
 
-			Handle_CfgParam(msg.drvHandler, &msg.body.strHostIFCfgParamAttr);
+			Handle_CfgParam(msg.drvHandler, &msg.body.cfg_info);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
@@ -5854,7 +5854,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	/* prepare the WiphyParams Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
-	msg.body.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
+	msg.body.cfg_info.pstrCfgParamVal = *pstrCfgParamVal;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

