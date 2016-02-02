Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8985 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbcBBMFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:05:00 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/26] staging: wilc1000: removes function 'wilc_dealloc_network_info()'
Date: Tue, 2 Feb 2016 21:02:11 +0900
Message-ID: <1454414556-9822-1-git-send-email-leo.kim@atmel.com> (sfid-20160202_130503_530541_1DA2F43A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function 'wilc_dealloc_network_info()'.
Does not need this function which only free memory.
Therefore, this function is removed and changed directly with kfree.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 22 ----------------------
 drivers/staging/wilc1000/coreconfigurator.h |  1 -
 drivers/staging/wilc1000/host_interface.c   |  4 ++--
 3 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 11e3ce0..81dd22e 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -353,28 +353,6 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 	return 0;
 }
 
-s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info)
-{
-	s32 result = 0;
-
-	if (network_info) {
-		if (network_info->pu8IEs) {
-			kfree(network_info->pu8IEs);
-			network_info->pu8IEs = NULL;
-		} else {
-			result = -EFAULT;
-		}
-
-		kfree(network_info);
-		network_info = NULL;
-
-	} else {
-		result = -EFAULT;
-	}
-
-	return result;
-}
-
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info)
 {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index d801e58..23775e4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -121,7 +121,6 @@ typedef struct {
 } tstrDisconnectNotifInfo;
 
 s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
-s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       tstrConnectRespInfo **ret_connect_resp_info);
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e6a6a03..3ce3a7c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1414,8 +1414,8 @@ done:
 	pstrRcvdNetworkInfo->buffer = NULL;
 
 	if (pstrNetworkInfo) {
-		wilc_dealloc_network_info(pstrNetworkInfo);
-		pstrNetworkInfo = NULL;
+		kfree(pstrNetworkInfo->pu8IEs);
+		kfree(pstrNetworkInfo);
 	}
 
 	return result;
-- 
1.9.1

