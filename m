Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62034 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaEXNiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:10 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so5932465wgh.11
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/14] staging: vt6656: CARDbGetCurrentTSF remove camel case
Date: Sat, 24 May 2014 14:37:02 +0100
Message-Id: <1400938630-2850-6-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153837_466067_A34A6786)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv
pqwCurrTSF -> current_tsf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 4b0b3ef..b904b20 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -615,17 +615,17 @@ void CARDvAdjustTSF(struct vnt_private *priv, u8 rx_rate,
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be read
+ *	priv		- The adapter to be read
  *  Out:
- *      qwCurrTSF       - Current TSF counter
+ *	current_tsf	- Current TSF counter
  *
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF)
+bool CARDbGetCurrentTSF(struct vnt_private *priv, u64 *current_tsf)
 {
 
-	*pqwCurrTSF = pDevice->qwCurrTSF;
+	*current_tsf = priv->qwCurrTSF;
 
 	return true;
 }
-- 
1.9.1

