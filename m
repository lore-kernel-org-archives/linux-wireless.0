Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22969 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeGSGq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/23] staging: wilc1000: remove the mutliple #define used for same macro
Date: Thu, 19 Jul 2018 04:15:08 +0530
Message-ID: <1531953919-20804-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080506_816602_06708224)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved the same #define in common header file instead of having their
declartion in different files.

Below macros are moved to header file:
TCP_ACK_FILTER_LINK_SPEED_THRESH
DEFAULT_LINK_SPEED
GET_PKT_OFFSET

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 3 ---
 drivers/staging/wilc1000/linux_mon.c              | 1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 -----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 5 +++++
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0ffe205..8649225 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6,9 +6,6 @@
 
 #define FALSE_FRMWR_CHANNEL			100
 
-#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
-#define DEFAULT_LINK_SPEED			72
-
 #define REAL_JOIN_REQ				0
 
 struct host_if_wpa_attr {
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1c7e6e1..bd09611 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -20,7 +20,6 @@ static u8 bssid[6];
 
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
-#define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
 #define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
 			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1a27e81..e561dce 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -77,11 +77,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
 
-#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
-#define DEFAULT_LINK_SPEED			72
-
-#define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
-
 static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 87f8cdc..765681a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -21,6 +21,11 @@
 
 #define NUM_REG_FRAME				2
 
+#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
+#define DEFAULT_LINK_SPEED			72
+
+#define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
+
 struct wilc_wfi_stats {
 	unsigned long rx_packets;
 	unsigned long tx_packets;
-- 
2.7.4
