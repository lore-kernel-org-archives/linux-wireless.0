Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45996 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KXO4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:56:38 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so1161155wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:56:37 -0800 (PST)
Message-ID: <1353768969.2318.17.camel@user64-MCP7A> (sfid-20121124_155641_403290_637682C0)
Subject: [PATCH 10/10] staging: vt6656: wpa_set_keys remove fcpfkernel
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:56:09 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Only TRUE is ever called, remove FALSE code.

Since copy_from_user has been removed, the unlock..lock spin locks have been removed.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c  |    2 +-
 drivers/staging/vt6656/wpactl.c |   28 +++-------------------------
 drivers/staging/vt6656/wpactl.h |    2 +-
 3 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 2cd8b0a..52fce69 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1724,7 +1724,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	}
 /*******/
 	spin_lock_irq(&pDevice->lock);
-	ret = wpa_set_keys(pDevice, param, TRUE);
+	ret = wpa_set_keys(pDevice, param);
 	spin_unlock_irq(&pDevice->lock);
 
 error:
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 4fe2e60..cc1d48b 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -67,7 +67,7 @@ static int msglevel = MSG_LEVEL_INFO;
  * Return Value:
  *
  */
- int wpa_set_keys(PSDevice pDevice, void *ctx, BOOL  fcpfkernel)
+int wpa_set_keys(PSDevice pDevice, void *ctx)
 {
 	struct viawget_wpa_param *param = ctx;
 	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
@@ -99,18 +99,7 @@ static int msglevel = MSG_LEVEL_INFO;
 	if (param->u.wpa_key.key && param->u.wpa_key.key_len > sizeof(abyKey))
 		return -EINVAL;
 
-	spin_unlock_irq(&pDevice->lock);
-	if (param->u.wpa_key.key && fcpfkernel) {
-		memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
-	} else {
-		if (param->u.wpa_key.key &&
-			copy_from_user(&abyKey[0], param->u.wpa_key.key,
-				param->u.wpa_key.key_len)) {
-			spin_lock_irq(&pDevice->lock);
-			return -EINVAL;
-		}
-	}
-	spin_lock_irq(&pDevice->lock);
+	memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
 
 	dwKeyIndex = (DWORD)(param->u.wpa_key.key_index);
 
@@ -142,18 +131,7 @@ static int msglevel = MSG_LEVEL_INFO;
 	if (param->u.wpa_key.seq && param->u.wpa_key.seq_len > sizeof(abySeq))
 		return -EINVAL;
 
-	spin_unlock_irq(&pDevice->lock);
-        if (param->u.wpa_key.seq && fcpfkernel) {
-		memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
-	} else {
-		if (param->u.wpa_key.seq &&
-			copy_from_user(&abySeq[0], param->u.wpa_key.seq,
-				param->u.wpa_key.seq_len)) {
-			spin_lock_irq(&pDevice->lock);
-			return -EINVAL;
-		}
-	}
-	spin_lock_irq(&pDevice->lock);
+	memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
 
 	if (param->u.wpa_key.seq_len > 0) {
 		for (ii = 0 ; ii < param->u.wpa_key.seq_len ; ii++) {
diff --git a/drivers/staging/vt6656/wpactl.h b/drivers/staging/vt6656/wpactl.h
index 14dcf0b..b4ec6b0 100644
--- a/drivers/staging/vt6656/wpactl.h
+++ b/drivers/staging/vt6656/wpactl.h
@@ -52,6 +52,6 @@ typedef unsigned long long NDIS_802_11_KEY_RSC;
 
 /*---------------------  Export Functions  --------------------------*/
 
-int wpa_set_keys(PSDevice pDevice, void *ctx, BOOL  fcpfkernel);
+int wpa_set_keys(PSDevice pDevice, void *ctx);
 
 #endif /* __WPACL_H__ */
-- 
1.7.10.4



