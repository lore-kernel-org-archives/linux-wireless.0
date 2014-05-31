Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:60391 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbaEaKvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:39 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so3046919wes.6
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/14] staging: vt6656: rename MACvEnableProtectMD to vnt_mac_enable_protect_mode
Date: Sat, 31 May 2014 11:50:45 +0100
Message-Id: <1401533449-2972-10-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125146_416208_E1E8AE41)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 2 +-
 drivers/staging/vt6656/mac.c   | 2 +-
 drivers/staging/vt6656/mac.h   | 2 +-
 drivers/staging/vt6656/wmgr.c  | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index fd7ed1d..e335a4d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -946,7 +946,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 		/* on/off protect mode */
 		if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
 			if (!pDevice->bProtectMode) {
-				MACvEnableProtectMD(pDevice);
+				vnt_mac_enable_protect_mode(pDevice);
 				pDevice->bProtectMode = true;
 			}
 		} else if (pDevice->bProtectMode) {
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 1811d5f..1319b8a 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -186,7 +186,7 @@ void vnt_mac_set_bssid_addr(struct vnt_private *priv, u8 *addr)
 		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
-void MACvEnableProtectMD(struct vnt_private *priv)
+void vnt_mac_enable_protect_mode(struct vnt_private *priv)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index d2a4407..fa3cfc2 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -423,7 +423,7 @@ void vnt_mac_reg_bits_off(struct vnt_private *, u8, u8);
 void vnt_mac_reg_bits_on(struct vnt_private *, u8, u8);
 void vnt_mac_write_word(struct vnt_private *, u8, u16);
 void vnt_mac_set_bssid_addr(struct vnt_private *, u8 *);
-void MACvEnableProtectMD(struct vnt_private *);
+void vnt_mac_enable_protect_mode(struct vnt_private *);
 void MACvDisableProtectMD(struct vnt_private *);
 void MACvEnableBarkerPreambleMd(struct vnt_private *);
 void MACvDisableBarkerPreambleMd(struct vnt_private *);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 0ed7cef..bb1242c 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1655,7 +1655,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                     if ((pBSSList->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION) != pDevice->bProtectMode) {//0000 0010
                         pDevice->bProtectMode = (pBSSList->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION);
                         if (pDevice->bProtectMode) {
-                            MACvEnableProtectMD(pDevice);
+			    vnt_mac_enable_protect_mode(pDevice);
                         } else {
                             MACvDisableProtectMD(pDevice);
                         }
@@ -2387,7 +2387,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                 if ((pCurr->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION) != pDevice->bProtectMode) {//0000 0010
                     pDevice->bProtectMode = (pCurr->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION);
                     if (pDevice->bProtectMode) {
-                        MACvEnableProtectMD(pDevice);
+			vnt_mac_enable_protect_mode(pDevice);
                     } else {
                         MACvDisableProtectMD(pDevice);
                     }
-- 
1.9.1

