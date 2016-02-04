Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59247 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbcBDJeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:34:24 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 67/70] staging: wilc1000: remove unused log message using the RX_DBG tag
Date: Thu, 4 Feb 2016 18:24:28 +0900
Message-ID: <1454577871-667-28-git-send-email-glen.lee@atmel.com> (sfid-20160204_103437_843605_8BD4D1D9)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unused log message using the RX_DBG tag

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 2 --
 drivers/staging/wilc1000/wilc_debugfs.c      | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c         | 5 -----
 drivers/staging/wilc1000/wilc_wlan_cfg.c     | 5 -----
 4 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 617bc53..63d0ec5 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -6,7 +6,6 @@ enum debug_region {
 	Hostapd_debug,
 	CFG80211_debug,
 	Interrupt_debug,
-	RX_debug,
 	Lock_debug,
 	Tcp_enhance,
 	Spin_debug,
@@ -22,7 +21,6 @@ enum debug_region {
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INT_DBG                 (1 << Interrupt_debug)
-#define RX_DBG                  (1 << RX_debug)
 #define LOCK_DBG                (1 << Lock_debug)
 #define TCP_ENH                 (1 << Tcp_enhance)
 #define SPIN_DEBUG              (1 << Spin_debug)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index a3d274b..9c85bdd 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,7 +24,7 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8cb1ef6..7480f9e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -835,11 +835,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			u32 pkt_len, pkt_offset, tp_len;
 			int is_cfg_packet;
 
-			PRINT_D(RX_DBG, "In the 2nd do-while\n");
 			memcpy(&header, &buffer[offset], 4);
 			header = cpu_to_le32(header);
-			PRINT_D(RX_DBG, "Header = %04x - Offset = %d\n",
-				header, offset);
 
 			is_cfg_packet = (header >> 31) & 0x1;
 			pkt_offset = (header >> 22) & 0x1ff;
@@ -890,7 +887,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 	} while (1);
 
 	wilc->rxq_exit = 1;
-	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
 }
 
 static void wilc_unknown_isr_ext(struct wilc *wilc)
@@ -958,7 +954,6 @@ _end_:
 			if (rqe) {
 				rqe->buffer = buffer;
 				rqe->buffer_size = size;
-				PRINT_D(RX_DBG, "rxq entery Size= %d - Address = %p\n", rqe->buffer_size, rqe->buffer);
 				wilc_wlan_rxq_add(wilc, rqe);
 			}
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b72c77b..3b3065b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -522,7 +522,6 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 		rsp->type = wilc_wlan_parse_info_frame(frame, size);
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
-		PRINT_INFO(RX_DBG, "Info message received\n");
 		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
 		break;
 
@@ -532,14 +531,10 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 		break;
 
 	case 'S':
-		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
 		wilc_scan_complete_received(wilc, frame - 4, size + 4);
 		break;
 
 	default:
-		PRINT_INFO(RX_DBG, "Receive unknown message type[%d-%d-%d-%d-%d-%d-%d-%d]\n",
-			   frame[0], frame[1], frame[2], frame[3], frame[4],
-			   frame[5], frame[6], frame[7]);
 		rsp->type = 0;
 		rsp->seq_no = msg_id;
 		ret = 0;
-- 
1.9.1

