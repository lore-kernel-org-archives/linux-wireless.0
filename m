Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64459 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753878AbeDRLks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:48 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/22] staging: wilc1000: remove unused macros in wilc module
Date: Wed, 18 Apr 2018 17:09:13 +0530
Message-ID: <1524051564-15497-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134051_492502_C30E463C)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the macros which are defined by not used.
Below mentioned macros are removed:
SCAN_DONE
SCAN_EVENT_DONE_ABORTED
WILC_WFI_RX_INTR
WILC_WFI_TX_INTR
WILC_WFI_TIMEOUT
WILC_WFI_DWELL_PASSIVE
WILC_WFI_DWELL_ACTIVE
MAX_SURVEY_RESULT_FRAG_SIZE
SURVEY_RESULT_LENGTH
NUM_BASIC_SWITCHES
NUM_FHSS_SWITCHES
NUM_11N_BASIC_SWITCHES
NUM_11N_HUT_SWITCHES
BA_SESSION_DEFAULT_BUFFER_SIZE
BA_SESSION_DEFAULT_TIMEOUT
BLOCK_ACK_REQ_SIZE

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 13 -------------
 drivers/staging/wilc1000/host_interface.c         |  3 ---
 drivers/staging/wilc1000/host_interface.h         |  1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  3 ---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  4 ----
 drivers/staging/wilc1000/wilc_wlan_if.h           |  2 --
 6 files changed, 26 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3f5da8c..5436fd3 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -14,19 +14,8 @@
 
 #include "wilc_wlan_if.h"
 
-#define NUM_BASIC_SWITCHES      45
-#define NUM_FHSS_SWITCHES       0
-
 #define NUM_RSSI                5
 
-#ifdef MAC_802_11N
-#define NUM_11N_BASIC_SWITCHES  25
-#define NUM_11N_HUT_SWITCHES    47
-#else
-#define NUM_11N_BASIC_SWITCHES  0
-#define NUM_11N_HUT_SWITCHES    0
-#endif
-
 #define MAC_HDR_LEN             24
 #define MAX_SSID_LEN            33
 #define FCS_LEN                 4
@@ -41,8 +30,6 @@
 #define GET_CFG              1
 
 #define MAX_STRING_LEN               256
-#define MAX_SURVEY_RESULT_FRAG_SIZE  MAX_STRING_LEN
-#define SURVEY_RESULT_LENGTH         44
 #define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
 
 #define MAC_CONNECTED                1
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b5300c..1117705 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -53,9 +53,6 @@
 #define HOST_IF_SCAN_TIMEOUT                    4000
 #define HOST_IF_CONNECT_TIMEOUT                 9500
 
-#define BA_SESSION_DEFAULT_BUFFER_SIZE          16
-#define BA_SESSION_DEFAULT_TIMEOUT              1000
-#define BLOCK_ACK_REQ_SIZE                      0x14
 #define FALSE_FRMWR_CHANNEL			100
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4b60b18..035c537 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -49,7 +49,6 @@
 #define PMKID_LEN				16
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
-#define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
 #define DRV_HANDLER_SIZE			5
 #define DRV_HANDLER_MASK			0x000000FF
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bddfbcb..9cd6be5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -79,9 +79,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
-#define WILC_WFI_DWELL_PASSIVE 100
-#define WILC_WFI_DWELL_ACTIVE  40
-
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index bd0c98a..07167637 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -9,10 +9,6 @@
 #ifndef WILC_WFI_NETDEVICE
 #define WILC_WFI_NETDEVICE
 
-#define WILC_WFI_RX_INTR 0x0001
-#define WILC_WFI_TX_INTR 0x0002
-
-#define WILC_WFI_TIMEOUT 5
 #define WILC_MAX_NUM_PMKIDS  16
 #define PMKID_LEN  16
 #define PMKID_FOUND 1
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index f129d81..eb8d819 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,8 +122,6 @@ enum {
 
 #define MAC_CONNECTED		1
 #define MAC_DISCONNECTED	0
-
-#define SCAN_DONE		TRUE
 enum {
 	PASSIVE_SCAN		= 0,
 	ACTIVE_SCAN		= 1,
-- 
2.7.4
