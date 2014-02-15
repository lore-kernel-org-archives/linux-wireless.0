Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:44781 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBOWAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 17:00:54 -0500
Received: by mail-we0-f176.google.com with SMTP id q58so9427968wes.7
        for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 14:00:53 -0800 (PST)
Message-ID: <1392501641.4022.7.camel@canaries32-MCP7A> (sfid-20140215_230057_289472_8BD2D646)
Subject: [PATCH 3/3 RESEND] staging: vt6656: Remove typedef  _VIA_BB_TYPE
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 15 Feb 2014 22:00:41 +0000
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BB_TYPE_11* are already defined in baseband.h as macros.

assign variable as u8 type.

iwctl.c needs the baseband.h header for the macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 10 +---------
 drivers/staging/vt6656/iwctl.c  |  1 +
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c195a9c..ec20b14 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -213,14 +213,6 @@ typedef struct {
     bool            bInUse;
 } INT_BUFFER, *PINT_BUFFER;
 
-/* 0:11A 1:11B 2:11G */
-typedef enum _VIA_BB_TYPE
-{
-    BB_TYPE_11A = 0,
-    BB_TYPE_11B,
-    BB_TYPE_11G
-} VIA_BB_TYPE, *PVIA_BB_TYPE;
-
 /*++ NDIS related */
 
 typedef enum __DEVICE_NDIS_STATUS {
@@ -540,7 +532,7 @@ struct vnt_private {
 	u8  byCWMaxMin;
 
 	/* Rate */
-	VIA_BB_TYPE byBBType; /* 0: 11A, 1:11B, 2:11G */
+	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
 	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
 	u16 wBasicRate;
 	u8 byACKRate;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 23320cc..60264a6 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -41,6 +41,7 @@
 #include "wpactl.h"
 #include "control.h"
 #include "rndis.h"
+#include "baseband.h"
 
 static const long frequency_list[] = {
 	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
-- 
1.9.rc1


