Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33923 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaEWRBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:07 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so5161059wgg.24
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/20] staging: vt6656: MACvDisableKeyEntry fix sizeof uEntryIdx to u8
Date: Fri, 23 May 2014 18:00:03 +0100
Message-Id: <1400864419-8327-4-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190112_372024_0244E0DD)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove byData and change all callers to u8.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |  2 +-
 drivers/staging/vt6656/mac.c      | 10 +++-------
 drivers/staging/vt6656/mac.h      |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/wpactl.c   |  2 +-
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index de2ae1d..3edeb2f 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1150,7 +1150,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 	struct iw_point *wrq = &wrqu->encoding;
 	u32 dwKeyIndex = (u32)(wrq->flags & IW_ENCODE_INDEX);
 	int ii;
-	int uu;
+	u8 uu;
 	int rc = 0;
 	int index = (wrq->flags & IW_ENCODE_INDEX);
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 0e14aab..a341eab 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -102,19 +102,15 @@ void MACvSetBBType(struct vnt_private *priv, u8 type)
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(struct vnt_private *pDevice, u32 uEntryIdx)
+void MACvDisableKeyEntry(struct vnt_private *pDevice, u8 uEntryIdx)
 {
-	u8 byData;
-
-    byData = (u8) uEntryIdx;
-
     //issue write misc fifo command to device
     CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_CLRKEYENTRY,
                         0,
                         0,
-                        1,
-                        &byData
+			sizeof(uEntryIdx),
+			&uEntryIdx
                         );
 }
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 4053e43..2084d4b 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -406,7 +406,7 @@
 void MACvWriteMultiAddr(struct vnt_private *, u64);
 void MACbShutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
-void MACvDisableKeyEntry(struct vnt_private *, u32);
+void MACvDisableKeyEntry(struct vnt_private *, u8);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u32 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 09e444d..ed04804 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -984,7 +984,7 @@ static int device_close(struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	int uu;
+	u8 uu;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close1\n");
     if (pDevice == NULL)
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index b6885a9..587e111 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -66,7 +66,7 @@ int wpa_set_keys(struct vnt_private *pDevice, void *ctx)
 	u64 KeyRSC;
 	u8 byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
-	int uu;
+	u8 uu;
 	int ii;
 
 	if (param->u.wpa_key.alg_name > WPA_ALG_CCMP)
-- 
1.9.1

