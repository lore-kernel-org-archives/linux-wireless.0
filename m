Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35928 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbaGSLbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:19 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so4530756wgg.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/16] staging: vt6656: struct vnt_private rename uCurrRSSI to current_rssi
Date: Sat, 19 Jul 2014 12:30:14 +0100
Message-Id: <1405769418-2815-12-git-send-email-tvboxspy@gmail.com> (sfid-20140719_135108_028257_FA81722D)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 +-
 drivers/staging/vt6656/dpc.c    | 2 +-
 drivers/staging/vt6656/rf.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7697a73..7c81105 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -314,7 +314,7 @@ struct vnt_private {
 	u64 current_tsf;
 
 	/* 802.11 MAC specific */
-	u32 uCurrRSSI;
+	u32 current_rssi;
 
 	/* Antenna Diversity */
 	int bTxRxAntInv;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 5d4c2c1..f8410ce1 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -153,7 +153,7 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 	vnt_rf_rssi_to_dbm(priv, *rssi, &rx_dbm);
 
 	priv->byBBPreEDRSSI = (u8)rx_dbm + 1;
-	priv->uCurrRSSI = priv->byBBPreEDRSSI;
+	priv->current_rssi = priv->byBBPreEDRSSI;
 
 	frame = skb_data + 8;
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index c98cf60..3815db9 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -660,7 +660,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 
 static u8 vnt_rf_addpower(struct vnt_private *priv)
 {
-	s32 rssi = -priv->uCurrRSSI;
+	s32 rssi = -priv->current_rssi;
 
 	if (!rssi)
 		return 7;
-- 
2.0.1

