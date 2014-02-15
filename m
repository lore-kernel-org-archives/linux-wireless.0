Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33854 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaBOSal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 13:30:41 -0500
Received: by mail-wi0-f176.google.com with SMTP id hi5so1323340wib.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 10:30:40 -0800 (PST)
Message-ID: <1392489033.2518.19.camel@canaries64-MCP7A> (sfid-20140215_193044_711379_53F3A8EB)
Subject: [PATCH 2/3] staging: vt6656: remove typedef VIA_PKT_TYPE.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 15 Feb 2014 18:30:33 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The packet types PK_TYPE_11* are already defined in baseband.h as macros

assign variable as u8 type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2bca7c0..c195a9c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -221,15 +221,6 @@ typedef enum _VIA_BB_TYPE
     BB_TYPE_11G
 } VIA_BB_TYPE, *PVIA_BB_TYPE;
 
-/* 0:11a, 1:11b, 2:11gb (only CCK in BasicRate), 3:11ga(OFDM in BasicRate) */
-typedef enum _VIA_PKT_TYPE
-{
-    PK_TYPE_11A = 0,
-    PK_TYPE_11B,
-    PK_TYPE_11GB,
-    PK_TYPE_11GA
-} VIA_PKT_TYPE, *PVIA_PKT_TYPE;
-
 /*++ NDIS related */
 
 typedef enum __DEVICE_NDIS_STATUS {
@@ -550,7 +541,7 @@ struct vnt_private {
 
 	/* Rate */
 	VIA_BB_TYPE byBBType; /* 0: 11A, 1:11B, 2:11G */
-	VIA_PKT_TYPE byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
+	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u16 wBasicRate;
 	u8 byACKRate;
 	u8 byTopOFDMBasicRate;
-- 
1.9.rc1

