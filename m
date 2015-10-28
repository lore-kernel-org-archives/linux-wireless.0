Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43167 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbJ1HF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 62/80] staging: wilc1000: rename u32ListenSessionID of struct remain_ch
Date: Wed, 28 Oct 2015 16:07:07 +0900
Message-ID: <1446016045-32154-12-git-send-email-glen.lee@atmel.com> (sfid-20151028_080540_346109_D3F4CE0F)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32ListenSessionID of struct remain_ch to id
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e5d5f37..f3c8bb0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2490,7 +2490,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 		hif_drv->remain_on_ch.expired = pstrHostIfRemainOnChan->expired;
 		hif_drv->remain_on_ch.ready = pstrHostIfRemainOnChan->ready;
 		hif_drv->remain_on_ch.ch = pstrHostIfRemainOnChan->ch;
-		hif_drv->remain_on_ch.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
+		hif_drv->remain_on_ch.id = pstrHostIfRemainOnChan->id;
 	} else {
 		pstrHostIfRemainOnChan->ch = hif_drv->remain_on_ch.ch;
 	}
@@ -2618,7 +2618,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 
 		if (hif_drv->remain_on_ch.expired) {
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
-						      pstrHostIfRemainOnChan->u32ListenSessionID);
+						      pstrHostIfRemainOnChan->id);
 		}
 		P2P_LISTEN_STATE = 0;
 	} else {
@@ -2641,7 +2641,7 @@ static void ListenTimerCB(unsigned long arg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
-	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->remain_on_ch.u32ListenSessionID;
+	msg.body.remain_on_ch.id = hif_drv->remain_on_ch.id;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -4380,7 +4380,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.arg = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
-	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
+	msg.body.remain_on_ch.id = u32SessionID;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4405,7 +4405,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drv = hif_drv;
-	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
+	msg.body.remain_on_ch.id = u32SessionID;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 891e7e1..d01ec5c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -244,7 +244,7 @@ struct remain_ch {
 	wilc_remain_on_chan_expired expired;
 	wilc_remain_on_chan_ready ready;
 	void *arg;
-	u32 u32ListenSessionID;
+	u32 id;
 };
 
 struct reg_frame {
-- 
1.9.1

