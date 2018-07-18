Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16466 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeGSGpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:45:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/23] staging: wilc1000: remove unused enum declaration
Date: Thu, 19 Jul 2018 04:14:57 +0530
Message-ID: <1531953919-20804-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080427_430304_9688CE9D)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unused enums.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  8 --------
 drivers/staging/wilc1000/host_interface.h   |  6 ------
 drivers/staging/wilc1000/wilc_wlan_if.h     | 26 --------------------------
 3 files changed, 40 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4481602..0063895 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -4,14 +4,6 @@
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
-enum basic_frame_type {
-	FRAME_TYPE_CONTROL     = 0x04,
-	FRAME_TYPE_DATA        = 0x08,
-	FRAME_TYPE_MANAGEMENT  = 0x00,
-	FRAME_TYPE_RESERVED    = 0x0C,
-	FRAME_TYPE_FORCE_32BIT = 0xFFFFFFFF
-};
-
 enum sub_frame_type {
 	ASSOC_REQ             = 0x00,
 	ASSOC_RSP             = 0x10,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0ea22ab..3cd97dd 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -252,12 +252,6 @@ struct reg_frame {
 	u8 reg_id;
 };
 
-enum p2p_listen_state {
-	P2P_IDLE,
-	P2P_LISTEN,
-	P2P_GRP_FORMATION
-};
-
 struct wilc;
 struct host_if_drv {
 	struct user_scan_req usr_scan_req;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index e4a7bf5..85ac878 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -176,12 +176,6 @@ enum {
 };
 
 enum {
-	DONT_RESET		= 0,
-	DO_RESET		= 1,
-	NO_REQUEST		= 2,
-};
-
-enum {
 	REKEY_DISABLE		= 1,
 	REKEY_TIME_BASE,
 	REKEY_PKT_BASE,
@@ -195,17 +189,6 @@ enum {
 };
 
 enum {
-	PRI_HIGH_RSSI		= 0x00,
-	PRI_LOW_RSSI		= 0x04,
-	PRI_DETECT		= 0x08
-};
-
-enum {
-	CH_FILTER_OFF		= 0x00,
-	CH_FILTER_ON		= 0x10
-};
-
-enum {
 	AUTO_PROT		= 0,	/* Auto */
 	NO_PROT,			/* Do not use any protection */
 	ERP_PROT,			/* Protect all ERP frame exchanges */
@@ -244,15 +227,6 @@ enum {
 	MIMO_MODE		= 3,	/* power save disable */
 };
 
-enum {
-	DISABLE_SELF_CTS,
-	ENABLE_SELF_CTS,
-	DISABLE_TX_ABORT,
-	ENABLE_TX_ABORT,
-	HW_TRIGGER_ABORT,
-	SW_TRIGGER_ABORT,
-};
-
 enum wid_type {
 	WID_CHAR		= 0,
 	WID_SHORT		= 1,
-- 
2.7.4
