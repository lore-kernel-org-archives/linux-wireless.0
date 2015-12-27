Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:32858 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbbL0Q6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 11:58:03 -0500
Date: Sun, 27 Dec 2015 23:59:57 +0700
From: Ivan Safonov <insafonov@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: wilc1000: wilc_parse_network_info refactoring
Message-ID: <20151227165957.GA22276@alpha.sfu-kras.ru> (sfid-20151227_175806_920844_AD889FE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) Return value of this function does not used;
2) wilc_parse_network_info has no reasons to return an error;
3) kfree does not free memory if argument is NULL.

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 27 +++++----------------------
 drivers/staging/wilc1000/coreconfigurator.h |  2 +-
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2d4d3f1..a36918c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -458,34 +458,17 @@ s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo
 
 /**
  *  @brief              Deallocates the parsed Network Info
- *  @details
  *  @param[in]  pstrNetworkInfo Network Info to be deallocated
- *  @return             Error code indicating success/failure
- *  @note
  *  @author		mabubakr
  *  @date		1 Mar 2012
- *  @version		1.0
  */
-s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
+void wilc_dealloc_network_info(tstrNetworkInfo *network_info)
 {
-	s32 s32Error = 0;
+	if (!network_info)
+		return;
 
-	if (pstrNetworkInfo) {
-		if (pstrNetworkInfo->pu8IEs) {
-			kfree(pstrNetworkInfo->pu8IEs);
-			pstrNetworkInfo->pu8IEs = NULL;
-		} else {
-			s32Error = -EFAULT;
-		}
-
-		kfree(pstrNetworkInfo);
-		pstrNetworkInfo = NULL;
-
-	} else {
-		s32Error = -EFAULT;
-	}
-
-	return s32Error;
+	kfree(network_info->pu8IEs);
+	kfree(network_info);
 }
 
 /**
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index fc43d04..8c28c6b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -130,7 +130,7 @@ typedef struct {
 s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 			 u32 count, u32 drv);
 s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
-s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
+void wilc_dealloc_network_info(tstrNetworkInfo *network_info);
 
 s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 		       tstrConnectRespInfo **ppstrConnectRespInfo);
-- 
2.4.10

