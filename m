Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8976 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbbJEG1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:40 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/18] staging: wilc1000: rename tWILCpfRemainOnChanReady
Date: Mon, 5 Oct 2015 15:25:50 +0900
Message-ID: <1444026353-29024-15-git-send-email-tony.cho@atmel.com> (sfid-20151005_082745_943601_BED3B1EA)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tWILCpfRemainOnChanReady to wilc_remain_on_chan_ready.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c929b06..dd444d1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6384,7 +6384,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
  *  @date
  *  @version		1.0
  */
-s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg)
+s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d33e4ee..7c2846e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -191,7 +191,7 @@ typedef void (*wilc_connect_result)(tenuConnDisconnEvent,
 				     void *);
 
 typedef void (*wilc_remain_on_chan_expired)(void *, u32);  /*Remain on channel expiration callback function*/
-typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback function*/
+typedef void (*wilc_remain_on_chan_ready)(void *); /*Remain on channel callback function*/
 
 /* typedef u32 WILC_WFIDrvHandle; */
 typedef struct {
@@ -278,7 +278,7 @@ struct remain_ch {
 	u16 u16Channel;
 	u32 u32duration;
 	wilc_remain_on_chan_expired pRemainOnChanExpired;
-	tWILCpfRemainOnChanReady pRemainOnChanReady;
+	wilc_remain_on_chan_ready pRemainOnChanReady;
 	void *pVoid;
 	u32 u32ListenSessionID;
 };
@@ -1149,7 +1149,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
  *  @date
  *  @version	1.0
  */
-s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, tWILCpfRemainOnChanReady RemainOnChanReady, void *pvUserArg);
+s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u32duration, u16 chan, wilc_remain_on_chan_expired RemainOnChanExpired, wilc_remain_on_chan_ready RemainOnChanReady, void *pvUserArg);
 
 /**
  *  @brief              host_int_ListenStateExpired
-- 
1.9.1

