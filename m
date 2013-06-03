Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63803 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab3FCVyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:54:50 -0400
Received: by mail-we0-f170.google.com with SMTP id w57so2193194wes.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:54:49 -0700 (PDT)
Message-ID: <1370296484.9091.35.camel@canaries64> (sfid-20130603_235506_577660_36834423)
Subject: [PATCH 7/8] staging: vt6656: rf.c correct typo error of vt3226
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:54:44 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct typo error of at3226_init_table/at3226d0_init_table

The device is vt3226

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 051e790..2152b44 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -355,7 +355,7 @@ static u8 al7230_channel_table2[CB_MAX_CHANNEL][3] = {
     };
 
 ///{{RobertYu:20051111
-static u8 at3226_init_table[CB_VT3226_INIT_SEQ][3] = {
+static u8 vt3226_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x02, 0x82, 0xA1},
     {0x03, 0xC6, 0xA2},
@@ -369,7 +369,7 @@ static u8 at3226_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x02, 0x00, 0x2A}
     };
 
-static u8 at3226d0_init_table[CB_VT3226_INIT_SEQ][3] = {
+static u8 vt3226d0_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x03, 0x02, 0x21}, //RobertYu:20060327
     {0x03, 0xC6, 0xA2},
@@ -995,7 +995,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &at3226_init_table[0][0];
+		addr1 = &vt3226_init_table[0][0];
 		addr2 = &vt3226_channel_table0[0][0];
 		addr3 = &vt3226_channel_table1[0][0];
 		break;
@@ -1003,7 +1003,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &at3226d0_init_table[0][0];
+		addr1 = &vt3226d0_init_table[0][0];
 		addr2 = &vt3226_channel_table0[0][0];
 		addr3 = &vt3226_channel_table1[0][0];
 		break;
-- 
1.8.1.2

