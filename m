Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44365 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGaHkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:40:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/28] staging: wilc1000: change type of argument in host_int_set_wfi_drv_handler
Date: Fri, 31 Jul 2015 16:38:21 +0900
Message-ID: <1438328316-30197-14-git-send-email-tony.cho@atmel.com> (sfid-20150731_094028_971167_756F8D9A)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

The parameter of u32 type is incompatible with the argument of WILC_WFIDrvHandle
type which host_int_set_wfi_drv_handler takes always as input.
Therefore, this patch changes parameter of u32 type with WILC_WFIDrvHandle type
in the function host_int_set_wfi_drv_handler.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e9cd77d..38d047d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5792,7 +5792,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 }
 
-s32 host_int_set_wfi_drv_handler(u32 u32address)
+s32 host_int_set_wfi_drv_handler(WILC_WFIDrvHandle u32address)
 {
 	s32 s32Error = WILC_SUCCESS;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 617f105..2ced05f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1256,7 +1256,7 @@ s32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, u16 u16FrameType, bool bR
  *  @date
  *  @version	1.0
  */
-s32 host_int_set_wfi_drv_handler(u32 u32address);
+s32 host_int_set_wfi_drv_handler(WILC_WFIDrvHandle u32address);
 s32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(WILC_WFIDrvHandle drvHandler, tenuScanEvent enuEvent);
-- 
1.9.1

