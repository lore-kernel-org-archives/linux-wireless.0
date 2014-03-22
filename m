Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:41496 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVJC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:27 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so2217250wes.29
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/10] staging: vt6656: rxtx: s_vFillTxKey fix pMACHeader sparse warning
Date: Sat, 22 Mar 2014 09:01:26 +0000
Message-Id: <1395478892-3419-4-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100231_681276_BE60A9B2)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endian convert __le16 pMACHeader->frame_control and pMACHeader->seq_ctrl
back to cpu.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 43e13e2..9706e18 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -282,9 +282,10 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 
 		/* MICHDR2 */
 		memcpy(mic_hdr->addr3, pMACHeader->addr3, ETH_ALEN);
-		mic_hdr->frame_control = cpu_to_le16(pMACHeader->frame_control
-								& 0xc78f);
-		mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->seq_ctrl & 0xf);
+		mic_hdr->frame_control = cpu_to_le16(
+			le16_to_cpu(pMACHeader->frame_control) & 0xc78f);
+		mic_hdr->seq_ctrl = cpu_to_le16(
+				le16_to_cpu(pMACHeader->seq_ctrl) & 0xf);
 
 		if (ieee80211_has_a4(pMACHeader->frame_control))
 			memcpy(mic_hdr->addr4, pMACHeader->addr4, ETH_ALEN);
-- 
1.9.0

