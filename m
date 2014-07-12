Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:34419 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaGLKak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 06:30:40 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so2092188wev.6
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 03:30:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6656: rf.c remove dead code RFaby11aChannelIndex
Date: Sat, 12 Jul 2014 11:30:01 +0100
Message-Id: <1405161003-2914-2-git-send-email-tvboxspy@gmail.com> (sfid-20140712_123055_567960_57C9F256)
In-Reply-To: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
References: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 31 -------------------------------
 drivers/staging/vt6656/rf.h |  2 --
 2 files changed, 33 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index f203dde..1661f8ee 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -613,37 +613,6 @@ static const u32 al2230_power_table[AL2230_PWR_IDX_LEN] = {
 	0x0407f900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW
 };
 
-//{{ RobertYu:20050103, Channel 11a Number To Index
-// 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196  (Value:15 ~ 22)
-// 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
-// 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165  (Value 23 ~ 56)
-
-const u8 RFaby11aChannelIndex[200] = {
-  // 1   2   3   4   5   6   7   8   9  10
-    00, 00, 00, 00, 00, 00, 23, 24, 25, 00,  // 10
-    26, 27, 00, 00, 00, 28, 00, 00, 00, 00,  // 20
-    00, 00, 00, 00, 00, 00, 00, 00, 00, 00,  // 30
-    00, 00, 00, 29, 00, 30, 00, 31, 00, 32,  // 40
-    00, 33, 00, 34, 00, 35, 00, 36, 00, 00,  // 50
-    00, 37, 00, 00, 00, 38, 00, 00, 00, 39,  // 60
-    00, 00, 00, 40, 00, 00, 00, 00, 00, 00,  // 70
-    00, 00, 00, 00, 00, 00, 00, 00, 00, 00,  // 80
-    00, 00, 00, 00, 00, 00, 00, 00, 00, 00,  // 90
-    00, 00, 00, 00, 00, 00, 00, 00, 00, 41,  //100
-
-    00, 00, 00, 42, 00, 00, 00, 43, 00, 00,  //110
-    00, 44, 00, 00, 00, 45, 00, 00, 00, 46,  //120
-    00, 00, 00, 47, 00, 00, 00, 48, 00, 00,  //130
-    00, 49, 00, 00, 00, 50, 00, 00, 00, 51,  //140
-    00, 00, 00, 00, 00, 00, 00, 00, 52, 00,  //150
-    00, 00, 53, 00, 00, 00, 54, 00, 00, 00,  //160
-    55, 00, 00, 00, 56, 00, 00, 00, 00, 00,  //170
-    00, 00, 00, 00, 00, 00, 00, 00, 00, 00,  //180
-    00, 00, 15, 16, 17, 00, 18, 19, 20, 00,  //190
-    00, 21, 00, 00, 00, 22, 00, 00, 00, 00   //200
-};
-//}} RobertYu
-
 /*
  * Description: Write to IF/RF, by embedded programming
  *
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index cb33151..d2347b4 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -55,8 +55,6 @@
 
 #define VNT_RF_MAX_POWER    0x3f
 
-extern const u8 RFaby11aChannelIndex[200];
-
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
 int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
-- 
1.9.1

