Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10214 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965857AbcBDJ0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:26:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 30/70] staging: wilc1000: wilc_dealloc_assoc_resp_info(): renames function variables
Date: Thu, 4 Feb 2016 18:15:47 +0900
Message-ID: <1454577387-509-31-git-send-email-glen.lee@atmel.com> (sfid-20160204_102641_475895_18809769)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames to avoid camelcase, changes follow are:
 - pstrConnectRespInfo to connect_resp_info

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 14 +++++++-------
 drivers/staging/wilc1000/coreconfigurator.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c0be33d..c78da2c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -410,20 +410,20 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 	return 0;
 }
 
-s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
+s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info)
 {
 	s32 result = 0;
 
-	if (pstrConnectRespInfo) {
-		if (pstrConnectRespInfo->pu8RespIEs) {
-			kfree(pstrConnectRespInfo->pu8RespIEs);
-			pstrConnectRespInfo->pu8RespIEs = NULL;
+	if (connect_resp_info) {
+		if (connect_resp_info->pu8RespIEs) {
+			kfree(connect_resp_info->pu8RespIEs);
+			connect_resp_info->pu8RespIEs = NULL;
 		} else {
 			result = -EFAULT;
 		}
 
-		kfree(pstrConnectRespInfo);
-		pstrConnectRespInfo = NULL;
+		kfree(connect_resp_info);
+		connect_resp_info = NULL;
 
 	} else {
 		result = -EFAULT;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6a2c323..ec810b5 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -124,7 +124,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info);
-s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo);
+s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 				 u32 u32Length);
 void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
-- 
1.9.1

