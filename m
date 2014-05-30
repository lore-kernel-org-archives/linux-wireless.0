Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41558 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3P22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:28 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so2129355wgh.15
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/12] staging: vt6656: rename swGetCCKControlRate to vnt_get_cck_rate
Date: Fri, 30 May 2014 16:27:41 +0100
Message-Id: <1401463671-4705-2-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172833_064552_12467A16)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop control and just use vnt_get_cck_rate.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index f8ba75b..b2dc8a8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -128,7 +128,7 @@ void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
  * Return Value: response Control frame rate
  *
  */
-static u16 swGetCCKControlRate(struct vnt_private *priv, u16 rate_idx)
+static u16 vnt_get_cck_rate(struct vnt_private *priv, u16 rate_idx)
 {
 	u16 ui = rate_idx;
 
@@ -301,19 +301,19 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 
 	/*RSPINF_b_1*/
 	BBvCalculateParameter(priv, 14,
-		swGetCCKControlRate(priv, RATE_1M), PK_TYPE_11B, &phy[0]);
+		vnt_get_cck_rate(priv, RATE_1M), PK_TYPE_11B, &phy[0]);
 
 	/*RSPINF_b_2*/
 	BBvCalculateParameter(priv, 14,
-		swGetCCKControlRate(priv, RATE_2M), PK_TYPE_11B, &phy[1]);
+		vnt_get_cck_rate(priv, RATE_2M), PK_TYPE_11B, &phy[1]);
 
 	/*RSPINF_b_5*/
 	BBvCalculateParameter(priv, 14,
-		swGetCCKControlRate(priv, RATE_5M), PK_TYPE_11B, &phy[2]);
+		vnt_get_cck_rate(priv, RATE_5M), PK_TYPE_11B, &phy[2]);
 
 	/*RSPINF_b_11*/
 	BBvCalculateParameter(priv, 14,
-		swGetCCKControlRate(priv, RATE_11M), PK_TYPE_11B, &phy[3]);
+		vnt_get_cck_rate(priv, RATE_11M), PK_TYPE_11B, &phy[3]);
 
 
 	/*RSPINF_a_6*/
-- 
1.9.1

