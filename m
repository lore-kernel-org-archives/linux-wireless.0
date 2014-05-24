Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61741 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXNiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:13 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2114284wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/14] staging: vt6656: CARDbClearCurrentTSF remove camel case
Date: Sat, 24 May 2014 14:37:03 +0100
Message-Id: <1400938630-2850-7-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153825_407596_635C2911)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index b904b20..bb06f59 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -636,17 +636,17 @@ bool CARDbGetCurrentTSF(struct vnt_private *priv, u64 *current_tsf)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be read
+ *      priv	- The adapter to be read
  *
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbClearCurrentTSF(struct vnt_private *pDevice)
+bool CARDbClearCurrentTSF(struct vnt_private *priv)
 {
 
-	MACvRegBitsOn(pDevice, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	MACvRegBitsOn(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 
-	pDevice->qwCurrTSF = 0;
+	priv->qwCurrTSF = 0;
 
 	return true;
 }
-- 
1.9.1

