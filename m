Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:41623 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaE0UGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:20 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so10033584wes.38
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/10] staging: vt6656: rf.c Fix typo error at3226*
Date: Tue, 27 May 2014 21:05:25 +0100
Message-Id: <1401221126-4219-9-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220629_131393_82A0A322)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 78a650dc19ba44e2e07768c6d3b2ff080cf9d245
there was a typo error

abyVT3226_InitTable -> at3226_init_table
abyVT3226D0_InitTable -> at3226d0_init_table

Shoud be vt3226_init_table and vt3226d0_init_table

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 4420114..d509839 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -354,7 +354,7 @@ static u8 al7230_channel_table2[CB_MAX_CHANNEL][3] = {
     };
 
 ///{{RobertYu:20051111
-static u8 at3226_init_table[CB_VT3226_INIT_SEQ][3] = {
+static u8 vt3226_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x02, 0x82, 0xA1},
     {0x03, 0xC6, 0xA2},
@@ -368,7 +368,7 @@ static u8 at3226_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x02, 0x00, 0x2A}
     };
 
-static u8 at3226d0_init_table[CB_VT3226_INIT_SEQ][3] = {
+static u8 vt3226d0_init_table[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x03, 0x02, 0x21}, //RobertYu:20060327
     {0x03, 0xC6, 0xA2},
@@ -1021,7 +1021,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &at3226_init_table[0][0];
+		addr1 = &vt3226_init_table[0][0];
 		addr2 = &vt3226_channel_table0[0][0];
 		addr3 = &vt3226_channel_table1[0][0];
 		break;
@@ -1029,7 +1029,7 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &at3226d0_init_table[0][0];
+		addr1 = &vt3226d0_init_table[0][0];
 		addr2 = &vt3226_channel_table0[0][0];
 		addr3 = &vt3226_channel_table1[0][0];
 		break;
-- 
1.9.1

