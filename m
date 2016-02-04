Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58709 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbcBDJcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:32:05 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 46/70] staging: wilc1000: removes function 'wilc_dealloc_assoc_resp_info()'
Date: Thu, 4 Feb 2016 18:24:07 +0900
Message-ID: <1454577871-667-7-git-send-email-glen.lee@atmel.com> (sfid-20160204_103214_390238_351EF4E5)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes function wilc_dealloc_assoc_resp_info()'.
Does not need this function which only free memory.
Therefore, this function is removed and changed directly with kfree.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 22 ----------------------
 drivers/staging/wilc1000/coreconfigurator.h |  1 -
 drivers/staging/wilc1000/host_interface.c   |  4 ++--
 3 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 81dd22e..c86278d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -386,25 +386,3 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 
 	return 0;
 }
-
-s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info)
-{
-	s32 result = 0;
-
-	if (connect_resp_info) {
-		if (connect_resp_info->pu8RespIEs) {
-			kfree(connect_resp_info->pu8RespIEs);
-			connect_resp_info->pu8RespIEs = NULL;
-		} else {
-			result = -EFAULT;
-		}
-
-		kfree(connect_resp_info);
-		connect_resp_info = NULL;
-
-	} else {
-		result = -EFAULT;
-	}
-
-	return result;
-}
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 23775e4..d42f47c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -123,7 +123,6 @@ typedef struct {
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info);
-s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 				 u32 u32Length);
 void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2a1d7e9..30b93d0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1501,8 +1501,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 						}
 
 						if (pstrConnectRespInfo) {
-							wilc_dealloc_assoc_resp_info(pstrConnectRespInfo);
-							pstrConnectRespInfo = NULL;
+							kfree(pstrConnectRespInfo->pu8RespIEs);
+							kfree(pstrConnectRespInfo);
 						}
 					}
 				}
-- 
1.9.1

