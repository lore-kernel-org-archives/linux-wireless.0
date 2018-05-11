Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48280 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbeEKIPW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:15:22 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 26/30] staging: wilc1000: remove 'flag' argument from wilc_mac_indicate()
Date: Fri, 11 May 2018 13:43:27 +0530
Message-ID: <1526026411-11058-27-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101526_222771_B096A071)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'flag' function parameter in wilc_mac_indicate() as only one
condition was handled using that parameter. Also removed unnecessary
call to wilc_mac_indicate() as no operation was performed in that
function call.
After above changes below macros are not required anymore.
WILC_MAC_INDICATE_STATUS	0x1
WILC_MAC_INDICATE_SCAN		0x2

This changes also helped in resolving the line over 80 chars issue
found by checkatpch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 17 +++++++----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c          |  7 +------
 drivers/staging/wilc1000/wilc_wlan_if.h       |  3 ---
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7b883c0..02e6b13 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -176,19 +176,16 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-void wilc_mac_indicate(struct wilc *wilc, int flag)
+void wilc_mac_indicate(struct wilc *wilc)
 {
 	int status;
 
-	if (flag == WILC_MAC_INDICATE_STATUS) {
-		wilc_wlan_cfg_get_val(WID_STATUS,
-				      (unsigned char *)&status, 4);
-		if (wilc->mac_status == MAC_STATUS_INIT) {
-			wilc->mac_status = status;
-			complete(&wilc->sync_event);
-		} else {
-			wilc->mac_status = status;
-		}
+	wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
+	if (wilc->mac_status == MAC_STATUS_INIT) {
+		wilc->mac_status = status;
+		complete(&wilc->sync_event);
+	} else {
+		wilc->mac_status = status;
 	}
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8849924..607dae0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -182,7 +182,7 @@ struct wilc_wfi_mon_priv {
 };
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
-void wilc_mac_indicate(struct wilc *wilc, int flag);
+void wilc_mac_indicate(struct wilc *wilc);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7147e0c..d4ebbf6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -816,12 +816,7 @@ static void wilc_wlan_handle_rx_buff(struct wilc *wilc, u8 *buffer, int size)
 					if (wilc->cfg_seq_no == rsp.seq_no)
 						complete(&wilc->cfg_event);
 				} else if (rsp.type == WILC_CFG_RSP_STATUS) {
-					wilc_mac_indicate(wilc,
-							  WILC_MAC_INDICATE_STATUS);
-
-				} else if (rsp.type == WILC_CFG_RSP_SCAN) {
-					wilc_mac_indicate(wilc,
-							  WILC_MAC_INDICATE_SCAN);
+					wilc_mac_indicate(wilc);
 				}
 			}
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index aa0731e..e4a7bf5 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -47,9 +47,6 @@ struct sdio_cmd53 {
 	u32 block_size;
 };
 
-#define WILC_MAC_INDICATE_STATUS	0x1
-#define WILC_MAC_INDICATE_SCAN		0x2
-
 #define MAC_STATUS_INIT			-1
 #define MAC_STATUS_CONNECTED		1
 #define MAC_STATUS_DISCONNECTED		0
-- 
2.7.4
