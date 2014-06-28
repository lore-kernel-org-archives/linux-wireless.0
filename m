Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:49980 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaF1W4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:30 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so6695437wes.38
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6656: remove vnt_add_basic_rate
Date: Sat, 28 Jun 2014 23:55:44 +0100
Message-Id: <1403996146-4082-6-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005639_524324_94BE349D)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver never sets basic rate any more so remove function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 22 ----------------------
 drivers/staging/vt6656/card.h     |  1 -
 drivers/staging/vt6656/main_usb.c |  7 ++-----
 3 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 2ef45ca..82d6b64 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -470,28 +470,6 @@ void vnt_update_top_rates(struct vnt_private *priv)
 	priv->byTopCCKBasicRate = top_cck;
  }
 
-/*
- * Description: Set NIC Tx Basic Rate
- *
- * Parameters:
- *  In:
- *      pDevice         - The adapter to be set
- *      wBasicRate      - Basic Rate to be set
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-void vnt_add_basic_rate(struct vnt_private *priv, u16 rate_idx)
-{
-
-	priv->wBasicRate |= (1 << rate_idx);
-
-	/*Determines the highest basic rate.*/
-	vnt_update_top_rates(priv);
-}
-
 int vnt_ofdm_min_rate(struct vnt_private *priv)
 {
 	int ii;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 8c6f67d..5b7cc5a 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -49,7 +49,6 @@ void vnt_set_channel(struct vnt_private *, u32);
 void vnt_set_rspinf(struct vnt_private *, u8);
 void vnt_update_ifs(struct vnt_private *);
 void vnt_update_top_rates(struct vnt_private *);
-void vnt_add_basic_rate(struct vnt_private *, u16);
 int vnt_ofdm_min_rate(struct vnt_private *);
 void vnt_adjust_tsf(struct vnt_private *, u8, u64, u64);
 bool vnt_get_current_tsf(struct vnt_private *, u64 *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a1d0c98..d8164ec 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -432,13 +432,10 @@ static int device_init_registers(struct vnt_private *pDevice)
 	* set BB and packet type at the same time
 	* set Short Slot Time, xIFS, and RSPINF
 	*/
-	if (pDevice->byBBType == BB_TYPE_11A) {
-		vnt_add_basic_rate(pDevice, RATE_6M);
+	if (pDevice->byBBType == BB_TYPE_11A)
 		pDevice->bShortSlotTime = true;
-	} else {
-		vnt_add_basic_rate(pDevice, RATE_1M);
+	else
 		pDevice->bShortSlotTime = false;
-	}
 
 	BBvSetShortSlotTime(pDevice);
 	vnt_set_bss_mode(pDevice);
-- 
1.9.1

