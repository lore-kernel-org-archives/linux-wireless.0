Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58072 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3KYWSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 17:18:43 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so4315082wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 14:18:42 -0800 (PST)
Message-ID: <1385417911.6327.4.camel@canaries32-MCP7A> (sfid-20131125_231847_404740_20949DB0)
Subject: [PATCH 2/2] staging: vt6656: Remove unused variable bAES.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 25 Nov 2013 22:18:31 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bAES flips from false to true but doesn't do anything.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 --
 drivers/staging/vt6656/rxtx.c   | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9a4dfbc..82e1e6d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -667,8 +667,6 @@ struct vnt_private {
 	u8 abyPRNG[WLAN_WEPMAX_KEYLEN+3];
 	u8 byKeyIndex;
 
-	int bAES;
-
 	u32 uKeyLength;
 	u8 abyKey[WLAN_WEP232_KEYLEN];
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index aa71d39..cc23029 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1462,7 +1462,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     // Notes:
     // Although spec says MMPDU can be fragmented; In most case,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
-    pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
     if (WLAN_GET_FC_ISWEP(pPacket->p80211Header->sA4.wFrameCtl) != 0) {
         if (pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) {
@@ -1483,7 +1482,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
             cbIVlen = 8;//RSN Header
             cbICVlen = 8;//MIC
             pTxBufHead->wFragCtl |= FRAGCTL_AES;
-            pDevice->bAES = true;
         }
         //MAC Header should be padding 0 to DW alignment.
         uPadding = 4 - (cbMacHdLen%4);
@@ -1858,7 +1856,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     // Notes:
     // Although spec says MMPDU can be fragmented; In most case,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
-    pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
     if (WLAN_GET_FC_ISWEP(p80211Header->sA4.wFrameCtl) != 0) {
         if (pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) {
@@ -1880,7 +1877,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
             cbICVlen = 8;//MIC
 	    cbMICHDR = sizeof(struct vnt_mic_hdr);
             pTxBufHead->wFragCtl |= FRAGCTL_AES;
-            pDevice->bAES = true;
         }
         //MAC Header should be padding 0 to DW alignment.
         uPadding = 4 - (cbMacHdLen%4);
-- 
1.8.4.4

