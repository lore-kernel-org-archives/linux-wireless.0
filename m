Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:34190 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaCVJCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:38 -0400
Received: by mail-we0-f169.google.com with SMTP id w62so2221966wes.28
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/10] staging: vt6656: rxtx s_vFillCTSHead replace TYPE_CTL_CTS macro
Date: Sat, 22 Mar 2014 09:01:32 +0000
Message-Id: <1395478892-3419-10-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100244_431978_F0CABE3F)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS from linux/ieee80211.h
to get value of TYPE_CTL_CTS and endian correct to frame_control.

Remove old macros in tether.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c   | 8 ++++++--
 drivers/staging/vt6656/tether.h | 2 --
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ac60999..1ff1446 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -742,7 +742,9 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 			pDevice->tx_rate_fb1, bNeedAck, byFBOption);
 		/* Get CTS Frame body */
 		pBuf->data.duration = pBuf->duration_ba;
-		pBuf->data.frame_control = TYPE_CTL_CTS;
+		pBuf->data.frame_control =
+			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g_fb(pDevice, byPktType, wCurrentRate,
@@ -758,7 +760,9 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 			wCurrentRate, bNeedAck, byFBOption);
 		/*Get CTS Frame body*/
 		pBuf->data.duration = pBuf->duration_ba;
-		pBuf->data.frame_control = TYPE_CTL_CTS;
+		pBuf->data.frame_control =
+			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g(pDevice, byPktType, wCurrentRate,
diff --git a/drivers/staging/vt6656/tether.h b/drivers/staging/vt6656/tether.h
index f42edda..f57fcfdc 100644
--- a/drivers/staging/vt6656/tether.h
+++ b/drivers/staging/vt6656/tether.h
@@ -60,7 +60,6 @@
 #define TYPE_DATE_NULL      0x4800
 
 #define TYPE_CTL_PSPOLL     0xa400
-#define TYPE_CTL_CTS        0xc400
 #define TYPE_CTL_ACK        0xd400
 
 #else //if LITTLE_ENDIAN
@@ -90,7 +89,6 @@
 #define TYPE_DATE_NULL      0x0048
 
 #define TYPE_CTL_PSPOLL     0x00a4
-#define TYPE_CTL_CTS        0x00c4
 #define TYPE_CTL_ACK        0x00d4
 
 #endif //#ifdef __BIG_ENDIAN
-- 
1.9.0

