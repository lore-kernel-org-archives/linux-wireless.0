Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35158 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaEaKvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:38 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2274098wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/14] staging: vt6656: rename MACvWriteBSSIDAddress to vnt_mac_set_bssid_addr
Date: Sat, 31 May 2014 11:50:44 +0100
Message-Id: <1401533449-2972-9-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125143_352164_07ACC9A6)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop write for set and shorten address.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c  | 2 +-
 drivers/staging/vt6656/mac.h  | 2 +-
 drivers/staging/vt6656/wmgr.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index d0c3bd3..1811d5f 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -180,7 +180,7 @@ void vnt_mac_write_word(struct vnt_private *priv, u8 reg_ofs, u16 word)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
+void vnt_mac_set_bssid_addr(struct vnt_private *priv, u8 *addr)
 {
 	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_BSSID0,
 		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index fa59131..d2a4407 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -422,7 +422,7 @@ void vnt_mac_set_keyentry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void vnt_mac_reg_bits_off(struct vnt_private *, u8, u8);
 void vnt_mac_reg_bits_on(struct vnt_private *, u8, u8);
 void vnt_mac_write_word(struct vnt_private *, u8, u16);
-void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
+void vnt_mac_set_bssid_addr(struct vnt_private *, u8 *);
 void MACvEnableProtectMD(struct vnt_private *);
 void MACvDisableProtectMD(struct vnt_private *);
 void MACvEnableBarkerPreambleMd(struct vnt_private *);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 66548ff..0ed7cef 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1920,7 +1920,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
 		     vnt_update_next_tbtt(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
 
                      // Turn off bssid filter to avoid filter others adhoc station which bssid is different.
-                     MACvWriteBSSIDAddress(pDevice, pMgmt->abyCurrBSSID);
+		    vnt_mac_set_bssid_addr(pDevice, pMgmt->abyCurrBSSID);
 
                     byOldPreambleType = pDevice->byPreambleType;
                     if (WLAN_GET_CAP_INFO_SHORTPREAMBLE(*sFrame.pwCapInfo)) {
@@ -2139,7 +2139,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     }
 
     // set BSSID filter
-    MACvWriteBSSIDAddress(pDevice, pMgmt->abyCurrBSSID);
+    vnt_mac_set_bssid_addr(pDevice, pMgmt->abyCurrBSSID);
     memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
 
     vnt_mac_reg_bits_on(pDevice, MAC_REG_RCR, RCR_BSSID);
@@ -2586,7 +2586,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     vnt_reset_next_tbtt(pDevice, pCurr->wBeaconInterval);
 
     // set BSSID
-    MACvWriteBSSIDAddress(pDevice, pCurr->abyBSSID);
+    vnt_mac_set_bssid_addr(pDevice, pCurr->abyBSSID);
 
     memcpy(pMgmt->abyCurrBSSID, pCurr->abyBSSID, 6);
 
-- 
1.9.1

