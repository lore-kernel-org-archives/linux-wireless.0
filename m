Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41779 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbJ1G7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:08 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/80] staging: wilc1000: rename strHostIfRemainOnChan of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:35 +0900
Message-ID: <1446015640-29398-15-git-send-email-glen.lee@atmel.com> (sfid-20151028_081700_376224_C09773A5)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strHostIfRemainOnChan of struct host_if_drv to remain_on_ch
to avoid CamelCase naming convention.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 drivers/staging/wilc1000/host_interface.h |  4 +---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ce09879..dd09152 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2477,13 +2477,13 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	struct wid wid;
 
 	if (!hif_drv->u8RemainOnChan_pendingreq) {
-		hif_drv->strHostIfRemainOnChan.pVoid = pstrHostIfRemainOnChan->pVoid;
-		hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
-		hif_drv->strHostIfRemainOnChan.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
-		hif_drv->strHostIfRemainOnChan.u16Channel = pstrHostIfRemainOnChan->u16Channel;
-		hif_drv->strHostIfRemainOnChan.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
+		hif_drv->remain_on_ch.pVoid = pstrHostIfRemainOnChan->pVoid;
+		hif_drv->remain_on_ch.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
+		hif_drv->remain_on_ch.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
+		hif_drv->remain_on_ch.u16Channel = pstrHostIfRemainOnChan->u16Channel;
+		hif_drv->remain_on_ch.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
 	} else {
-		pstrHostIfRemainOnChan->u16Channel = hif_drv->strHostIfRemainOnChan.u16Channel;
+		pstrHostIfRemainOnChan->u16Channel = hif_drv->remain_on_ch.u16Channel;
 	}
 
 	if (hif_drv->usr_scan_req.pfUserScanResult) {
@@ -2532,8 +2532,8 @@ ERRORHANDLER:
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
-		if (hif_drv->strHostIfRemainOnChan.pRemainOnChanReady)
-			hif_drv->strHostIfRemainOnChan.pRemainOnChanReady(hif_drv->strHostIfRemainOnChan.pVoid);
+		if (hif_drv->remain_on_ch.pRemainOnChanReady)
+			hif_drv->remain_on_ch.pRemainOnChanReady(hif_drv->remain_on_ch.pVoid);
 
 		if (hif_drv->u8RemainOnChan_pendingreq)
 			hif_drv->u8RemainOnChan_pendingreq = 0;
@@ -2605,9 +2605,9 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 			goto _done_;
 		}
 
-		if (hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired) {
-			hif_drv->strHostIfRemainOnChan.pRemainOnChanExpired(hif_drv->strHostIfRemainOnChan.pVoid
-									       , pstrHostIfRemainOnChan->u32ListenSessionID);
+		if (hif_drv->remain_on_ch.pRemainOnChanExpired) {
+			hif_drv->remain_on_ch.pRemainOnChanExpired(hif_drv->remain_on_ch.pVoid,
+								   pstrHostIfRemainOnChan->u32ListenSessionID);
 		}
 		P2P_LISTEN_STATE = 0;
 	} else {
@@ -2630,7 +2630,7 @@ static void ListenTimerCB(unsigned long arg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
-	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->strHostIfRemainOnChan.u32ListenSessionID;
+	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->remain_on_ch.u32ListenSessionID;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e9bc83a..ea47a0d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -294,9 +294,7 @@ enum p2p_listen_state {
 struct host_if_drv {
 	struct user_scan_req usr_scan_req;
 	struct user_conn_req usr_conn_req;
-
-	/*Remain on channel struvture*/
-	struct remain_ch strHostIfRemainOnChan;
+	struct remain_ch remain_on_ch;
 	u8 u8RemainOnChan_pendingreq;
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
-- 
1.9.1

