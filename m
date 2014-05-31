Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54702 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaEaKvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:45 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so2390790wib.6
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/14] staging: vt6656: rename MACvWriteBeaconInterval to vnt_mac_set_beacon_interval
Date: Sat, 31 May 2014 11:50:49 +0100
Message-Id: <1401533449-2972-14-git-send-email-tvboxspy@gmail.com> (sfid-20140531_132148_011304_EE20F0B9)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop write for set

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c  | 2 +-
 drivers/staging/vt6656/mac.h  | 2 +-
 drivers/staging/vt6656/wmgr.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 3275ee9..b06436f 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -230,7 +230,7 @@ void vnt_mac_disable_barker_preamble_mode(struct vnt_private *priv)
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteBeaconInterval(struct vnt_private *priv, u16 interval)
+void vnt_mac_set_beacon_interval(struct vnt_private *priv, u16 interval)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index dfeacbf..eac2be7 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -427,7 +427,7 @@ void vnt_mac_enable_protect_mode(struct vnt_private *);
 void vnt_mac_disable_protect_mode(struct vnt_private *);
 void vnt_mac_enable_barker_preamble_mode(struct vnt_private *);
 void vnt_mac_disable_barker_preamble_mode(struct vnt_private *);
-void MACvWriteBeaconInterval(struct vnt_private *, u16);
+void vnt_mac_set_beacon_interval(struct vnt_private *, u16);
 void vnt_mac_set_led(struct vnt_private *priv, u8, u8);
 
 #endif /* __MAC_H__ */
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 73c6e90..a1b5307 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1915,7 +1915,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                      // set HW beacon interval and re-synchronizing....
                      DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Rejoining to Other Adhoc group with same SSID........\n");
 
-                     MACvWriteBeaconInterval(pDevice, pMgmt->wCurrBeaconPeriod);
+		     vnt_mac_set_beacon_interval(pDevice, pMgmt->wCurrBeaconPeriod);
 		     vnt_adjust_tsf(pDevice, pRxPacket->byRxRate, qwTimestamp, pRxPacket->qwLocalTSF);
 		     vnt_update_next_tbtt(pDevice, qwTimestamp, pMgmt->wCurrBeaconPeriod);
 
@@ -2041,7 +2041,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     // set HW beacon interval
     if (pMgmt->wIBSSBeaconPeriod == 0)
         pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
-    MACvWriteBeaconInterval(pDevice, pMgmt->wIBSSBeaconPeriod);
+    vnt_mac_set_beacon_interval(pDevice, pMgmt->wIBSSBeaconPeriod);
 
     vnt_get_current_tsf(pDevice, &qwCurrTSF);
     // clear TSF counter
@@ -2579,7 +2579,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     vnt_adjust_tsf(pDevice, pCurr->byRxRate, pCurr->qwBSSTimestamp, pCurr->qwLocalTSF);
 
     // set HW beacon interval
-    MACvWriteBeaconInterval(pDevice, pCurr->wBeaconInterval);
+    vnt_mac_set_beacon_interval(pDevice, pCurr->wBeaconInterval);
 
     // set Next TBTT
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-- 
1.9.1

