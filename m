Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbGaHmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:42:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/28] staging: wilc1000: change data type of variable
Date: Fri, 31 Jul 2015 16:38:36 +0900
Message-ID: <1438328316-30197-29-git-send-email-tony.cho@atmel.com> (sfid-20150731_094205_584706_5E3B5499)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

drvHandler of u32 type is used to handle integer type pointer operation which
cause build warnings.
To use integer type varialbe as pointer, drvHandler data type need to be changed
with uintptr_t type.

drivers/staging/wilc1000/host_interface.c: In function ‘NetworkInfoReceived’:
drivers/staging/wilc1000/host_interface.c:6767:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
               ^
drivers/staging/wilc1000/host_interface.c: In function ‘GnrlAsyncInfoReceived’:
drivers/staging/wilc1000/host_interface.c:6819:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
               ^
drivers/staging/wilc1000/host_interface.c: In function ‘host_int_ScanCompleteReceived’:
drivers/staging/wilc1000/host_interface.c:6878:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b36f98c..668e47e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6760,7 +6760,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	uintptr_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
@@ -6809,7 +6809,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	uintptr_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
@@ -6871,7 +6871,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	uintptr_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-- 
1.9.1

