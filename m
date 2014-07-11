Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:45948 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaGKAJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:28 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so7873wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/13] staging: vt6656: clean up and rename wFB_Opt0 to vnt_fb_opt0
Date: Fri, 11 Jul 2014 01:08:26 +0100
Message-Id: <1405037311-3666-8-git-send-email-tvboxspy@gmail.com> (sfid-20140711_022952_162344_E73271F9)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7faef28..6ca2638 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -57,10 +57,11 @@ static const u16 vnt_time_stampoff[2][MAX_RATE] = {
 	{384, 192, 130, 113, 54, 43, 37, 31, 28, 25, 24, 23},/* Short Preamble */
 };
 
-static const u16 wFB_Opt0[2][5] = {
-        {RATE_12M, RATE_18M, RATE_24M, RATE_36M, RATE_48M}, // fallback_rate0
-        {RATE_12M, RATE_12M, RATE_18M, RATE_24M, RATE_36M}, // fallback_rate1
-    };
+static const u16 vnt_fb_opt0[2][5] = {
+	{RATE_12M, RATE_18M, RATE_24M, RATE_36M, RATE_48M}, /* fallback_rate0 */
+	{RATE_12M, RATE_12M, RATE_18M, RATE_24M, RATE_36M}, /* fallback_rate1 */
+};
+
 static const u16 wFB_Opt1[2][5] = {
         {RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, // fallback_rate0
         {RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, // fallback_rate1
@@ -923,9 +924,9 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
 
 			priv->tx_rate_fb0 =
-				wFB_Opt0[FB_RATE0][current_rate - RATE_18M];
+				vnt_fb_opt0[FB_RATE0][current_rate - RATE_18M];
 			priv->tx_rate_fb1 =
-				wFB_Opt0[FB_RATE1][current_rate - RATE_18M];
+				vnt_fb_opt0[FB_RATE1][current_rate - RATE_18M];
 
 			fb_option = AUTO_FB_0;
 		} else if (priv->byAutoFBCtrl == AUTO_FB_1) {
-- 
1.9.1

