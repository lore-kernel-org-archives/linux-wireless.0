Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35151 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaEaKvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:41 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so3026984wgh.15
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/14] staging: vt6656: rename MACvDisableProtectMD to vnt_mac_disable_protect_mode
Date: Sat, 31 May 2014 11:50:46 +0100
Message-Id: <1401533449-2972-11-git-send-email-tvboxspy@gmail.com> (sfid-20140531_132147_675496_29AB24E2)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c | 2 +-
 drivers/staging/vt6656/mac.c   | 2 +-
 drivers/staging/vt6656/mac.h   | 2 +-
 drivers/staging/vt6656/wmgr.c  | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index e335a4d..093b583 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -950,7 +950,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pDevice->bProtectMode = true;
 			}
 		} else if (pDevice->bProtectMode) {
-			MACvDisableProtectMD(pDevice);
+			vnt_mac_disable_protect_mode(pDevice);
 			pDevice->bProtectMode = false;
 		}
 		/* on/off short slot time */
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 1319b8a..96fff70 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -197,7 +197,7 @@ void vnt_mac_enable_protect_mode(struct vnt_private *priv)
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableProtectMD(struct vnt_private *priv)
+void vnt_mac_disable_protect_mode(struct vnt_private *priv)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index fa3cfc2..effab75 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -424,7 +424,7 @@ void vnt_mac_reg_bits_on(struct vnt_private *, u8, u8);
 void vnt_mac_write_word(struct vnt_private *, u8, u16);
 void vnt_mac_set_bssid_addr(struct vnt_private *, u8 *);
 void vnt_mac_enable_protect_mode(struct vnt_private *);
-void MACvDisableProtectMD(struct vnt_private *);
+void vnt_mac_disable_protect_mode(struct vnt_private *);
 void MACvEnableBarkerPreambleMd(struct vnt_private *);
 void MACvDisableBarkerPreambleMd(struct vnt_private *);
 void MACvWriteBeaconInterval(struct vnt_private *, u16);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index bb1242c..f35fdd8 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1657,7 +1657,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                         if (pDevice->bProtectMode) {
 			    vnt_mac_enable_protect_mode(pDevice);
                         } else {
-                            MACvDisableProtectMD(pDevice);
+			    vnt_mac_disable_protect_mode(pDevice);
                         }
 			vnt_update_ifs(pDevice);
                     }
@@ -2031,7 +2031,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 
     // Disable Protect Mode
     pDevice->bProtectMode = 0;
-    MACvDisableProtectMD(pDevice);
+    vnt_mac_disable_protect_mode(pDevice);
 
     pDevice->bBarkerPreambleMd = 0;
     MACvDisableBarkerPreambleMd(pDevice);
@@ -2389,7 +2389,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                     if (pDevice->bProtectMode) {
 			vnt_mac_enable_protect_mode(pDevice);
                     } else {
-                        MACvDisableProtectMD(pDevice);
+			vnt_mac_disable_protect_mode(pDevice);
                     }
 		    vnt_update_ifs(pDevice);
                 }
@@ -2565,7 +2565,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
 
     // Init the BSS informations
     pDevice->bProtectMode = false;
-    MACvDisableProtectMD(pDevice);
+    vnt_mac_disable_protect_mode(pDevice);
     pDevice->bBarkerPreambleMd = false;
     MACvDisableBarkerPreambleMd(pDevice);
     pDevice->bNonERPPresent = false;
-- 
1.9.1

