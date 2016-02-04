Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10252 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966101AbcBDJ0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:26:21 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 31/70] staging: wilc1000: wilc_dealloc_network_info(): renames function variables
Date: Thu, 4 Feb 2016 18:15:48 +0900
Message-ID: <1454577387-509-32-git-send-email-glen.lee@atmel.com> (sfid-20160204_102642_291125_85F69841)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames to avoid camelcase, changes follow are:
 - pstrNetworkInfo to network_info

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 14 +++++++-------
 drivers/staging/wilc1000/coreconfigurator.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index c78da2c..a0b80bf 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -354,20 +354,20 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 	return 0;
 }
 
-s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
+s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info)
 {
 	s32 result = 0;
 
-	if (pstrNetworkInfo) {
-		if (pstrNetworkInfo->pu8IEs) {
-			kfree(pstrNetworkInfo->pu8IEs);
-			pstrNetworkInfo->pu8IEs = NULL;
+	if (network_info) {
+		if (network_info->pu8IEs) {
+			kfree(network_info->pu8IEs);
+			network_info->pu8IEs = NULL;
 		} else {
 			result = -EFAULT;
 		}
 
-		kfree(pstrNetworkInfo);
-		pstrNetworkInfo = NULL;
+		kfree(network_info);
+		network_info = NULL;
 
 	} else {
 		result = -EFAULT;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index ec810b5..d801e58 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -121,7 +121,7 @@ typedef struct {
 } tstrDisconnectNotifInfo;
 
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
-s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
+s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info);
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
-- 
1.9.1

