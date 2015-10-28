Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42284 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbbJ1HBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:08 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 35/80] staging: wilc1000: rename pRemainOnChanExpired of struct remain_ch
Date: Wed, 28 Oct 2015 15:59:55 +0900
Message-ID: <1446015640-29398-35-git-send-email-glen.lee@atmel.com> (sfid-20151028_080118_453232_56E873F4)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pRemainOnChanExpired of struct remain_ch to expired
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 75f617a..0bd0d2b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2482,7 +2482,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 
 	if (!hif_drv->remain_on_ch_pending) {
 		hif_drv->remain_on_ch.pVoid = pstrHostIfRemainOnChan->pVoid;
-		hif_drv->remain_on_ch.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
+		hif_drv->remain_on_ch.expired = pstrHostIfRemainOnChan->expired;
 		hif_drv->remain_on_ch.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
 		hif_drv->remain_on_ch.ch = pstrHostIfRemainOnChan->ch;
 		hif_drv->remain_on_ch.u32ListenSessionID = pstrHostIfRemainOnChan->u32ListenSessionID;
@@ -2611,9 +2611,9 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 			goto _done_;
 		}
 
-		if (hif_drv->remain_on_ch.pRemainOnChanExpired) {
-			hif_drv->remain_on_ch.pRemainOnChanExpired(hif_drv->remain_on_ch.pVoid,
-								   pstrHostIfRemainOnChan->u32ListenSessionID);
+		if (hif_drv->remain_on_ch.expired) {
+			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.pVoid,
+						      pstrHostIfRemainOnChan->u32ListenSessionID);
 		}
 		P2P_LISTEN_STATE = 0;
 	} else {
@@ -4366,7 +4366,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.body.remain_on_ch.ch = chan;
-	msg.body.remain_on_ch.pRemainOnChanExpired = RemainOnChanExpired;
+	msg.body.remain_on_ch.expired = RemainOnChanExpired;
 	msg.body.remain_on_ch.pRemainOnChanReady = RemainOnChanReady;
 	msg.body.remain_on_ch.pVoid = pvUserArg;
 	msg.body.remain_on_ch.u32duration = u32duration;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index eea251a..58d3101 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -238,7 +238,7 @@ struct ba_session_info {
 struct remain_ch {
 	u16 ch;
 	u32 u32duration;
-	wilc_remain_on_chan_expired pRemainOnChanExpired;
+	wilc_remain_on_chan_expired expired;
 	wilc_remain_on_chan_ready pRemainOnChanReady;
 	void *pVoid;
 	u32 u32ListenSessionID;
-- 
1.9.1

