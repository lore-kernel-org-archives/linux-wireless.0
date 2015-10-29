Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4902 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:10 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 18/64] staging: wilc1000: rename u16Channel of struct remain_ch
Date: Thu, 29 Oct 2015 11:58:41 +0900
Message-ID: <1446087567-16728-18-git-send-email-glen.lee@atmel.com> (sfid-20151029_035814_010951_1DCC0F31)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
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
index 12e0d21..99958f4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2483,10 +2483,10 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
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
@@ -2507,7 +2507,8 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
+	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n",
+		pstrHostIfRemainOnChan->ch);
 
 	u8remain_on_chan_flag = true;
 	wid.id = (u16)WID_REMAIN_ON_CHAN;
@@ -2520,7 +2521,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	}
 
 	wid.val[0] = u8remain_on_chan_flag;
-	wid.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
+	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
@@ -4367,7 +4368,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
-	msg.body.remain_on_ch.u16Channel = chan;
+	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.pRemainOnChanExpired = RemainOnChanExpired;
 	msg.body.remain_on_ch.pRemainOnChanReady = RemainOnChanReady;
 	msg.body.remain_on_ch.pVoid = pvUserArg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6cca6e0..dc68711 100644
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

