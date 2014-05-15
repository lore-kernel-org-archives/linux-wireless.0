Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61885 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:45 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so4137342wgg.12
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 07/15] staging: vt6656: lock changes: vDMA0_tx_80211
Date: Thu, 15 May 2014 22:49:16 +0100
Message-Id: <1400190564-5135-7-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235149_343572_BD7FFBE3)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vDMA0_tx_80211 is atomically called.

RFbSetPower can not be called atomically.

If wCurrentRate is different to pDevice->wCurrentRate call
bScheduleCommand WLAN_CMD_SETPOWER.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c6ac263..7287467 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1781,11 +1781,11 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
     //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
     //                    to set power here.
-    if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-        RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-    } else {
-        RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-    }
+	if (wCurrentRate != pDevice->wCurrentRate) {
+		pDevice->wCurrentRate = wCurrentRate;
+
+		bScheduleCommand(pDevice, WLAN_CMD_SETPOWER, NULL);
+	}
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vDMA0_tx_80211: p80211Header->sA3.wFrameCtl = %x \n", p80211Header->sA3.wFrameCtl);
 
-- 
1.9.1

