Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35515 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbJCTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:46 -0400
Received: by wicge5 with SMTP id ge5so72165594wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: device_tx_srv rename pTD
Date: Sat,  3 Oct 2015 20:30:27 +0100
Message-Id: <1443900627-2924-6-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213051_354927_CD1CEACD)
In-Reply-To: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
References: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the convention elsewhere for vnt_tx_desc rename
desc.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ff329bd..673ca47 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -831,23 +831,23 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 
 static int device_tx_srv(struct vnt_private *priv, unsigned int uIdx)
 {
-	struct vnt_tx_desc *pTD;
+	struct vnt_tx_desc *desc;
 	int                      works = 0;
 	unsigned char byTsr0;
 	unsigned char byTsr1;
 
-	for (pTD = priv->apTailTD[uIdx]; priv->iTDUsed[uIdx] > 0; pTD = pTD->next) {
-		if (pTD->td0.owner == OWNED_BY_NIC)
+	for (desc = priv->apTailTD[uIdx]; priv->iTDUsed[uIdx] > 0; desc = desc->next) {
+		if (desc->td0.owner == OWNED_BY_NIC)
 			break;
 		if (works++ > 15)
 			break;
 
-		byTsr0 = pTD->td0.tsr0;
-		byTsr1 = pTD->td0.tsr1;
+		byTsr0 = desc->td0.tsr0;
+		byTsr1 = desc->td0.tsr1;
 
 		/* Only the status of first TD in the chain is correct */
-		if (pTD->td1.tcr & TCR_STP) {
-			if ((pTD->td_info->flags & TD_FLAGS_NETIF_SKB) != 0) {
+		if (desc->td1.tcr & TCR_STP) {
+			if ((desc->td_info->flags & TD_FLAGS_NETIF_SKB) != 0) {
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
 						pr_debug(" Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X]\n",
@@ -861,20 +861,20 @@ static int device_tx_srv(struct vnt_private *priv, unsigned int uIdx)
 			}
 
 			if (byTsr1 & TSR1_TERR) {
-				if ((pTD->td_info->flags & TD_FLAGS_PRIV_SKB) != 0) {
+				if ((desc->td_info->flags & TD_FLAGS_PRIV_SKB) != 0) {
 					pr_debug(" Tx[%d] fail has error. tsr1[%02X] tsr0[%02X]\n",
 						 (int)uIdx, byTsr1, byTsr0);
 				}
 			}
 
-			vnt_int_report_rate(priv, pTD->td_info, byTsr0, byTsr1);
+			vnt_int_report_rate(priv, desc->td_info, byTsr0, byTsr1);
 
-			device_free_tx_buf(priv, pTD);
+			device_free_tx_buf(priv, desc);
 			priv->iTDUsed[uIdx]--;
 		}
 	}
 
-	priv->apTailTD[uIdx] = pTD;
+	priv->apTailTD[uIdx] = desc;
 
 	return works;
 }
-- 
2.5.0

