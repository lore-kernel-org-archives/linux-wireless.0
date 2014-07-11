Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49351 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaGKAJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:30 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so293504wgg.24
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/13] staging: vt6656: clean up and rename wFB_Opt1 to vnt_fb_opt1
Date: Fri, 11 Jul 2014 01:08:27 +0100
Message-Id: <1405037311-3666-9-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020934_554794_B64902D7)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 6ca2638..582bc1f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -62,10 +62,10 @@ static const u16 vnt_fb_opt0[2][5] = {
 	{RATE_12M, RATE_12M, RATE_18M, RATE_24M, RATE_36M}, /* fallback_rate1 */
 };
 
-static const u16 wFB_Opt1[2][5] = {
-        {RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, // fallback_rate0
-        {RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, // fallback_rate1
-    };
+static const u16 vnt_fb_opt1[2][5] = {
+	{RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, /* fallback_rate0 */
+	{RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, /* fallback_rate1 */
+};
 
 #define RTSDUR_BB       0
 #define RTSDUR_BA       1
@@ -933,9 +933,9 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
 
 			priv->tx_rate_fb0 =
-				wFB_Opt1[FB_RATE0][current_rate - RATE_18M];
+				vnt_fb_opt1[FB_RATE0][current_rate - RATE_18M];
 			priv->tx_rate_fb1 =
-				wFB_Opt1[FB_RATE1][current_rate - RATE_18M];
+				vnt_fb_opt1[FB_RATE1][current_rate - RATE_18M];
 
 			fb_option = AUTO_FB_1;
 		}
-- 
1.9.1

