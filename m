Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40106 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECOT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:19:56 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so306264wiv.7
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/13] staging: vt6656: lock changes: bMgrPrepareBeaconToSend add lock.
Date: Sat,  3 May 2014 15:17:27 +0100
Message-Id: <1399126654-2663-6-git-send-email-tvboxspy@gmail.com> (sfid-20140503_162001_064149_2AB19B60)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
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

