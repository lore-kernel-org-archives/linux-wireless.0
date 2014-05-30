Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60235 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410AbaE3WYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:10 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so2589483wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6656: rename CARDqGetNextTBTT to vnt_get_next_tbtt
Date: Fri, 30 May 2014 23:22:49 +0100
Message-Id: <1401488574-16508-3-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002417_779307_CE6AF21B)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_get_next_tbtt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 8 ++++----
 drivers/staging/vt6656/card.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index fdc7cd5..ee013a3 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -30,7 +30,7 @@
  *      CARDbSoftwareReset - Sortware reset NIC
  *      vnt_get_tsf_offset - Calculate TSFOffset
  *      vnt_get_current_tsf - Read Current NIC TSF counter
- *      CARDqGetNextTBTT - Calculate Next Beacon TSF counter
+ *      vnt_get_next_tbtt - Calculate Next Beacon TSF counter
  *      CARDvSetFirstNextTBTT - Set NIC Beacon time
  *      CARDvUpdateNextTBTT - Sync. NIC Beacon time
  *      CARDbRadioPowerOff - Turn Off NIC Radio Power
@@ -657,7 +657,7 @@ bool vnt_clear_current_tsf(struct vnt_private *priv)
  * Return Value: TSF value of next Beacon
  *
  */
-u64 CARDqGetNextTBTT(u64 tsf, u16 beacon_interval)
+u64 vnt_get_next_tbtt(u64 tsf, u16 beacon_interval)
 {
 	u32 beacon_int;
 
@@ -696,7 +696,7 @@ void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
 
 	vnt_clear_current_tsf(priv);
 
-	next_tbtt = CARDqGetNextTBTT(next_tbtt, beacon_interval);
+	next_tbtt = vnt_get_next_tbtt(next_tbtt, beacon_interval);
 
 	data[0] = (u8)next_tbtt;
 	data[1] = (u8)(next_tbtt >> 8);
@@ -733,7 +733,7 @@ void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
 {
 	u8 data[8];
 
-	tsf = CARDqGetNextTBTT(tsf, beacon_interval);
+	tsf = vnt_get_next_tbtt(tsf, beacon_interval);
 
 	data[0] = (u8)tsf;
 	data[1] = (u8)(tsf >> 8);
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 78ff810..d39a0a5 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -57,7 +57,7 @@ bool vnt_clear_current_tsf(struct vnt_private *);
 void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
 void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
 			 u16 wBeaconInterval);
-u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval);
+u64 vnt_get_next_tbtt(u64, u16);
 u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int CARDbRadioPowerOff(struct vnt_private *pDevice);
 int CARDbRadioPowerOn(struct vnt_private *pDevice);
-- 
1.9.1

