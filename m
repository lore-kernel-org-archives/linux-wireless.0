Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44118 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbGaHjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/28] staging: wilc1000: change type of driver handler in host interface msg
Date: Fri, 31 Jul 2015 16:38:09 +0900
Message-ID: <1438328316-30197-2-git-send-email-tony.cho@atmel.com> (sfid-20150731_093908_586132_044B8740)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch changes void pointer type of drvHandler with WILC_WFIDrvHandle
type variable since the structure member drvHandler in tstrHostIFmsg is
explicitly used to pass driver pointer as handler.
The void pointer as argument is ambiguous for the functions to handle correctly.

After this patch, ATWILC_WFIDrvHandle type will be used as handler type to
interface with other functions which does not need to know all about wifi driver
structre tstrATWILC_WFIDrv.
As a consequence of this patch, several patches will be followed up to change
type of parameter which take drvHandler as argument.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 02aaf39..fb4194a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -467,7 +467,7 @@ typedef union _tuniHostIFmsgBody {
 typedef struct _tstrHostIFmsg {
 	u16 u16MsgId;                                           /*!< Message ID */
 	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
-	void *drvHandler;
+	WILC_WFIDrvHandle drvHandler;
 } tstrHostIFmsg;
 
 #ifdef CONNECT_DIRECT
-- 
1.9.1

