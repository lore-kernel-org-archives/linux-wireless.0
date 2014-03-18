Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60174 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbaCRT0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi5so4158900wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/14] staging: vt6656: rxtx Replace wCTSTxRrvTime_ba
Date: Tue, 18 Mar 2014 19:25:00 +0000
Message-Id: <1395170708-2990-6-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202624_818852_6AF76FF3)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with cts_rrv_time_ba with __le16 base.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fb8b2fc9..69afabc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -852,7 +852,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 				PK_TYPE_11B, cbFrameSize,
 					pDevice->byTopCCKBasicRate, bNeedACK);
 
-			pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
+			pBuf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 					byPktType, cbFrameSize, wCurrentRate);
 
 			if (need_mic) {
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 2f65a6f..bbb571a 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -62,7 +62,7 @@ struct vnt_rrv_time_rts {
 } __packed;
 
 struct vnt_rrv_time_cts {
-	u16 wCTSTxRrvTime_ba;
+	__le16 cts_rrv_time_ba;
 	u16 wReserved;
 	__le16 rrv_time_b;
 	__le16 rrv_time_a;
-- 
1.9.0

