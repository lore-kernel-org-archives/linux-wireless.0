Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:18328 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbbFPHMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:12:25 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH 2/2] staging: wilc1000: modify uninitialized warning
Date: Tue, 16 Jun 2015 16:11:25 +0900
Message-ID: <1434438685-24336-2-git-send-email-dean.lee@atmel.com> (sfid-20150616_091229_511244_A22EDB58)
In-Reply-To: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
References: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

initialize it.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 358283f..03e6bc5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7241,7 +7241,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
-	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
+	tstrHostIFSetBeacon *pstrSetBeaconParam = NULL;
 
 	if (pstrWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
@@ -7251,6 +7251,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
+	pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	/* prepare the WiphyParams Message */
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
-- 
2.4.3

