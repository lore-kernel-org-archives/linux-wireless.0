Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57188 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:37 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so15720wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 03/15] staging: vt6656: lock changes: Remove spin locks.
Date: Thu, 15 May 2014 22:49:12 +0100
Message-Id: <1400190564-5135-3-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235141_184037_A83B4025)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove atomic paths to usbpipe.c PIPEnsControlOut and PIPEnsControlIn

Remove from
PIPEnsControlOut
PIPEnsControlIn
BSSvSecondCallBack
vt6656_hostap_ioctl
iwctl_siwmode
iwctl_siwencode
iwctl_siwpower
iwctl_siwencodeext
KeyvInitTable
device_init_registers
device_open
device_close

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    |  4 ----
 drivers/staging/vt6656/firmware.c |  2 +-
 drivers/staging/vt6656/hostap.c   |  4 ++--
 drivers/staging/vt6656/iwctl.c    | 15 ---------------
 drivers/staging/vt6656/key.c      |  3 ---
 drivers/staging/vt6656/main_usb.c | 27 ++++-----------------------
 drivers/staging/vt6656/usbpipe.c  |  6 ------
 7 files changed, 7 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 9c78dab..b018955 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -818,8 +818,6 @@ void BSSvSecondCallBack(struct work_struct *work)
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
 
-	spin_lock_irq(&pDevice->lock);
-
 	pDevice->uAssocCount = 0;
 
 	/* Power Saving Mode Tx Burst */
@@ -1158,8 +1156,6 @@ void BSSvSecondCallBack(struct work_struct *work)
 			netif_wake_queue(pDevice->dev);
 	}
 
-	spin_unlock_irq(&pDevice->lock);
-
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 }
 
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index afb79c6..7a4a972 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -44,7 +44,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 #define FIRMWARE_CHUNK_SIZE	0x400
 
-int FIRMWAREbDownload(struct vnt_private *pDevice) __must_hold(&pDevice->lock)
+int FIRMWAREbDownload(struct vnt_private *pDevice)
 {
 	struct device *dev = &pDevice->usb->dev;
 	const struct firmware *fw;
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index a0d9fff..2a5b7c8 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -698,9 +698,9 @@ int vt6656_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 	switch (param->cmd) {
 	case VIAWGET_HOSTAPD_SET_ENCRYPTION:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ENCRYPTION \n");
-        spin_lock_irq(&pDevice->lock);
+
 		ret = hostap_set_encryption(pDevice, param, p->length);
-        spin_unlock_irq(&pDevice->lock);
+
 		break;
 	case VIAWGET_HOSTAPD_GET_ENCRYPTION:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_GET_ENCRYPTION \n");
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index cf4c06a..bfd5f37 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -441,8 +441,6 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"Commit the settings\n");
 
-			spin_lock_irq(&pDevice->lock);
-
 			if (pDevice->bLinkPass &&
 				memcmp(pMgmt->abyCurrSSID,
 					pMgmt->abyDesireSSID,
@@ -471,8 +469,6 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 			bScheduleCommand((void *) pDevice,
 				 WLAN_CMD_SSID,
 				 NULL);
-
-			spin_unlock_irq(&pDevice->lock);
 		}
 		pDevice->bCommit = false;
 	}
@@ -1212,14 +1208,12 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
 
 		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-			spin_lock_irq(&pDevice->lock);
 			KeybSetDefaultKey(pDevice,
 					&(pDevice->sKey),
 					dwKeyIndex | (1 << 31),
 					wrq->length, NULL,
 					pDevice->abyKey,
 					KEY_CTL_WEP);
-			spin_unlock_irq(&pDevice->lock);
 		}
 		pDevice->byKeyIndex = (u8)dwKeyIndex;
 		pDevice->uKeyLength = wrq->length;
@@ -1242,10 +1236,8 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		pDevice->bEncryptionEnable = false;
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-			spin_lock_irq(&pDevice->lock);
 			for (uu = 0; uu < MAX_KEY_TABLE; uu++)
 				MACvDisableKeyEntry(pDevice, uu);
-			spin_unlock_irq(&pDevice->lock);
 		}
 	}
 	if (wrq->flags & IW_ENCODE_RESTRICTED) {
@@ -1342,12 +1334,9 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 
-	spin_lock_irq(&pDevice->lock);
-
 	if (wrq->disabled) {
 		pDevice->ePSMode = WMAC_POWER_CAM;
 		PSvDisablePowerSaving(pDevice);
-		spin_unlock_irq(&pDevice->lock);
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
@@ -1359,8 +1348,6 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
 
-	spin_unlock_irq(&pDevice->lock);
-
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R\n");
@@ -1723,9 +1710,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		KeyvInitTable(pDevice, &pDevice->sKey);
 	}
 /*******/
-	spin_lock_irq(&pDevice->lock);
 	ret = wpa_set_keys(pDevice, param);
-	spin_unlock_irq(&pDevice->lock);
 
 error:
 	kfree(buf);
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index be92c04..b173ca1 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -97,7 +97,6 @@ void KeyvInitTable(struct vnt_private *pDevice, PSKeyManagement pTable)
 	int i, jj;
 	u8 pbyData[MAX_KEY_TABLE+1];
 
-    spin_lock_irq(&pDevice->lock);
     for (i=0;i<MAX_KEY_TABLE;i++) {
         pTable->KeyTable[i].bInUse = false;
         pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
@@ -122,8 +121,6 @@ void KeyvInitTable(struct vnt_private *pDevice, PSKeyManagement pTable)
                         pbyData
                         );
 
-    spin_unlock_irq(&pDevice->lock);
-
     return;
 }
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ea0d6b3..e99d2a9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -312,22 +312,15 @@ static int device_init_registers(struct vnt_private *pDevice)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
 				DEVICE_INIT_COLD, pDevice->byPacketType);
 
