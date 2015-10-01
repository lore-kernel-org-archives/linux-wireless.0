Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33919 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbbJANo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:27 -0400
Received: by padhy16 with SMTP id hy16so75400873pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/12] staging: wilc1000: remove unnecessary comment
Date: Thu,  1 Oct 2015 22:43:53 +0900
Message-Id: <1443707039-18433-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154430_531559_F0D1911B)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary comment.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c     |  6 ------
 drivers/staging/wilc1000/host_interface.h     | 16 ++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 23 ++++++++++-------------
 drivers/staging/wilc1000/wilc_wlan.c          |  2 --
 4 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index be01de5..49823c1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -12,9 +12,6 @@ extern u8 connecting;
 extern struct timer_list hDuringIpTimer;
 
 extern u8 g_wilc_initialized;
-/*****************************************************************************/
-/*								Macros                                       */
-/*****************************************************************************/
 
 /* Message types of the Host IF Message Queue*/
 #define HOST_IF_MSG_SCAN                        0
@@ -63,9 +60,6 @@ extern u8 g_wilc_initialized;
 #define BA_SESSION_DEFAULT_BUFFER_SIZE          16
 #define BA_SESSION_DEFAULT_TIMEOUT              1000
 #define BLOCK_ACK_REQ_SIZE                      0x14
-/*****************************************************************************/
-/*								Type Definitions							 */
-/*****************************************************************************/
 
 /*!
  *  @struct             cfg_param_attr
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 56ba042..fb5cb8a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -11,9 +11,6 @@
 #define HOST_INT_H
 
 #include "coreconfigurator.h"
-/*****************************************************************************/
-/*								Macros                                       */
-/*****************************************************************************/
 
 #define IP_ALEN  4
 
@@ -38,10 +35,10 @@
 #define REMOVEKEY				0x2
 #define DEFAULTKEY				0x4
 #define ADDKEY_AP				0x8
-#define MAX_NUM_SCANNED_NETWORKS		100 /* 30		// rachel */
+#define MAX_NUM_SCANNED_NETWORKS		100
 #define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
-#define MAX_NUM_PROBED_SSID			10  /*One more than the number of scanned ssids*/
-#define CHANNEL_SCAN_TIME			250 /* 250 */
+#define MAX_NUM_PROBED_SSID			10
+#define CHANNEL_SCAN_TIME			250
 
 #define TX_MIC_KEY_LEN				8
 #define RX_MIC_KEY_LEN				8
@@ -56,7 +53,7 @@
 #define PMKID_LEN				16
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_SUPP_MCS_SET_SIZE			16
-#define WILC_ADD_STA_LENGTH			40 /* Not including the rates field cause it has variable length*/
+#define WILC_ADD_STA_LENGTH			40
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
 
@@ -1202,9 +1199,4 @@ void host_int_freeJoinParams(void *pJoinParams);
 
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics);
 
-/*****************************************************************************/
-/*																			 */
-/*									EOF										 */
-/*																			 */
-/*****************************************************************************/
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4878f12..b8a0d56 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -8,12 +8,10 @@
 #ifndef WILC_WFI_NETDEVICE
 #define WILC_WFI_NETDEVICE
 
-/* These are the flags in the statusword */
 #define WILC_WFI_RX_INTR 0x0001
 #define WILC_WFI_TX_INTR 0x0002
 
-/* Default timeout period */
-#define WILC_WFI_TIMEOUT 5   /* In jiffies */
+#define WILC_WFI_TIMEOUT 5
 #define WILC_MAX_NUM_PMKIDS  16
 #define PMKID_LEN  16
 #define PMKID_FOUND 1
@@ -24,16 +22,16 @@
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
-#include <linux/slab.h> /* kmalloc() */
-#include <linux/errno.h>  /* error codes */
-#include <linux/types.h>  /* size_t */
-#include <linux/interrupt.h> /* mark_bh */
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/in.h>
-#include <linux/netdevice.h>   /* struct device, and other headers */
-#include <linux/etherdevice.h> /* eth_type_trans */
-#include <linux/ip.h>          /* struct iphdr */
-#include <linux/tcp.h>         /* struct tcphdr */
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
 #include <linux/skbuff.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
@@ -45,12 +43,11 @@
 #include <asm/checksum.h>
 #include "host_interface.h"
 #include "wilc_wlan.h"
-#include <linux/wireless.h>     /* tony, 2013-06-12 */
+#include <linux/wireless.h>
 
 #define FLOW_CONTROL_LOWER_THRESHOLD	128
 #define FLOW_CONTROL_UPPER_THRESHOLD	256
 
-/*iftype*/
 enum stats_flags {
 	WILC_WFI_RX_PKT = BIT(0),
 	WILC_WFI_TX_PKT = BIT(1),
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index de70c59..e4e1eb2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1164,7 +1164,6 @@ static void wilc_wlan_handle_rxq(void)
 				break;
 			}
 
-/*bug 3887: [AP] Allow Management frames to be passed to the host*/
 			#define IS_MANAGMEMENT				0x100
 			#define IS_MANAGMEMENT_CALLBACK			0x080
 			#define IS_MGMT_STATUS_SUCCES			0x040
@@ -1176,7 +1175,6 @@ static void wilc_wlan_handle_rxq(void)
 
 				WILC_WFI_mgmt_rx(&buffer[offset + HOST_HDR_OFFSET], pkt_len);
 			}
-			/* BUG4530 fix */
 			else
 			{
 
-- 
2.6.0

