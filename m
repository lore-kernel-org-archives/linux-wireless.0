Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42248 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbbJ1HBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:02 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 34/80] staging: wilc1000: rename u16Channel of struct remain_ch
Date: Wed, 28 Oct 2015 15:59:54 +0900
Message-ID: <1446015640-29398-34-git-send-email-glen.lee@atmel.com> (sfid-20151028_080119_076652_19F222D5)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16Channel of struct remain_ch to ch
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 ++++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 543d223..75f617a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2484,10 +2484,10 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		hif_drv->remain_on_ch.pVoid = pstrHostIfRemainOnChan->pVoid;
 		hif_drv->remain_on_ch.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
 		hif_drv->remain_on_ch.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
-		hif_drv->remain_on_ch.u16Channel = pstrHostIfRemainOnChan->u16Channel;
+		hif_drv->remain_on_ch.ch = pstrHostIfRemainOnChan->ch;
 		hif_drv->remain_on_ch.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
 	} else {
-		pstrHostIfRemainOnChan->u16Channel = hif_drv->remain_on_ch.u16Channel;
+		pstrHostIfRemainOnChan->ch = hif_drv->remain_on_ch.ch;
 	}
 
 	if (hif_drv->usr_scan_req.pfUserScanResult) {
@@ -2508,7 +2508,8 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
+	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n",
+		pstrHostIfRemainOnChan->ch);
 
 	u8remain_on_chan_flag = true;
 	wid.id = (u16)WID_REMAIN_ON_CHAN;
@@ -2521,7 +2522,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	}
 
 	wid.val[0] = u8remain_on_chan_flag;
-	wid.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
+	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
@@ -4364,7 +4365,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
-	msg.body.remain_on_ch.u16Channel = chan;
+	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.pRemainOnChanExpired = RemainOnChanExpired;
 	msg.body.remain_on_ch.pRemainOnChanReady = RemainOnChanReady;
 	msg.body.remain_on_ch.pVoid = pvUserArg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 14563d3..eea251a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -236,7 +236,7 @@ struct ba_session_info {
 };
 
 struct remain_ch {
-	u16 u16Channel;
+	u16 ch;
 	u32 u32duration;
 	wilc_remain_on_chan_expired pRemainOnChanExpired;
 	wilc_remain_on_chan_ready pRemainOnChanReady;
-- 
1.9.1

