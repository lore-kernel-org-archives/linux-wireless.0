Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13686 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbLNFnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:43:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/12] staging: wilc1000: pass struct wilc
Date: Mon, 14 Dec 2015 14:46:55 +0900
Message-ID: <1450072023-13013-5-git-send-email-glen.lee@atmel.com> (sfid-20151214_064355_996925_E676B228)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass struct wilc to the following functions. The functions need wilc to
get proper vif using id from wilc device.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 11 ++++++-----
 drivers/staging/wilc1000/host_interface.c   |  9 ++++++---
 drivers/staging/wilc1000/wilc_wlan.c        |  2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c    |  9 +++++----
 drivers/staging/wilc1000/wilc_wlan_cfg.h    |  4 +++-
 5 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3f2a7d3..fc43d04 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -135,9 +135,10 @@ s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
 		       tstrConnectRespInfo **ppstrConnectRespInfo);
 s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo);
-
-void wilc_network_info_received(u8 *pu8Buffer, u32 u32Length);
-void wilc_gnrl_async_info_received(u8 *pu8Buffer, u32 u32Length);
-void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length);
-
+void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
+				 u32 u32Length);
+void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
+				u32 u32Length);
+void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
+				   u32 u32Length);
 #endif
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e8c14cc..259cefc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4021,7 +4021,8 @@ s32 wilc_deinit(struct wilc_vif *vif)
 	return result;
 }
 
-void wilc_network_info_received(u8 *pu8Buffer, u32 u32Length)
+void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
+				u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4050,7 +4051,8 @@ void wilc_network_info_received(u8 *pu8Buffer, u32 u32Length)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", result);
 }
 
-void wilc_gnrl_async_info_received(u8 *pu8Buffer, u32 u32Length)
+void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
+				   u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
@@ -4091,7 +4093,8 @@ void wilc_gnrl_async_info_received(u8 *pu8Buffer, u32 u32Length)
 	up(&hif_sema_deinit);
 }
 
-void wilc_scan_complete_received(u8 *pu8Buffer, u32 u32Length)
+void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
+				 u32 u32Length)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 768a42c..00f3464 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -988,7 +988,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				} else {
 					struct wilc_cfg_rsp rsp;
 
-					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
+					wilc_wlan_cfg_indicate_rx(wilc, &buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
 						PRINT_D(RX_DBG, "wilc->cfg_seq_no = %d - rsp.seq_no = %d\n", wilc->cfg_seq_no, rsp.seq_no);
 						if (wilc->cfg_seq_no == rsp.seq_no)
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index f62c0e6..b72c77b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -495,7 +495,8 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp)
+int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			      struct wilc_cfg_rsp *rsp)
 {
 	int ret = 1;
 	u8 msg_type;
@@ -522,17 +523,17 @@ int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp)
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
 		PRINT_INFO(RX_DBG, "Info message received\n");
-		wilc_gnrl_async_info_received(frame - 4, size + 4);
+		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
 		break;
 
 	case 'N':
-		wilc_network_info_received(frame - 4, size + 4);
+		wilc_network_info_received(wilc, frame - 4, size + 4);
 		rsp->type = 0;
 		break;
 
 	case 'S':
 		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
-		wilc_scan_complete_received(frame - 4, size + 4);
+		wilc_scan_complete_received(wilc, frame - 4, size + 4);
 		break;
 
 	default:
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 443b2d5..5f74eb8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -30,10 +30,12 @@ typedef struct {
 	u8 *str;
 } wilc_cfg_str_t;
 
+struct wilc;
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
-int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp);
+int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			      struct wilc_cfg_rsp *rsp);
 int wilc_wlan_cfg_init(wilc_debug_func func);
 
 #endif
-- 
1.9.1

