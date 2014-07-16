Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37394 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaGPVXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:07 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so2057966wib.10
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/21] staging: vt6656: baseband.c rename awcFrameTime to vnt_frame_time
Date: Wed, 16 Jul 2014 22:21:51 +0100
Message-Id: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232313_205029_9CEE6E4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 040b232..e56defa 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -123,7 +123,7 @@ static u8 vnt_vt3184_vt3226d0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* 0xff */
 };
 
-static const u16 awcFrameTime[MAX_RATE] = {
+static const u16 vnt_frame_time[MAX_RATE] = {
 	10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216
 };
 
@@ -152,7 +152,7 @@ unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
 	if (tx_rate > RATE_54M)
 		return 0;
 
-	rate = (unsigned int)awcFrameTime[tx_rate];
+	rate = (unsigned int)vnt_frame_time[tx_rate];
 
 	if (tx_rate <= 3) {
 		if (preamble_type == 1)
-- 
2.0.1

