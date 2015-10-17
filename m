Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36987 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbJQKdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:20 -0400
Received: by wicfv8 with SMTP id fv8so20382774wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/9] staging: vt6655: device.h remove unused macros.
Date: Sat, 17 Oct 2015 11:32:55 +0100
Message-Id: <1445077982-17832-2-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123325_411212_776973E7)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

None of these are used in driver anymore.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 64 -----------------------------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 271a719..4b8573b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -60,10 +60,6 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>	/* New driver API */
 
-#ifndef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-#define WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-#endif
-
 /* device specific */
 
 #include "device_cfg.h"
@@ -87,30 +83,8 @@
 #define RATE_36M	9
 #define RATE_48M	10
 #define RATE_54M	11
-#define RATE_AUTO	12
 #define MAX_RATE	12
 
-#define MAC_MAX_CONTEXT_REG     (256+128)
-
-#define MAX_MULTICAST_ADDRESS_NUM       32
-#define MULTICAST_ADDRESS_LIST_SIZE     (MAX_MULTICAST_ADDRESS_NUM * ETH_ALEN)
-
-#define DUPLICATE_RX_CACHE_LENGTH       5
-
-#define NUM_KEY_ENTRY                   11
-
-#define TX_WEP_NONE                     0
-#define TX_WEP_OTF                      1
-#define TX_WEP_SW                       2
-#define TX_WEP_SWOTP                    3
-#define TX_WEP_OTPSW                    4
-#define TX_WEP_SW232                    5
-
-#define KEYSEL_WEP40                    0
-#define KEYSEL_WEP104                   1
-#define KEYSEL_TKIP                     2
-#define KEYSEL_CCMP                     3
-
 #define AUTO_FB_NONE            0
 #define AUTO_FB_0               1
 #define AUTO_FB_1               2
@@ -126,26 +100,15 @@
 #define ANT_RXD_TXB             4
 #define ANT_UNKNOWN             0xFF
 
-#define MAXCHECKHANGCNT         4
-
 #define BB_VGA_LEVEL            4
 #define BB_VGA_CHANGE_THRESHOLD 16
 
-#ifndef RUN_AT
-#define RUN_AT(x)                       (jiffies+(x))
-#endif
-
 #define MAKE_BEACON_RESERVED	10  /* (us) */
 
-/* DMA related */
-#define RESERV_AC0DMA                   4
-
 /* BUILD OBJ mode */
 
 #define	AVAIL_TD(p, q)	((p)->sOpts.nTxDescs[(q)] - ((p)->iTDUsed[(q)]))
 
-#define	NUM				64
-
 /* 0:11A 1:11B 2:11G */
 #define BB_TYPE_11A    0
 #define BB_TYPE_11B    1
@@ -162,33 +125,6 @@ typedef enum {
 	OWNED_BY_NIC = 1
 } DEVICE_OWNER_TYPE, *PDEVICE_OWNER_TYPE;
 
-/* flags for options */
-#define     DEVICE_FLAGS_IP_ALIGN        0x00000001UL
-#define     DEVICE_FLAGS_PREAMBLE_TYPE   0x00000002UL
-#define     DEVICE_FLAGS_OP_MODE         0x00000004UL
-#define     DEVICE_FLAGS_PS_MODE         0x00000008UL
-#define		DEVICE_FLAGS_80211h_MODE	 0x00000010UL
-#define		DEVICE_FLAGS_DiversityANT	 0x00000020UL
-
-/* flags for driver status */
-#define     DEVICE_FLAGS_OPENED          0x00010000UL
-#define     DEVICE_FLAGS_WOL_ENABLED     0x00080000UL
-/* flags for capabilities */
-#define     DEVICE_FLAGS_TX_ALIGN        0x01000000UL
-#define     DEVICE_FLAGS_HAVE_CAM        0x02000000UL
-#define     DEVICE_FLAGS_FLOW_CTRL       0x04000000UL
-
-/* flags for MII status */
-#define     DEVICE_LINK_FAIL             0x00000001UL
-#define     DEVICE_SPEED_10              0x00000002UL
-#define     DEVICE_SPEED_100             0x00000004UL
-#define     DEVICE_SPEED_1000            0x00000008UL
-#define     DEVICE_DUPLEX_FULL           0x00000010UL
-#define     DEVICE_AUTONEG_ENABLE        0x00000020UL
-#define     DEVICE_FORCED_BY_EEPROM      0x00000040UL
-/* for device_set_media_duplex */
-#define     DEVICE_LINK_CHANGE           0x00000001UL
-
 typedef struct __device_opt {
 	int         nRxDescs0;		/* Number of RX descriptors0 */
 	int         nRxDescs1;		/* Number of RX descriptors1 */
-- 
2.5.0

