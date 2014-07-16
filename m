Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53531 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaGPVXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:38 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so6948993wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/21] staging: vt6656: remove dead code DEVICE_PARAM
Date: Wed, 16 Jul 2014 22:22:08 +0100
Message-Id: <1405545731-6082-18-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232355_070830_FD68D97E)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All these module parameters are dead

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 46f8491..0e65795 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -72,11 +72,6 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DEVICE_FULL_DRV_NAM);
 
-#define DEVICE_PARAM(N, D)				\
-	static int N[MAX_UINTS] = OPTION_DEFAULT;	\
-	module_param_array(N, int, NULL, 0);		\
-	MODULE_PARM_DESC(N, D)
-
 #define RX_DESC_DEF0 64
 static int vnt_rx_buffers = RX_DESC_DEF0;
 module_param_named(rx_buffers, vnt_rx_buffers, int, 0644);
@@ -89,7 +84,6 @@ MODULE_PARM_DESC(tx_buffers, "Number of receive usb tx buffers");
 
 
 #define CHANNEL_DEF 6
-DEVICE_PARAM(Channel, "Channel number");
 
 /* PreambleType[] is the preamble length used for transmit.
    0: indicate allows long preamble type
@@ -97,15 +91,8 @@ DEVICE_PARAM(Channel, "Channel number");
 */
 
 #define PREAMBLE_TYPE_DEF     1
-
-DEVICE_PARAM(PreambleType, "Preamble Type");
-
 #define RTS_THRESH_DEF     2347
-DEVICE_PARAM(RTSThreshold, "RTS threshold");
-
 #define FRAG_THRESH_DEF     2346
-DEVICE_PARAM(FragThreshold, "Fragmentation threshold");
-
 #define DATA_RATE_DEF     13
 /* datarate[] index
    0: indicate 1 Mbps   0x02
@@ -123,11 +110,7 @@ DEVICE_PARAM(FragThreshold, "Fragmentation threshold");
   12: indicate 72 Mbps  0x90
   13: indicate auto rate
 */
-
-DEVICE_PARAM(ConnectionRate, "Connection data rate");
-
 #define OP_MODE_DEF     0
-DEVICE_PARAM(OPMode, "Infrastruct, adhoc, AP mode ");
 
 /* OpMode[] is used for transmit.
    0: indicate infrastruct mode used
@@ -141,13 +124,10 @@ DEVICE_PARAM(OPMode, "Infrastruct, adhoc, AP mode ");
 */
 
 #define PS_MODE_DEF     0
-DEVICE_PARAM(PSMode, "Power saving mode");
 
 #define SHORT_RETRY_DEF     8
-DEVICE_PARAM(ShortRetryLimit, "Short frame retry limits");
 
 #define LONG_RETRY_DEF     4
-DEVICE_PARAM(LongRetryLimit, "long frame retry limits");
 
 /* BasebandType[] baseband type selected
    0: indicate 802.11a type
@@ -156,7 +136,6 @@ DEVICE_PARAM(LongRetryLimit, "long frame retry limits");
 */
 
 #define BBP_TYPE_DEF     2
-DEVICE_PARAM(BasebandType, "baseband type");
 
 /* 80211hEnable[]
    0: indicate disable 802.11h
@@ -165,8 +144,6 @@ DEVICE_PARAM(BasebandType, "baseband type");
 
 #define X80211h_MODE_DEF     0
 
-DEVICE_PARAM(b80211hEnable, "802.11h mode");
-
 /*
  * Static vars definitions
  */
-- 
2.0.1

