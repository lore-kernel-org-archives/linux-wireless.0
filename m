Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59602 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKGTGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:50 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so5477184wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:49 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/10] staging: vt6655: replace typedef enum _VIA_BB_TYPE with macros
Date: Fri,  7 Nov 2014 19:06:07 +0000
Message-Id: <1415387169-3843-8-git-send-email-tvboxspy@gmail.com> (sfid-20141107_201320_953094_B7DDF08C)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing type with u8

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index dab07e1..3742d8d 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -148,12 +148,9 @@
 #define	NUM				64
 
 /* 0:11A 1:11B 2:11G */
-typedef enum _VIA_BB_TYPE
-{
-	BB_TYPE_11A = 0,
-	BB_TYPE_11B,
-	BB_TYPE_11G
-} VIA_BB_TYPE, *PVIA_BB_TYPE;
+#define BB_TYPE_11A    0
+#define BB_TYPE_11B    1
+#define BB_TYPE_11G    2
 
 /* 0:11a,1:11b,2:11gb(only CCK in BasicRate),3:11ga(OFDM in Basic Rate) */
 typedef enum _VIA_PKT_TYPE
@@ -321,7 +318,7 @@ struct vnt_private {
 	unsigned char bySlot;
 	unsigned char byCWMaxMin;
 
-	VIA_BB_TYPE		byBBType; /* 0:11A, 1:11B, 2:11G */
+	u8		byBBType; /* 0:11A, 1:11B, 2:11G */
 	VIA_PKT_TYPE            byPacketType; /*
 					       * 0:11a,1:11b,2:11gb (only CCK
 					       * in BasicRate), 3:11ga (OFDM in
-- 
2.1.0

