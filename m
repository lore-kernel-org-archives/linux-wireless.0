Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42311 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbbJ1HBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:13 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 36/80] staging: wilc1000: rename pRemainOnChanReady of struct remain_ch
Date: Wed, 28 Oct 2015 15:59:56 +0900
Message-ID: <1446015640-29398-36-git-send-email-glen.lee@atmel.com> (sfid-20151028_080119_669825_65855068)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pRemainOnChanReady of struct remain_ch to ready
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0bd0d2b..3ee25c6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2483,7 +2483,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	if (!hif_drv->remain_on_ch_pending) {
 		hif_drv->remain_on_ch.pVoid = pstrHostIfRemainOnChan->pVoid;
 		hif_drv->remain_on_ch.expired = pstrHostIfRemainOnChan->expired;
-		hif_drv->remain_on_ch.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
+		hif_drv->remain_on_ch.ready = pstrHostIfRemainOnChan->ready;
 		hif_drv->remain_on_ch.ch = pstrHostIfRemainOnChan->ch;
 		hif_drv->remain_on_ch.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
 	} else {
@@ -2537,8 +2537,8 @@ ERRORHANDLER:
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
-		if (hif_drv->remain_on_ch.pRemainOnChanReady)
-			hif_drv->remain_on_ch.pRemainOnChanReady(hif_drv->remain_on_ch.pVoid);
+		if (hif_drv->remain_on_ch.ready)
+			hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.pVoid);
 
 		if (hif_drv->remain_on_ch_pending)
 			hif_drv->remain_on_ch_pending = 0;
@@ -4367,7 +4367,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.expired = RemainOnChanExpired;
-	msg.body.remain_on_ch.pRemainOnChanReady = RemainOnChanReady;
+	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.pVoid = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 58d3101..bbb9690 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -239,7 +239,7 @@ struct remain_ch {
 	u16 ch;
 	u32 u32duration;
 	wilc_remain_on_chan_expired expired;
-	wilc_remain_on_chan_ready pRemainOnChanReady;
+	wilc_remain_on_chan_ready ready;
 	void *pVoid;
 	u32 u32ListenSessionID;
 };
-- 
1.9.1

