Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41211 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaEQIxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:16 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so5816017wgh.17
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/22] staging: vt6656: Remove unused variable byACKRate.
Date: Sat, 17 May 2014 09:50:35 +0100
Message-Id: <1400316639-4430-18-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112147_783308_BDF17812)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 1 -
 drivers/staging/vt6656/rxtx.c   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index eff50c8..73bce9e 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -535,7 +535,6 @@ struct vnt_private {
 	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
 	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u16 wBasicRate;
-	u8 byACKRate;
 	u8 byTopOFDMBasicRate;
 	u8 byTopCCKBasicRate;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7287467..4ec79c4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2341,12 +2341,10 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 	if (pDevice->sTxEthHeader.h_proto == cpu_to_be16(ETH_P_PAE)) {
 		if (pDevice->byBBType != BB_TYPE_11A) {
 			pDevice->wCurrentRate = RATE_1M;
-			pDevice->byACKRate = RATE_1M;
 			pDevice->byTopCCKBasicRate = RATE_1M;
 			pDevice->byTopOFDMBasicRate = RATE_6M;
 		} else {
 			pDevice->wCurrentRate = RATE_6M;
-			pDevice->byACKRate = RATE_6M;
 			pDevice->byTopCCKBasicRate = RATE_1M;
 			pDevice->byTopOFDMBasicRate = RATE_6M;
 		}
-- 
1.9.1

