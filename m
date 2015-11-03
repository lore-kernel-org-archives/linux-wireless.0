Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8964 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbbKCHS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 02:18:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: move send_config_pkt to wilc_wlan.c
Date: Tue, 3 Nov 2015 16:21:02 +0900
Message-ID: <1446535262-19817-5-git-send-email-glen.lee@atmel.com> (sfid-20151103_082137_505028_A0B13F51)
In-Reply-To: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
References: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

send_config_pkt function and it's related structure wid_type is moved to
wilc_wlan.c because wilc_wlan.c handle message transport. the coreconfigurator
is all about frames, so it will be frame.[ch] later.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 64 -----------------------------
 drivers/staging/wilc1000/coreconfigurator.h |  9 ----
 drivers/staging/wilc1000/wilc_wlan.c        | 49 ++++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan.h        |  9 ++++
 4 files changed, 58 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3ddbe23..1caa66e 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -570,67 +570,3 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 
 	return s32Error;
 }
-
-/**
- *  @brief              sends certain Configuration Packet based on the input WIDs pstrWIDs
- *  using driver config layer
- *
- *  @details
- *  @param[in]  pstrWIDs WIDs to be sent in the configuration packet
- *  @param[in]  u32WIDsCount number of WIDs to be sent in the configuration packet
- *  @param[out]         pu8RxResp The received Packet Response
- *  @param[out]         ps32RxRespLen Length of the received Packet Response
- *  @return     Error code indicating success/failure
- *  @note
- *  @author	mabubakr
- *  @date		1 Mar 2012
- *  @version	1.0
- */
-s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
-		    u32 count, u32 drv)
-{
-	s32 counter = 0, ret = 0;
-
-	if (mode == GET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			netdev_info(dev, "Sending CFG packet [%d][%d]\n",
-				    !counter, (counter == count - 1));
-			if (!wilc_wlan_cfg_get(dev,
-					       !counter,
-					       wids[counter].id,
-					       (counter == count - 1),
-					       drv)) {
-				ret = -EBUSY;
-				netdev_err(dev,
-					   "[Sendconfigpkt]Get Timed out\n");
-				break;
-			}
-		}
-		counter = 0;
-		for (counter = 0; counter < count; counter++) {
-			wids[counter].size = wilc_wlan_cfg_get_val(
-					wids[counter].id,
-					wids[counter].val,
-					wids[counter].size);
-		}
-	} else if (mode == SET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			netdev_info(dev, "Sending config SET PACKET WID:%x\n",
-				    wids[counter].id);
-			if (!wilc_wlan_cfg_set(dev,
-					       !counter,
-					       wids[counter].id,
-					       wids[counter].val,
-					       wids[counter].size,
-					       (counter == count - 1),
-					       drv)) {
-				ret = -EBUSY;
-				netdev_err(dev,
-					   "[Sendconfigpkt]Set Timed out\n");
-				break;
-			}
-		}
-	}
-
-	return ret;
-}
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 7545856..7702a0f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -70,13 +70,6 @@ typedef enum {
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
 } tenuConnectSts;
 
-struct wid {
-	u16 id;
-	enum wid_type type;
-	s32 size;
-	s8 *val;
-};
-
 typedef struct {
 	u8 u8Full;
 	u8 u8Index;
@@ -127,8 +120,6 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
-		    u32 count, u32 drv);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 152dba5..44787b0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2104,3 +2104,52 @@ u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
 
 	return ret;
 }
+
+s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
+		    u32 count, u32 drv)
+{
+	s32 counter = 0, ret = 0;
+
+	if (mode == GET_CFG) {
+		for (counter = 0; counter < count; counter++) {
+			netdev_info(dev, "Sending CFG packet [%d][%d]\n",
+				    !counter, (counter == count - 1));
+			if (!wilc_wlan_cfg_get(dev,
+					       !counter,
+					       wids[counter].id,
+					       (counter == count - 1),
+					       drv)) {
+				ret = -EBUSY;
+				netdev_err(dev,
+					   "[Sendconfigpkt]Get Timed out\n");
+				break;
+			}
+		}
+		counter = 0;
+		for (counter = 0; counter < count; counter++) {
+			wids[counter].size = wilc_wlan_cfg_get_val(
+					wids[counter].id,
+					wids[counter].val,
+					wids[counter].size);
+		}
+	} else if (mode == SET_CFG) {
+		for (counter = 0; counter < count; counter++) {
+			netdev_info(dev, "Sending config SET PACKET WID:%x\n",
+				    wids[counter].id);
+			if (!wilc_wlan_cfg_set(dev,
+					       !counter,
+					       wids[counter].id,
+					       wids[counter].val,
+					       wids[counter].size,
+					       (counter == count - 1),
+					       drv)) {
+				ret = -EBUSY;
+				netdev_err(dev,
+					   "[Sendconfigpkt]Set Timed out\n");
+				break;
+			}
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 73e01a7..e5dcea9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -295,6 +295,13 @@ typedef struct {
 	u32 seq_no;
 } wilc_cfg_rsp_t;
 
+struct wid {
+	u16 id;
+	enum wid_type type;
+	s32 size;
+	s8 *val;
+};
+
 int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
 				u32 buffer_size);
 int wilc_wlan_start(struct net_device *dev);
@@ -312,4 +319,6 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
 void chip_sleep_manually(struct net_device *dev, u32 u32SleepTime);
+s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
+		    u32 count, u32 drv);
 #endif
-- 
1.9.1

