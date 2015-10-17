Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34915 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbJQKdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:20 -0400
Received: by wicll6 with SMTP id ll6so38837723wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/9] staging: vt6655: device_main Replace uIdx with idx.
Date: Sat, 17 Oct 2015 11:32:54 +0100
Message-Id: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123323_519979_8F236CA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 673ca47..0ed82a64 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -142,8 +142,8 @@ static void device_init_rd1_ring(struct vnt_private *priv);
 static void device_init_td0_ring(struct vnt_private *priv);
 static void device_init_td1_ring(struct vnt_private *priv);
 
-static int  device_rx_srv(struct vnt_private *priv, unsigned int uIdx);
-static int  device_tx_srv(struct vnt_private *priv, unsigned int uIdx);
+static int  device_rx_srv(struct vnt_private *priv, unsigned int idx);
+static int  device_tx_srv(struct vnt_private *priv, unsigned int idx);
 static bool device_alloc_rx_buf(struct vnt_private *, struct vnt_rx_desc *);
 static void device_init_registers(struct vnt_private *priv);
 static void device_free_tx_buf(struct vnt_private *, struct vnt_tx_desc *);
@@ -700,12 +700,12 @@ static void device_free_td1_ring(struct vnt_private *priv)
 
 /*-----------------------------------------------------------------*/
 
-static int device_rx_srv(struct vnt_private *priv, unsigned int uIdx)
+static int device_rx_srv(struct vnt_private *priv, unsigned int idx)
 {
 	struct vnt_rx_desc *rd;
 	int works = 0;
 
-	for (rd = priv->pCurrRD[uIdx];
+	for (rd = priv->pCurrRD[idx];
 	     rd->rd0.owner == OWNED_BY_HOST;
 	     rd = rd->next) {
 		if (works++ > 15)
@@ -724,7 +724,7 @@ static int device_rx_srv(struct vnt_private *priv, unsigned int uIdx)
 		rd->rd0.owner = OWNED_BY_NIC;
 	}
 
-	priv->pCurrRD[uIdx] = rd;
+	priv->pCurrRD[idx] = rd;
 
 	return works;
 }
@@ -829,14 +829,14 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 	return 0;
 }
 
-static int device_tx_srv(struct vnt_private *priv, unsigned int uIdx)
+static int device_tx_srv(struct vnt_private *priv, unsigned int idx)
 {
 	struct vnt_tx_desc *desc;
 	int                      works = 0;
 	unsigned char byTsr0;
 	unsigned char byTsr1;
 
-	for (desc = priv->apTailTD[uIdx]; priv->iTDUsed[uIdx] > 0; desc = desc->next) {
+	for (desc = priv->apTailTD[idx]; priv->iTDUsed[idx] > 0; desc = desc->next) {
 		if (desc->td0.owner == OWNED_BY_NIC)
 			break;
 		if (works++ > 15)
@@ -851,30 +851,30 @@ static int device_tx_srv(struct vnt_private *priv, unsigned int uIdx)
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
 						pr_debug(" Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X]\n",
-							 (int)uIdx, byTsr1,
+							 (int)idx, byTsr1,
 							 byTsr0);
 					}
 				} else {
 					pr_debug(" Tx[%d] dropped & tsr1[%02X] tsr0[%02X]\n",
-						 (int)uIdx, byTsr1, byTsr0);
+						 (int)idx, byTsr1, byTsr0);
 				}
 			}
 
 			if (byTsr1 & TSR1_TERR) {
 				if ((desc->td_info->flags & TD_FLAGS_PRIV_SKB) != 0) {
 					pr_debug(" Tx[%d] fail has error. tsr1[%02X] tsr0[%02X]\n",
-						 (int)uIdx, byTsr1, byTsr0);
+						 (int)idx, byTsr1, byTsr0);
 				}
 			}
 
 			vnt_int_report_rate(priv, desc->td_info, byTsr0, byTsr1);
 
 			device_free_tx_buf(priv, desc);
-			priv->iTDUsed[uIdx]--;
+			priv->iTDUsed[idx]--;
 		}
 	}
 
-	priv->apTailTD[uIdx] = desc;
+	priv->apTailTD[idx] = desc;
 
 	return works;
 }
-- 
2.5.0

