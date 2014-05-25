Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:47580 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYUiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:19 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so7205565wes.35
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging; vt6656: swGetCCKControlRate remove camel case
Date: Sun, 25 May 2014 21:36:23 +0100
Message-Id: <1401050189-3249-2-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223823_717044_854ACF89)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wRateIdx -> rate_idx

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index f025010..c162ce4 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -123,20 +123,20 @@ void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
- *      wRateIdx            - Receiving data rate
+ *      priv		- The adapter to be set
+ *      rate_idx	- Receiving data rate
  *  Out:
  *      none
  *
  * Return Value: response Control frame rate
  *
  */
-static u16 swGetCCKControlRate(struct vnt_private *pDevice, u16 wRateIdx)
+static u16 swGetCCKControlRate(struct vnt_private *priv, u16 rate_idx)
 {
-	u16 ui = wRateIdx;
+	u16 ui = rate_idx;
 
 	while (ui > RATE_1M) {
-		if (pDevice->wBasicRate & (1 << ui))
+		if (priv->wBasicRate & (1 << ui))
 			return ui;
 		ui--;
 	}
-- 
1.9.1

