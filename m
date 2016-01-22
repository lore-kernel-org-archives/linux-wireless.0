Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:19990 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcAVHmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 02:42:43 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/2] staging: wilc1000: move wilc_send_config_pkt to wilc_wlan.c
Date: Fri, 22 Jan 2016 16:36:09 +0900
Message-ID: <1453448170-26040-1-git-send-email-glen.lee@atmel.com> (sfid-20160122_084247_934219_95902D16)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the function wilc_send_config_pkt to wilc_wlan.c which
handles transport since the purpose of the function is sending/getting of
config information. coreconfiguator.[ch] will be rename with frame.[ch] later.
The print codes of the function is removed also and they will be implemented
with netdev_xx print format later.
struct wid need to be moved to wilc_wlan_if.h which defines configure
informations.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 59 -----------------------------
 drivers/staging/wilc1000/coreconfigurator.h |  9 -----
 drivers/staging/wilc1000/wilc_wlan.c        | 39 +++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan.h        |  2 +
 drivers/staging/wilc1000/wilc_wlan_if.h     |  7 ++++
 5 files changed, 48 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2d4d3f1..d101393 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -572,62 +572,3 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 
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
-s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
-			 u32 count, u32 drv)
-{
-	s32 counter = 0, ret = 0;
-
-	if (mode == GET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
-				   (counter == count - 1));
-			if (!wilc_wlan_cfg_get(wilc, !counter,
-					       wids[counter].id,
-					       (counter == count - 1),
-					       drv)) {
-				ret = -ETIMEDOUT;
-				printk("[Sendconfigpkt]Get Timed out\n");
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
-			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
-			if (!wilc_wlan_cfg_set(wilc, !counter,
-					       wids[counter].id,
-					       wids[counter].val,
-					       wids[counter].size,
-					       (counter == count - 1),
-					       drv)) {
-				ret = -ETIMEDOUT;
-				printk("[Sendconfigpkt]Set Timed out\n");
-				break;
-			}
-		}
-	}
-
-	return ret;
-}
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index fc43d04..ee107ac 100644
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
 
-s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
-			 u32 count, u32 drv);
 s32 wilc_parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a0819b9..077d1a4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1439,6 +1439,45 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
+s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+			 u32 count, u32 drv)
+{
+	s32 counter = 0, ret = 0;
+
+	if (mode == GET_CFG) {
+		for (counter = 0; counter < count; counter++) {
+			if (!wilc_wlan_cfg_get(wilc, !counter,
+					       wids[counter].id,
+					       (counter == count - 1),
+					       drv)) {
+				ret = -ETIMEDOUT;
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
+			if (!wilc_wlan_cfg_set(wilc, !counter,
+					       wids[counter].id,
+					       wids[counter].val,
+					       wids[counter].size,
+					       (counter == count - 1),
+					       drv)) {
+				ret = -ETIMEDOUT;
+				break;
+			}
+		}
+	}
+
+	return ret;
+}
+
 static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 7f04653..3ebaf0e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -299,4 +299,6 @@ void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
 void chip_allow_sleep(struct wilc *wilc);
 void chip_wakeup(struct wilc *wilc);
+s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+			 u32 count, u32 drv);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index c446af6..455a98f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -300,6 +300,13 @@ enum wid_type {
 	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
 };
 
+struct wid {
+	u16 id;
+	enum wid_type type;
+	s32 size;
+	s8 *val;
+};
+
 typedef enum {
 	WID_NIL				= 0xffff,
 
-- 
1.9.1

