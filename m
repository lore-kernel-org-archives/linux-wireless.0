Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53267 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaKGTGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:50 -0500
Received: by mail-wg0-f44.google.com with SMTP id x12so4478080wgg.31
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:49 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/10] staging: vt6655: change typedef enum _VIA_PKT_TYPE to macro
Date: Fri,  7 Nov 2014 19:06:08 +0000
Message-Id: <1415387169-3843-9-git-send-email-tvboxspy@gmail.com> (sfid-20141107_201321_173880_8F060C5C)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing for u8 type and removing cast for byBBType.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 23 ++++++++++-------------
 drivers/staging/vt6655/device_main.c |  2 +-
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 3742d8d..55aa48b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -152,14 +152,11 @@
 #define BB_TYPE_11B    1
 #define BB_TYPE_11G    2
 
-/* 0:11a,1:11b,2:11gb(only CCK in BasicRate),3:11ga(OFDM in Basic Rate) */
-typedef enum _VIA_PKT_TYPE
-{
-	PK_TYPE_11A = 0,
-	PK_TYPE_11B,
-	PK_TYPE_11GB,
-	PK_TYPE_11GA
-} VIA_PKT_TYPE, *PVIA_PKT_TYPE;
+/* 0:11a, 1:11b, 2:11gb (only CCK in BasicRate), 3:11ga (OFDM in BasicRate) */
+#define PK_TYPE_11A     0
+#define PK_TYPE_11B     1
+#define PK_TYPE_11GB    2
+#define PK_TYPE_11GA    3
 
 typedef struct __chip_info_tbl {
 	CHIP_TYPE   chip_id;
@@ -319,11 +316,11 @@ struct vnt_private {
 	unsigned char byCWMaxMin;
 
 	u8		byBBType; /* 0:11A, 1:11B, 2:11G */
-	VIA_PKT_TYPE            byPacketType; /*
-					       * 0:11a,1:11b,2:11gb (only CCK
-					       * in BasicRate), 3:11ga (OFDM in
-					       * Basic Rate)
-					       */
+	u8		byPacketType; /*
+				       * 0:11a,1:11b,2:11gb (only CCK
+				       * in BasicRate), 3:11ga (OFDM in
+				       * Basic Rate)
+				       */
 	unsigned short wBasicRate;
 	unsigned char byACKRate;
 	unsigned char byTopOFDMBasicRate;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 22a55f4..2e31784 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -226,7 +226,7 @@ device_set_options(struct vnt_private *pDevice)
 	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
 	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
 	pDevice->byBBType = pDevice->sOpts.bbp_type;
-	pDevice->byPacketType = (VIA_PKT_TYPE)pDevice->byBBType;
+	pDevice->byPacketType = pDevice->byBBType;
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 	pDevice->bUpdateBBVGA = true;
 	pDevice->byPreambleType = 0;
-- 
2.1.0

