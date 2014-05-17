Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63555 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaEQIxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:00 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2005711wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/22] staging: vt6656: device.h remove dead macros
Date: Sat, 17 May 2014 09:50:25 +0100
Message-Id: <1400316639-4430-8-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112147_917279_C28955A1)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 67 +----------------------------------------
 1 file changed, 1 insertion(+), 66 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 3c2c4ce..f8591a2 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -52,14 +52,6 @@
 #undef DEVICE_ETHTOOL_IOCTL_SUPPORT
 #endif
 
-/* please copy below macro to driver_event.c for API */
-#define RT_INSMOD_EVENT_FLAG                             0x0101
-#define RT_UPDEV_EVENT_FLAG                               0x0102
-#define RT_DISCONNECTED_EVENT_FLAG               0x0103
-#define RT_WPACONNECTED_EVENT_FLAG             0x0104
-#define RT_DOWNDEV_EVENT_FLAG                        0x0105
-#define RT_RMMOD_EVENT_FLAG                              0x0106
-
 #define MAX_RATE			12
 
 /*
@@ -90,27 +82,8 @@
 #define MAX_UINTS			8
 #define OPTION_DEFAULT			{ [0 ... MAX_UINTS-1] = -1}
 
-#define MAC_MAX_CONTEXT_REG     (256+128)
-
-#define MAX_MULTICAST_ADDRESS_NUM       32
-#define MULTICAST_ADDRESS_LIST_SIZE     (MAX_MULTICAST_ADDRESS_NUM * ETH_ALEN)
-
 #define DUPLICATE_RX_CACHE_LENGTH       5
 
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
@@ -130,13 +103,6 @@
 #define ANT_RXA                 2
 #define ANT_RXB                 3
 
-#define MAXCHECKHANGCNT         4
-
-/* Packet type */
-#define TX_PKT_UNI              0x00
-#define TX_PKT_MULTI            0x01
-#define TX_PKT_BROAD            0x02
-
 #define BB_VGA_LEVEL            4
 #define BB_VGA_CHANGE_THRESHOLD 3
 
@@ -144,9 +110,6 @@
 #define RUN_AT(x)                       (jiffies+(x))
 #endif
 
-/* DMA related */
-#define RESERV_AC0DMA                   4
-
 #define PRIVATE_Message                 0
 
 #define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
@@ -320,29 +283,9 @@ typedef struct tagSDeFragControlBlock
 
 /* flags for options */
 #define     DEVICE_FLAGS_UNPLUG          0x00000001UL
-#define     DEVICE_FLAGS_PREAMBLE_TYPE   0x00000002UL
-#define     DEVICE_FLAGS_OP_MODE         0x00000004UL
-#define     DEVICE_FLAGS_PS_MODE         0x00000008UL
-#define		DEVICE_FLAGS_80211h_MODE	 0x00000010UL
 
 /* flags for driver status */
 #define     DEVICE_FLAGS_OPENED          0x00010000UL
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
 
 typedef struct __device_opt {
 	int nRxDescs0;  /* number of RX descriptors 0 */
@@ -742,14 +685,7 @@ struct vnt_private {
         (uVar)++;                                   \
 }
 
-#define fMP_RESET_IN_PROGRESS               0x00000001
 #define fMP_DISCONNECTED                    0x00000002
-#define fMP_HALT_IN_PROGRESS                0x00000004
-#define fMP_SURPRISE_REMOVED                0x00000008
-#define fMP_RECV_LOOKASIDE                  0x00000010
-#define fMP_INIT_IN_PROGRESS                0x00000020
-#define fMP_SEND_SIDE_RESOURCE_ALLOCATED    0x00000040
-#define fMP_RECV_SIDE_RESOURCE_ALLOCATED    0x00000080
 #define fMP_POST_READS                      0x00000100
 #define fMP_POST_WRITES                     0x00000200
 
@@ -757,8 +693,7 @@ struct vnt_private {
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
 #define MP_TEST_FLAGS(_M, _F)            (((_M)->Flags & (_F)) == (_F))
 
-#define MP_IS_READY(_M)        (((_M)->Flags & \
-                                 (fMP_DISCONNECTED | fMP_RESET_IN_PROGRESS | fMP_HALT_IN_PROGRESS | fMP_INIT_IN_PROGRESS | fMP_SURPRISE_REMOVED)) == 0)
+#define MP_IS_READY(_M)        (((_M)->Flags & fMP_DISCONNECTED) == 0)
 
 int device_alloc_frag_buf(struct vnt_private *, PSDeFragControlBlock pDeF);
 void vnt_configure_filter(struct vnt_private *);
-- 
1.9.1

