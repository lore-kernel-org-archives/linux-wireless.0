Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37019 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaEaKvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:44 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so2346760wiv.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/14] staging: vt6656: rename MACvDisableBarkerPreambleMd to vnt_mac_disable_barker_preamble_mode
Date: Sat, 31 May 2014 11:50:48 +0100
Message-Id: <1401533449-2972-13-git-send-email-tvboxspy@gmail.com> (sfid-20140531_132148_318306_A386AE73)
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
index 0a662e7..997a20e 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -975,7 +975,7 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pDevice->bBarkerPreambleMd = true;
 			}
 		} else if (pDevice->bBarkerPreambleMd) {
-				MACvDisableBarkerPreambleMd(pDevice);
+				vnt_mac_disable_barker_preamble_mode(pDevice);
 				pDevice->bBarkerPreambleMd = false;
 		}
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 94e9f95..3275ee9 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -219,7 +219,7 @@ void vnt_mac_enable_barker_preamble_mode(struct vnt_private *priv)
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
+void vnt_mac_disable_barker_preamble_mode(struct vnt_private *priv)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 9b0cac4..dfeacbf 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -426,7 +426,7 @@ void vnt_mac_set_bssid_addr(struct vnt_private *, u8 *);
 void vnt_mac_enable_protect_mode(struct vnt_private *);
 void vnt_mac_disable_protect_mode(struct vnt_private *);
 void vnt_mac_enable_barker_preamble_mode(struct vnt_private *);
-void MACvDisableBarkerPreambleMd(struct vnt_private *);
+void vnt_mac_disable_barker_preamble_mode(struct vnt_private *);
 void MACvWriteBeaconInterval(struct vnt_private *, u16);
 void vnt_mac_set_led(struct vnt_private *priv, u8, u8);
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 7a5f699..73c6e90 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1670,7 +1670,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                         if (pDevice->bBarkerPreambleMd) {
 			    vnt_mac_enable_barker_preamble_mode(pDevice);
                         } else {
-                            MACvDisableBarkerPreambleMd(pDevice);
+			    vnt_mac_disable_barker_preamble_mode(pDevice);
                         }
                     }
                 }
@@ -2034,7 +2034,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     vnt_mac_disable_protect_mode(pDevice);
 
     pDevice->bBarkerPreambleMd = 0;
-    MACvDisableBarkerPreambleMd(pDevice);
+    vnt_mac_disable_barker_preamble_mode(pDevice);
 
     // Kyle Test 2003.11.04
 
@@ -2402,7 +2402,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                     if (pDevice->bBarkerPreambleMd) {
 			vnt_mac_enable_barker_preamble_mode(pDevice);
                     } else {
-                        MACvDisableBarkerPreambleMd(pDevice);
+			vnt_mac_disable_barker_preamble_mode(pDevice);
                     }
                 }
             }
@@ -2567,7 +2567,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     pDevice->bProtectMode = false;
     vnt_mac_disable_protect_mode(pDevice);
     pDevice->bBarkerPreambleMd = false;
-    MACvDisableBarkerPreambleMd(pDevice);
+    vnt_mac_disable_barker_preamble_mode(pDevice);
     pDevice->bNonERPPresent = false;
     pDevice->byPreambleType = 0;
     pDevice->wBasicRate = 0;
-- 
1.9.1

