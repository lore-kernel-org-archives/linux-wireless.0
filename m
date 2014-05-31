Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47259 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaEaNKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 09:10:31 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so2393733wiv.15
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 06:10:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org
Subject: [PATCH] staging: vt6656: Fix vnt_rf_table_download __builtin_memcpy() addr* too small (3 vs 64).
Date: Sat, 31 May 2014 14:09:27 +0100
Message-Id: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com> (sfid-20140531_151034_921055_AEBC53F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix following errors
drivers/staging/vt6656/rf.c:1060 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
drivers/staging/vt6656/rf.c:1078 vnt_rf_table_download() error: __builtin_memcpy() 'addr3' too small (3 vs 64)
drivers/staging/vt6656/rf.c:1094 vnt_rf_table_download() error: __builtin_memcpy() 'addr1' too small (3 vs 48)
drivers/staging/vt6656/rf.c:1108 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3f54ae3..131764f 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -1003,41 +1003,41 @@ void vnt_rf_table_download(struct vnt_private *priv)
 		length1 = CB_AL2230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &al2230_init_table[0][0];
-		addr2 = &al2230_channel_table0[0][0];
-		addr3 = &al2230_channel_table1[0][0];
+		addr1 = (u8 *)al2230_init_table;
+		addr2 = (u8 *)al2230_channel_table0;
+		addr3 = (u8 *)al2230_channel_table1;
 		break;
 	case RF_AIROHA7230:
 		length1 = CB_AL7230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
 		length3 = CB_MAX_CHANNEL * 3;
-		addr1 = &al7230_init_table[0][0];
-		addr2 = &al7230_channel_table0[0][0];
-		addr3 = &al7230_channel_table1[0][0];
+		addr1 = (u8 *)al7230_init_table;
+		addr2 = (u8 *)al7230_channel_table0;
+		addr3 = (u8 *)al7230_channel_table1;
 		break;
 	case RF_VT3226:
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &vt3226_init_table[0][0];
-		addr2 = &vt3226_channel_table0[0][0];
-		addr3 = &vt3226_channel_table1[0][0];
+		addr1 = (u8 *)vt3226_init_table;
+		addr2 = (u8 *)vt3226_channel_table0;
+		addr3 = (u8 *)vt3226_channel_table1;
 		break;
 	case RF_VT3226D0:
 		length1 = CB_VT3226_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL_24G * 3;
 		length3 = CB_MAX_CHANNEL_24G * 3;
-		addr1 = &vt3226d0_init_table[0][0];
-		addr2 = &vt3226_channel_table0[0][0];
-		addr3 = &vt3226_channel_table1[0][0];
+		addr1 = (u8 *)vt3226d0_init_table;
+		addr2 = (u8 *)vt3226_channel_table0;
+		addr3 = (u8 *)vt3226_channel_table1;
 		break;
 	case RF_VT3342A0:
 		length1 = CB_VT3342_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
 		length3 = CB_MAX_CHANNEL * 3;
-		addr1 = &vt3342a0_init_table[0][0];
-		addr2 = &vt3342_channel_table0[0][0];
-		addr3 = &vt3342_channel_table1[0][0];
+		addr1 = (u8 *)vt3342a0_init_table;
+		addr2 = (u8 *)vt3342_channel_table0;
+		addr3 = (u8 *)vt3342_channel_table1;
 		break;
 	}
 
@@ -1086,8 +1086,8 @@ void vnt_rf_table_download(struct vnt_private *priv)
 	if (priv->byRFType == RF_AIROHA7230) {
 		length1 = CB_AL7230_INIT_SEQ * 3;
 		length2 = CB_MAX_CHANNEL * 3;
-		addr1 = &(al7230_init_table_amode[0][0]);
-		addr2 = &(al7230_channel_table2[0][0]);
+		addr1 = (u8 *)al7230_init_table_amode;
+		addr2 = (u8 *)al7230_channel_table2;
 
 		memcpy(array, addr1, length1);
 
-- 
1.9.1

