Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57522 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:15 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so6238059wgg.33
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/14] staging: vt6656: rxtx: Replace wCTSDuration*
Date: Tue, 18 Mar 2014 19:24:59 +0000
Message-Id: <1395170708-2990-5-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202621_767074_FC268191)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wCTSDuration* -> cts_duration*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 4 ++--
 drivers/staging/vt6656/rxtx.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9846c90..fb8b2fc9 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -732,11 +732,11 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 			cbFrameLength, byPktType,
 			wCurrentRate, bNeedAck, byFBOption);
 		/* Get CTSDuration_ba_f0 */
-		pBuf->wCTSDuration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
+		pBuf->cts_duration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA_F0, cbFrameLength, byPktType,
 			pDevice->tx_rate_fb0, bNeedAck, byFBOption);
 		/* Get CTSDuration_ba_f1 */
-		pBuf->wCTSDuration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
+		pBuf->cts_duration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA_F1, cbFrameLength, byPktType,
 			pDevice->tx_rate_fb1, bNeedAck, byFBOption);
 		/* Get CTS Frame body */
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index f0ab2a3..2f65a6f 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -167,8 +167,8 @@ struct vnt_cts_fb {
 	struct vnt_phy_field b;
 	__le16 duration_ba;
 	u16 wReserved;
-	u16 wCTSDuration_ba_f0;
-	u16 wCTSDuration_ba_f1;
+	__le16 cts_duration_ba_f0;
+	__le16 cts_duration_ba_f1;
 	struct ieee80211_cts data;
 	u16 reserved2;
 	struct vnt_tx_datahead_g_fb data_head;
-- 
1.9.0

