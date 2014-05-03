Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50268 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaECOTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:19:54 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so3636652wib.4
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/13] staging: vt6656: lock changes: vDMA0_tx_80211
Date: Sat,  3 May 2014 15:17:26 +0100
Message-Id: <1399126654-2663-5-git-send-email-tvboxspy@gmail.com> (sfid-20140503_161959_240355_E9A06F2E)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
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
index 185b1ea..ff77f20 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1784,11 +1784,11 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
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