-	spin_lock_irq(&pDevice->lock);
-
 	memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
 	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
 	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
 
 	if (!FIRMWAREbCheckVersion(pDevice)) {
-
-		spin_unlock_irq(&pDevice->lock);
 		if (FIRMWAREbDownload(pDevice) == true) {
-
-			spin_lock_irq(&pDevice->lock);
 			if (FIRMWAREbBrach2Sram(pDevice) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 					" FIRMWAREbBrach2Sram fail\n");
-				spin_unlock_irq(&pDevice->lock);
 				return false;
 			}
 		} else {
@@ -339,7 +332,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	if (!BBbVT3184Init(pDevice)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" BBbVT3184Init fail\n");
-		spin_unlock_irq(&pDevice->lock);
 		return false;
 	}
 
@@ -356,7 +348,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
 	if (ntStatus != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail\n");
-		spin_unlock_irq(&pDevice->lock);
 		return false;
 	}
 
@@ -365,7 +356,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	if (ntStatus != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Cardinit request in status fail!\n");
-		spin_unlock_irq(&pDevice->lock);
 		return false;
 	}
 
@@ -373,10 +363,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
 		MAC_REG_LOCALID, MESSAGE_REQUEST_MACREG, 1,
 			&pDevice->byLocalID);
-	if (ntStatus != STATUS_SUCCESS) {
-		spin_unlock_irq(&pDevice->lock);
+	if (ntStatus != STATUS_SUCCESS)
 		return false;
-	}
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
@@ -607,10 +595,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 		ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
 			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &byTmp);
 
-		if (ntStatus != STATUS_SUCCESS) {
-			spin_unlock_irq(&pDevice->lock);
+		if (ntStatus != STATUS_SUCCESS)
 			return false;
-		}
 
 		if ((byTmp & GPIO3_DATA) == 0) {
 			pDevice->bHWRadioOff = true;
@@ -637,9 +623,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		CARDbRadioPowerOn(pDevice);
 	}
 
-
-	spin_unlock_irq(&pDevice->lock);
-
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
 
 	return true;
@@ -1028,7 +1011,6 @@ static int  device_open(struct net_device *dev)
 
     /* if WEP key already set by iwconfig but device not yet open */
     if ((pDevice->bEncryptionEnable == true) && (pDevice->bTransmitKey == true)) {
-         spin_lock_irq(&pDevice->lock);
          KeybSetDefaultKey( pDevice,
                             &(pDevice->sKey),
                             pDevice->byKeyIndex | (1 << 31),
@@ -1037,7 +1019,7 @@ static int  device_open(struct net_device *dev)
                             pDevice->abyKey,
                             KEY_CTL_WEP
                           );
-         spin_unlock_irq(&pDevice->lock);
+
          pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
     }
 
@@ -1084,10 +1066,9 @@ static int device_close(struct net_device *dev)
         pMgmt->bShareKeyAlgorithm = false;
         pDevice->bEncryptionEnable = false;
         pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-	spin_lock_irq(&pDevice->lock);
+
 	for (uu = 0; uu < MAX_KEY_TABLE; uu++)
                 MACvDisableKeyEntry(pDevice,uu);
-	spin_unlock_irq(&pDevice->lock);
 
     if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == false) {
         MACbShutdown(pDevice);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1a6f911..836da00 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -146,7 +146,6 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		return STATUS_FAILURE;
 	}
 
-	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
 
 	if (pDevice->Flags & fMP_CONTROL_WRITES)
@@ -157,12 +156,10 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
         if (ii >= USB_CTL_WAIT) {
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO "control send request submission timeout\n");
-            spin_lock_irq(&pDevice->lock);
             MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
             return STATUS_FAILURE;
         }
     }
-	spin_lock_irq(&pDevice->lock);
 
     return STATUS_SUCCESS;
 }
@@ -208,7 +205,6 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		return STATUS_FAILURE;
 	}
 
-	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
 
 	if (pDevice->Flags & fMP_CONTROL_READS)
@@ -219,12 +215,10 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 	if (ii >= USB_CTL_WAIT) {
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO "control rcv request submission timeout\n");
-            spin_lock_irq(&pDevice->lock);
             MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
             return STATUS_FAILURE;
         }
     }
-	spin_lock_irq(&pDevice->lock);
 
     return ntStatus;
 }
-- 
1.9.1

