Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:56323 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:47 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so1745132wes.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 08/15] staging: vt6656: lock changes: bMgrPrepareBeaconToSend add lock.
Date: Thu, 15 May 2014 22:49:17 +0100
Message-Id: <1400190564-5135-8-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235150_789021_ED53733D)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bMgrPrepareBeaconToSend is nolonger atomic

csBeacon_xmit must be locked add spin lock.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wmgr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 0d69719..cce67cd 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -4058,6 +4058,7 @@ int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
 	struct vnt_manager *pMgmt)
 {
 	struct vnt_tx_mgmt *pTxPacket;
+	unsigned long flags;
 
 //    pDevice->bBeaconBufReady = false;
     if (pDevice->bEncryptionEnable || pDevice->bEnable8021x){
@@ -4084,8 +4085,13 @@ int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
         (pMgmt->abyCurrBSSID[0] == 0))
         return false;
 
-    csBeacon_xmit(pDevice, pTxPacket);
-    MACvRegBitsOn(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+	spin_lock_irqsave(&pDevice->lock, flags);
+
+	csBeacon_xmit(pDevice, pTxPacket);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
+	MACvRegBitsOn(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
 
     return true;
 }
-- 
1.9.1

