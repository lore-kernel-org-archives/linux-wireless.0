Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49914 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaE3WYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:09 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so2650089wgh.14
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6656: rename CARDbClearCurrentTSF to vnt_clear_current_tsf
Date: Fri, 30 May 2014 23:22:48 +0100
Message-Id: <1401488574-16508-2-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002414_770870_42A8FF2C)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_clear_current_tsf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/card.h | 2 +-
 drivers/staging/vt6656/wmgr.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index c746677..fdc7cd5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -633,7 +633,7 @@ bool vnt_get_current_tsf(struct vnt_private *priv, u64 *current_tsf)
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbClearCurrentTSF(struct vnt_private *priv)
+bool vnt_clear_current_tsf(struct vnt_private *priv)
 {
 
 	MACvRegBitsOn(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
@@ -694,7 +694,7 @@ void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
 	u64 next_tbtt = 0;
 	u8 data[8];
 
-	CARDbClearCurrentTSF(priv);
+	vnt_clear_current_tsf(priv);
 
 	next_tbtt = CARDqGetNextTBTT(next_tbtt, beacon_interval);
 
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 89bbc70..78ff810 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -53,7 +53,7 @@ void vnt_add_basic_rate(struct vnt_private *, u16);
 int vnt_ofdm_min_rate(struct vnt_private *);
 void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
 bool vnt_get_current_tsf(struct vnt_private *, u64 *);
-bool CARDbClearCurrentTSF(struct vnt_private *pDevice);
+bool vnt_clear_current_tsf(struct vnt_private *);
 void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval);
 void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
 			 u16 wBeaconInterval);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 55b92fe..5b2e9e5 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2046,7 +2046,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 
     vnt_get_current_tsf(pDevice, &qwCurrTSF);
     // clear TSF counter
-    CARDbClearCurrentTSF(pDevice);
+    vnt_clear_current_tsf(pDevice);
 
     // enable TSF counter
     MACvRegBitsOn(pDevice,MAC_REG_TFTCTL,TFTCTL_TSFCNTREN);
-- 
1.9.1

