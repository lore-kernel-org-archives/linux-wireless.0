Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:44299 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaE3P2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:32 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so2225297wes.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/12] staging: vt6656: rename CARDvCalculateOFDMRParameter to vnt_calculate_ofdm_rate
Date: Fri, 30 May 2014 16:27:43 +0100
Message-Id: <1401463671-4705-4-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172837_082879_362E449A)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and Parameter. R is the rate to rename to vnt_calculate_ofdm_rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 695236b..9c88134 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -197,7 +197,7 @@ static u16 vnt_get_ofdm_rate(struct vnt_private *priv, u16 rate_idx)
  * Return Value: none
  *
  */
-static void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
+static void vnt_calculate_ofdm_rate(u16 rate, u8 bb_type,
 					u8 *tx_rate, u8 *rsv_time)
 {
 
@@ -317,39 +317,34 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 
 
 	/*RSPINF_a_6*/
-	CARDvCalculateOFDMRParameter(RATE_6M, bb_type,
-						&tx_rate[0], &rsv_time[0]);
+	vnt_calculate_ofdm_rate(RATE_6M, bb_type, &tx_rate[0], &rsv_time[0]);
 
 	/*RSPINF_a_9*/
-	CARDvCalculateOFDMRParameter(RATE_9M, bb_type,
-						&tx_rate[1], &rsv_time[1]);
+	vnt_calculate_ofdm_rate(RATE_9M, bb_type, &tx_rate[1], &rsv_time[1]);
 
 	/*RSPINF_a_12*/
-	CARDvCalculateOFDMRParameter(RATE_12M, bb_type,
-						&tx_rate[2], &rsv_time[2]);
+	vnt_calculate_ofdm_rate(RATE_12M, bb_type, &tx_rate[2], &rsv_time[2]);
 
 	/*RSPINF_a_18*/
-	CARDvCalculateOFDMRParameter(RATE_18M, bb_type,
-						&tx_rate[3], &rsv_time[3]);
+	vnt_calculate_ofdm_rate(RATE_18M, bb_type, &tx_rate[3], &rsv_time[3]);
 
 	/*RSPINF_a_24*/
-	CARDvCalculateOFDMRParameter(RATE_24M, bb_type,
-						&tx_rate[4], &rsv_time[4]);
+	vnt_calculate_ofdm_rate(RATE_24M, bb_type, &tx_rate[4], &rsv_time[4]);
 
 	/*RSPINF_a_36*/
-	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_36M),
+	vnt_calculate_ofdm_rate(vnt_get_ofdm_rate(priv, RATE_36M),
 					bb_type, &tx_rate[5], &rsv_time[5]);
 
 	/*RSPINF_a_48*/
-	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_48M),
+	vnt_calculate_ofdm_rate(vnt_get_ofdm_rate(priv, RATE_48M),
 					bb_type, &tx_rate[6], &rsv_time[6]);
 
 	/*RSPINF_a_54*/
-	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_54M),
+	vnt_calculate_ofdm_rate(vnt_get_ofdm_rate(priv, RATE_54M),
 					bb_type, &tx_rate[7], &rsv_time[7]);
 
 	/*RSPINF_a_72*/
-	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_54M),
+	vnt_calculate_ofdm_rate(vnt_get_ofdm_rate(priv, RATE_54M),
 					bb_type, &tx_rate[8], &rsv_time[8]);
 
 	put_unaligned(phy[0].len, (u16 *)&data[0]);
-- 
1.9.1

