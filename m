Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51057 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbBAMAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:16 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so11279454wiw.4
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:15 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6656: vnt_fill_cts_head remove unneeded NULL check.
Date: Sun,  1 Feb 2015 11:59:42 +0000
Message-Id: <1422791983-3408-5-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130025_687096_E98EA6B9)
In-Reply-To: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
References: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

union vnt_tx_data_head is nolonger detached from main
vnt_tx_buffer structure so this check is unnecessary.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b74f672..3b90497 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -525,9 +525,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 	u32 cts_frame_len = 14;
 	u16 current_rate = tx_context->tx_rate;
 
-	if (!head)
-		return 0;
-
 	if (tx_context->fb_option) {
 		/* Auto Fall back */
 		struct vnt_cts_fb *buf = &head->cts_g_fb;
-- 
2.1.0

