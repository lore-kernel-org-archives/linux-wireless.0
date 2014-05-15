Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53607 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaEOVvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:51 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so11731wiw.8
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 10/15] staging: vt6656: lock changes: usbpipe.c add mutex lock.
Date: Thu, 15 May 2014 22:49:19 +0100
Message-Id: <1400190564-5135-10-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235155_248073_25D71165)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PIPEnsControlOut and PIPEnsControlIn are nolonger
atomic but they do need a usb lock.

Add new mutex lock for these functions and PIPEnsControlOutAsyn.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  1 +
 drivers/staging/vt6656/main_usb.c |  2 ++
 drivers/staging/vt6656/usbpipe.c  | 16 ++++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f36a2eb..622cf02 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -363,6 +363,7 @@ struct vnt_private {
 	u8 byRxMode;
 
 	spinlock_t lock;
+	struct mutex usb_lock;
 
 	u32 rx_bytes;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e99d2a9..14e649a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -695,6 +695,8 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	device_set_options(pDevice);
 	spin_lock_init(&pDevice->lock);
+	mutex_init(&pDevice->usb_lock);
+
 	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
 	INIT_DELAYED_WORK(&pDevice->second_callback_work, BSSvSecondCallBack);
 	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 836da00..934d0a9 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -82,6 +82,8 @@ int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
         return STATUS_FAILURE;
     }
 
+	mutex_lock(&pDevice->usb_lock);
+
     ntStatus = usb_control_msg(
                             pDevice->usb,
                             usb_sndctrlpipe(pDevice->usb , 0),
@@ -100,6 +102,8 @@ int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"usb_sndctrlpipe fail, ntStatus= %d\n", ntStatus);
     }
 
+	mutex_unlock(&pDevice->usb_lock);
+
     return ntStatus;
 }
 
@@ -123,6 +127,8 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 	if (pDevice->pControlURB->hcpriv)
 		return STATUS_FAILURE;
 
+	mutex_lock(&pDevice->usb_lock);
+
 	MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
 
 	pDevice->sUsbCtlRequest.bRequestType = 0x40;
@@ -143,6 +149,7 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 			"control send request submission failed: %d\n",
 				ntStatus);
 		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
+		mutex_unlock(&pDevice->usb_lock);
 		return STATUS_FAILURE;
 	}
 
@@ -157,10 +164,13 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO "control send request submission timeout\n");
             MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
+	    mutex_unlock(&pDevice->usb_lock);
             return STATUS_FAILURE;
         }
     }
 
+	mutex_unlock(&pDevice->usb_lock);
+
     return STATUS_SUCCESS;
 }
 
@@ -184,6 +194,8 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 	if (pDevice->pControlURB->hcpriv)
 		return STATUS_FAILURE;
 
+	mutex_lock(&pDevice->usb_lock);
+
 	MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
 
 	pDevice->sUsbCtlRequest.bRequestType = 0xC0;
@@ -202,6 +214,7 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"control request submission failed: %d\n", ntStatus);
 		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
+		mutex_unlock(&pDevice->usb_lock);
 		return STATUS_FAILURE;
 	}
 
@@ -216,10 +229,13 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		DBG_PRT(MSG_LEVEL_DEBUG,
 			KERN_INFO "control rcv request submission timeout\n");
             MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
+	    mutex_unlock(&pDevice->usb_lock);
             return STATUS_FAILURE;
         }
     }
 
+	mutex_unlock(&pDevice->usb_lock);
+
     return ntStatus;
 }
 
-- 
1.9.1

