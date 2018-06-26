Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2558 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeFZGHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:19 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/12] staging: wilc1000: remove unused marco related to HIF commands
Date: Tue, 26 Jun 2018 11:37:04 +0530
Message-ID: <1529993234-27294-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080728_038683_E3D16249)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After removing the multiplexing of hif commands in hif_if_work()
macros prefix with 'HOST_IF_MSG_' are not required. Also 'id' field in
host_if_msg is not required anymore.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 36 -------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4f6008e..998e0ab 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,41 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "wilc_wfi_netdevice.h"
 
-#define HOST_IF_MSG_SCAN                        0
-#define HOST_IF_MSG_CONNECT                     1
-#define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        2
-#define HOST_IF_MSG_KEY                         3
-#define HOST_IF_MSG_RCVD_NTWRK_INFO             4
-#define HOST_IF_MSG_RCVD_SCAN_COMPLETE          5
-#define HOST_IF_MSG_CFG_PARAMS                  6
-#define HOST_IF_MSG_SET_CHANNEL                 7
-#define HOST_IF_MSG_DISCONNECT                  8
-#define HOST_IF_MSG_GET_RSSI                    9
-#define HOST_IF_MSG_ADD_BEACON                  11
-#define HOST_IF_MSG_DEL_BEACON                  12
-#define HOST_IF_MSG_ADD_STATION                 13
-#define HOST_IF_MSG_DEL_STATION                 14
-#define HOST_IF_MSG_EDIT_STATION                15
-#define HOST_IF_MSG_SCAN_TIMER_FIRED            16
-#define HOST_IF_MSG_CONNECT_TIMER_FIRED         17
-#define HOST_IF_MSG_POWER_MGMT                  18
-#define HOST_IF_MSG_GET_INACTIVETIME            19
-#define HOST_IF_MSG_REMAIN_ON_CHAN              20
-#define HOST_IF_MSG_REGISTER_FRAME              21
-#define HOST_IF_MSG_LISTEN_TIMER_FIRED          22
-#define HOST_IF_MSG_SET_WFIDRV_HANDLER          24
-#define HOST_IF_MSG_GET_MAC_ADDRESS             26
-#define HOST_IF_MSG_SET_OPERATION_MODE          27
-#define HOST_IF_MSG_SET_IPADDRESS               28
-#define HOST_IF_MSG_GET_IPADDRESS               29
-#define HOST_IF_MSG_GET_STATISTICS              31
-#define HOST_IF_MSG_SET_MULTICAST_FILTER        32
-#define HOST_IF_MSG_DEL_BA_SESSION              34
-#define HOST_IF_MSG_DEL_ALL_STA                 36
-#define HOST_IF_MSG_SET_TX_POWER		38
-#define HOST_IF_MSG_GET_TX_POWER		39
-#define HOST_IF_MSG_EXIT                        100
-
 #define HOST_IF_SCAN_TIMEOUT                    4000
 #define HOST_IF_CONNECT_TIMEOUT                 9500
 
@@ -180,7 +145,6 @@ union message_body {
 };
 
 struct host_if_msg {
-	u16 id;
 	union message_body body;
 	struct wilc_vif *vif;
 	struct work_struct work;
-- 
2.7.4
