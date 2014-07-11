Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:55201 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaGKAJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:28 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so7636wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/13] staging: vt6656: rename and cleanup wTimeStampOff
Date: Fri, 11 Jul 2014 01:08:25 +0100
Message-Id: <1405037311-3666-7-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020932_694612_78FFF9F6)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename to vnt_time_stampoff

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5084434..7faef28 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -52,10 +52,10 @@
 
 static int          msglevel                = MSG_LEVEL_INFO;
 
-static const u16 wTimeStampOff[2][MAX_RATE] = {
-        {384, 288, 226, 209, 54, 43, 37, 31, 28, 25, 24, 23}, // Long Preamble
-        {384, 192, 130, 113, 54, 43, 37, 31, 28, 25, 24, 23}, // Short Preamble
-    };
+static const u16 vnt_time_stampoff[2][MAX_RATE] = {
+	{384, 288, 226, 209, 54, 43, 37, 31, 28, 25, 24, 23},/* Long Preamble */
+	{384, 192, 130, 113, 54, 43, 37, 31, 28, 25, 24, 23},/* Short Preamble */
+};
 
 static const u16 wFB_Opt0[2][5] = {
         {RATE_12M, RATE_18M, RATE_24M, RATE_36M, RATE_48M}, // fallback_rate0
@@ -128,7 +128,7 @@ static struct vnt_usb_send_context
 
 static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
 {
-	return cpu_to_le16(wTimeStampOff[priv->byPreambleType % 2]
+	return cpu_to_le16(vnt_time_stampoff[priv->byPreambleType % 2]
 							[rate % MAX_RATE]);
 }
 
-- 
1.9.1

