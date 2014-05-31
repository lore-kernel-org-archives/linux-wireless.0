Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51977 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaEaKva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:30 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so2332659wib.17
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/14] staging: vt6656: rename MACvDisableKeyEntry to vnt_mac_disable_keyentry
Date: Sat, 31 May 2014 11:50:39 +0100
Message-Id: <1401533449-2972-4-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125137_223123_ADE0ECDC)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    | 2 +-
 drivers/staging/vt6656/key.c      | 1 -
 drivers/staging/vt6656/mac.c      | 2 +-
 drivers/staging/vt6656/mac.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/wpactl.c   | 2 +-
 6 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index c43718d..b45af4a 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1224,7 +1224,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 			for (uu = 0; uu < MAX_KEY_TABLE; uu++)
-				MACvDisableKeyEntry(pDevice, uu);
+				vnt_mac_disable_keyentry(pDevice, uu);
 		}
 	}
 	if (wrq->flags & IW_ENCODE_RESTRICTED) {
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 38ea675..4b08654 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -64,7 +64,6 @@ static void s_vCheckKeyTableValid(struct vnt_private *pDevice,
             pTable->KeyTable[i].wKeyCtl = 0;
             pTable->KeyTable[i].bSoftWEP = false;
             pbyData[wLength++] = (u8) i;
-            //MACvDisableKeyEntry(pDevice, i);
         }
     }
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 136c263..fe6b4ac 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -99,7 +99,7 @@ void vnt_mac_set_bb_type(struct vnt_private *priv, u8 type)
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
+void vnt_mac_disable_keyentry(struct vnt_private *priv, u8 entry_idx)
 {
 	vnt_control_out(priv, MESSAGE_TYPE_CLRKEYENTRY, 0, 0,
 		sizeof(entry_idx), &entry_idx);
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index ac3d794..a808794 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -417,7 +417,7 @@ struct vnt_mac_set_key {
 void vnt_mac_set_filter(struct vnt_private *, u64);
 void vnt_mac_shutdown(struct vnt_private *);
 void vnt_mac_set_bb_type(struct vnt_private *, u8);
-void MACvDisableKeyEntry(struct vnt_private *, u8);
+void vnt_mac_disable_keyentry(struct vnt_private *, u8);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 11738dc..fea667f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1000,7 +1000,7 @@ static int device_close(struct net_device *dev)
         pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
 	for (uu = 0; uu < MAX_KEY_TABLE; uu++)
-                MACvDisableKeyEntry(pDevice,uu);
+		vnt_mac_disable_keyentry(pDevice, uu);
 
 	if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == false)
 		vnt_mac_shutdown(pDevice);
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 0a06715..2b508be 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -80,7 +80,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx)
 		pDevice->byKeyIndex = 0;
 		pDevice->bTransmitKey = false;
 		for (uu=0; uu<MAX_KEY_TABLE; uu++) {
-			MACvDisableKeyEntry(pDevice, uu);
+			vnt_mac_disable_keyentry(pDevice, uu);
 		}
 		return ret;
 	}
-- 
1.9.1

