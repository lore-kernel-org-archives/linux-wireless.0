Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:47332 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaE3P2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:30 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so2219714wes.32
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/12] staging: vt6656: rename swGetOFDMControlRate to vnt_get_ofdm_rate
Date: Fri, 30 May 2014 16:27:42 +0100
Message-Id: <1401463671-4705-3-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172834_817274_F0C10961)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop control and rename vnt_get_ofdm_rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index b2dc8a8..695236b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -154,7 +154,7 @@ static u16 vnt_get_cck_rate(struct vnt_private *priv, u16 rate_idx)
  * Return Value: response Control frame rate
  *
  */
-static u16 swGetOFDMControlRate(struct vnt_private *priv, u16 rate_idx)
+static u16 vnt_get_ofdm_rate(struct vnt_private *priv, u16 rate_idx)
 {
 	u16 ui = rate_idx;
 
@@ -337,19 +337,19 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 						&tx_rate[4], &rsv_time[4]);
 
 	/*RSPINF_a_36*/
-	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_36M),
+	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_36M),
 					bb_type, &tx_rate[5], &rsv_time[5]);
 
 	/*RSPINF_a_48*/
-	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_48M),
+	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_48M),
 					bb_type, &tx_rate[6], &rsv_time[6]);
 
 	/*RSPINF_a_54*/
-	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_54M),
+	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_54M),
 					bb_type, &tx_rate[7], &rsv_time[7]);
 
 	/*RSPINF_a_72*/
-	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_54M),
+	CARDvCalculateOFDMRParameter(vnt_get_ofdm_rate(priv, RATE_54M),
 					bb_type, &tx_rate[8], &rsv_time[8]);
 
 	put_unaligned(phy[0].len, (u16 *)&data[0]);
-- 
1.9.1

