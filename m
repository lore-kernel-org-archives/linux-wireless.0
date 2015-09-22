Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35962 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:48:14 -0400
Received: by pacgz1 with SMTP id gz1so7324943pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:48:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 8/9] staging: wilc1000: rename ParseNetworkInfo
Date: Tue, 22 Sep 2015 22:47:44 +0900
Message-Id: <1442929665-19709-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154818_308320_D9A34233)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces ParseNetworkInfo with parse_network_info to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 drivers/staging/wilc1000/host_interface.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index bdf775a..3c71b9f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -360,7 +360,7 @@ u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
  *  @date			1 Mar 2012
  *  @version		1.0
  */
-s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
+s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 {
 	s32 s32Error = 0;
 	tstrNetworkInfo *pstrNetworkInfo = NULL;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index e2b7b09..c2bd6fc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -145,7 +145,7 @@ typedef struct wid_site_survey_reslts {
 
 s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
-s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
+s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
 s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c4ef274..e7fc648 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2269,7 +2269,7 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler,
 	/*if there is a an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		PRINT_D(HOSTINF_DBG, "State: Scanning, parsing network information received\n");
-		ParseNetworkInfo(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
+		parse_network_info(pstrRcvdNetworkInfo->pu8Buffer, &pstrNetworkInfo);
 		if ((pstrNetworkInfo == NULL)
 		    || (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult == NULL)) {
 			PRINT_ER("driver is null\n");
-- 
2.5.1

