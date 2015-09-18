Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46074 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbbIRJPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:15:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 34/34] staging: wilc1000: delete unnecessary comments and dead code
Date: Fri, 18 Sep 2015 18:11:36 +0900
Message-ID: <1442567496-29331-34-git-send-email-tony.cho@atmel.com> (sfid-20150918_111546_193548_9D4D6E16)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comments in union message_body are not essential and cross 80 ending
line, so they are deleted and also a dead code commented out in the union
is deleted.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c87bf13..50cd649 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -413,22 +413,21 @@ struct sta_inactive_t {
  *  @version		1.0
  */
 union message_body {
-	struct scan_attr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
-	struct connect_attr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
-	struct rcvd_net_info strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
-	struct rcvd_async_info strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
-	struct key_attr strHostIFkeyAttr;                             /*!<>*/
-	struct cfg_param_attr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
+	struct scan_attr strHostIFscanAttr;
+	struct connect_attr strHostIFconnectAttr;
+	struct rcvd_net_info strRcvdNetworkInfo;
+	struct rcvd_async_info strRcvdGnrlAsyncInfo;
+	struct key_attr strHostIFkeyAttr;
+	struct cfg_param_attr strHostIFCfgParamAttr;
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
-	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
-	struct del_beacon strHostIFDelBeacon;                 /*!< Del beacon message body */
-	struct add_sta_param strAddStaParam;                    /*!< Add station message body */
-	struct del_sta strDelStaParam;                                /*!< Del Station message body */
-	struct add_sta_param strEditStaParam;                           /*!< Edit station message body */
-	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
-	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
-	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
+	struct set_beacon strHostIFSetBeacon;
+	struct del_beacon strHostIFDelBeacon;
+	struct add_sta_param strAddStaParam;
+	struct del_sta strDelStaParam;
+	struct add_sta_param strEditStaParam;
+	struct timer_cb strTimerCb;
+	struct power_mgmt_param strPowerMgmtparam;
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
-- 
1.9.1

