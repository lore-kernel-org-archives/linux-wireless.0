Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:13800 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeBZQgA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:36:00 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/8] staging: wilc1000: move multiple definition of same macro to common header
Date: Mon, 26 Feb 2018 22:01:58 +0530
Message-ID: <1519662722-15761-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173607_119376_AD5C3494)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the same #define from multiple '.c' files to common header file.
Instead of having same macro in different '.c' files, now kept in
common '.h' file.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 3 ---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 ---
 drivers/staging/wilc1000/wilc_wlan.c              | 4 ----
 drivers/staging/wilc1000/wilc_wlan.h              | 5 +++++
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 91d49c4..bbdfc7a 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -40,9 +40,6 @@ static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
-#define IS_MANAGMEMENT				0x100
-#define IS_MANAGMEMENT_CALLBACK			0x080
-#define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
 void WILC_WFI_monitor_rx(u8 *buff, u32 size)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 621810d..3f78abc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -85,9 +85,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
-#define IS_MANAGMEMENT				0x100
-#define IS_MANAGMEMENT_CALLBACK			0x080
-#define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
 static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ee7102d..f762785 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -810,10 +810,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			if (pkt_len == 0 || tp_len == 0)
 				break;
 
-			#define IS_MANAGMEMENT				0x100
-			#define IS_MANAGMEMENT_CALLBACK			0x080
-			#define IS_MGMT_STATUS_SUCCES			0x040
-
 			if (pkt_offset & IS_MANAGMEMENT) {
 				pkt_offset &= ~(IS_MANAGMEMENT |
 						IS_MANAGMEMENT_CALLBACK |
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index da71731..fa157a6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -195,6 +195,11 @@
 #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
 /*time for expiring the completion of cfg packets*/
 #define CFG_PKTS_TIMEOUT	2000
+
+#define IS_MANAGMEMENT		0x100
+#define IS_MANAGMEMENT_CALLBACK	0x080
+#define IS_MGMT_STATUS_SUCCES	0x040
+
 /********************************************
  *
  *      Debug Type
-- 
2.7.4
