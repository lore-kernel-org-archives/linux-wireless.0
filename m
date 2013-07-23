Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38094 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab3GWWLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 18:11:07 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so514471wes.34
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 15:11:05 -0700 (PDT)
Message-ID: <1374617459.2750.9.camel@canaries64> (sfid-20130724_001111_147898_BB9DAEFF)
Subject: [PATCH 2/2] staging: vt6656: remove dead code
 DBG_PORT80/VIAWET_DEBUG
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Jul 2013 23:10:59 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


DBG_PORT80 is always defined as empty macro
because VIAWET_DEBUG is never defined. Remove
it and VIAWET_DEBUG.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/device_cfg.h | 6 ------
 drivers/staging/vt6656/wmgr.c       | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index ad1fbf6..a97f7bb 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -82,10 +82,4 @@ typedef enum  _chip_type {
     VT3184 = 1
 } CHIP_TYPE, *PCHIP_TYPE;
 
-#ifdef VIAWET_DEBUG
-#define DBG_PORT80(value)                   outb(value, 0x80)
-#else
-#define DBG_PORT80(value)
-#endif
-
 #endif
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 6d1ff5e..b6cbd13 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -751,7 +751,6 @@ static void s_vMgrRxAssocResponse(struct vnt_private *pDevice,
 	    || (sFrame.pwStatus == NULL)
 	    || (sFrame.pwAid == NULL)
 	    || (sFrame.pSuppRates == NULL)) {
-		DBG_PORT80(0xCC);
 		return;
         }
 
@@ -3750,7 +3749,6 @@ static void s_vMgrRxProbeResponse(struct vnt_private *pDevice,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe resp:Fail addr:[%p]\n",
 		pRxPacket->p80211Header);
-	DBG_PORT80(0xCC);
 	return;
     }
 
-- 
1.8.1.2



