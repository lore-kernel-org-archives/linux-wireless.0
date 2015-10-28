Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41799 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbbJ1G7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:14 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/80] staging: wilc1000: rename u8RemainOnChan_pendingreq of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:36 +0900
Message-ID: <1446015640-29398-16-git-send-email-glen.lee@atmel.com> (sfid-20151028_081655_523443_0042CB24)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8RemainOnChan_pendingreq of struct host_if_drv to
remain_on_ch_pending to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dd09152..5a2cae2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2476,7 +2476,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
 
-	if (!hif_drv->u8RemainOnChan_pendingreq) {
+	if (!hif_drv->remain_on_ch_pending) {
 		hif_drv->remain_on_ch.pVoid = pstrHostIfRemainOnChan->pVoid;
 		hif_drv->remain_on_ch.pRemainOnChanExpired = pstrHostIfRemainOnChan->pRemainOnChanExpired;
 		hif_drv->remain_on_ch.pRemainOnChanReady = pstrHostIfRemainOnChan->pRemainOnChanReady;
@@ -2488,7 +2488,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 
 	if (hif_drv->usr_scan_req.pfUserScanResult) {
 		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
-		hif_drv->u8RemainOnChan_pendingreq = 1;
+		hif_drv->remain_on_ch_pending = 1;
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
@@ -2535,8 +2535,8 @@ ERRORHANDLER:
 		if (hif_drv->remain_on_ch.pRemainOnChanReady)
 			hif_drv->remain_on_ch.pRemainOnChanReady(hif_drv->remain_on_ch.pVoid);
 
-		if (hif_drv->u8RemainOnChan_pendingreq)
-			hif_drv->u8RemainOnChan_pendingreq = 0;
+		if (hif_drv->remain_on_ch_pending)
+			hif_drv->remain_on_ch_pending = 0;
 	}
 
 	return result;
@@ -2886,7 +2886,7 @@ static int hostIFthread(void *pvArg)
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
-			if (hif_drv->u8RemainOnChan_pendingreq)
+			if (hif_drv->remain_on_ch_pending)
 				Handle_RemainOnChan(msg.drv, &msg.body.remain_on_ch);
 
 			break;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ea47a0d..8f80497 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -295,7 +295,7 @@ struct host_if_drv {
 	struct user_scan_req usr_scan_req;
 	struct user_conn_req usr_conn_req;
 	struct remain_ch remain_on_ch;
-	u8 u8RemainOnChan_pendingreq;
+	u8 remain_on_ch_pending;
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
 
-- 
1.9.1

