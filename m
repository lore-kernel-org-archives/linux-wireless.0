Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34284 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaE0UGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:12 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so9850165wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/10] staging: vt6656: rf.c/h rename RFbSetPower to vnt_rf_setpower
Date: Tue, 27 May 2014 21:05:21 +0100
Message-Id: <1401221126-4219-5-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220627_153329_2E6FA032)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c   | 2 +-
 drivers/staging/vt6656/rf.h   | 2 +-
 drivers/staging/vt6656/rxtx.c | 4 ++--
 drivers/staging/vt6656/wcmd.c | 3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index b30a373..c1e0a79 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -734,7 +734,7 @@ int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
  * Return Value: true if succeeded; false if failed.
  *
  */
-int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
+int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 {
 	int ret = true;
 	u8 power = priv->byCCKPwr;
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 70d5b82..e47b67d 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -58,7 +58,7 @@
 extern const u8 RFaby11aChannelIndex[200];
 
 int vnt_rf_write_embedded(struct vnt_private *, u32);
-int RFbSetPower(struct vnt_private *, u32 uRATE, u32 uCH);
+int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
 void RFbRFTableDownload(struct vnt_private *pDevice);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f11c2d3..704f4d3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1386,9 +1386,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	}
 
 	if (pMgmt->eScanState != WMAC_NO_SCANNING)
-		RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
+		vnt_rf_setpower(pDevice, wCurrentRate, pDevice->byCurrentCh);
 	else
-		RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
+		vnt_rf_setpower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
 
 	pDevice->wCurrentRate = wCurrentRate;
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 9a166fb..da72d4d 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -835,7 +835,8 @@ void vRunCommand(struct work_struct *work)
 
 	case WLAN_CMD_SETPOWER_START:
 
-		RFbSetPower(pDevice, pDevice->wCurrentRate, pMgmt->uCurrChannel);
+		vnt_rf_setpower(pDevice, pDevice->wCurrentRate,
+							pMgmt->uCurrChannel);
 
 		break;
 
-- 
1.9.1

