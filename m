Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25363 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbIXJMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:12:46 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/15] staging: wilc1000: remove function pointer rx_indicate
Date: Thu, 24 Sep 2015 18:14:52 +0900
Message-ID: <1443086106-20482-1-git-send-email-glen.lee@atmel.com> (sfid-20150924_111249_411689_327874F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer rx_indicate and call the function
frmw_to_linux directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 11 +++++------
 drivers/staging/wilc1000/wilc_wlan_if.h       |  1 -
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1f1b34b..8119c40 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -106,7 +106,6 @@ extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
-void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 static int  mac_init_fn(struct net_device *ndev);
 int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int  mac_open(struct net_device *ndev);
@@ -1095,7 +1094,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 #endif
 
 	/*for now - to be revised*/
-	nwi->net_func.rx_indicate = frmw_to_linux;
 	nwi->net_func.rx_complete = linux_wlan_rx_complete;
 	nwi->indicate_func.mac_indicate = linux_wlan_mac_indicate;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 90fe1e2..72220df 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -216,5 +216,6 @@ struct WILC_WFI_mon_priv {
 };
 
 extern struct net_device *WILC_WFI_devs[];
+void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9f5b5e6..56af108 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1199,12 +1199,11 @@ static void wilc_wlan_handle_rxq(void)
 			{
 
 				if (!is_cfg_packet) {
-
-					if (p->net_func.rx_indicate) {
-						if (pkt_len > 0) {
-							p->net_func.rx_indicate(&buffer[offset], pkt_len, pkt_offset);
-							has_packet = 1;
-						}
+					if (pkt_len > 0) {
+						frmw_to_linux(&buffer[offset],
+							      pkt_len,
+							      pkt_offset);
+						has_packet = 1;
 					}
 				} else {
 					wilc_cfg_rsp_t rsp;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8652cf6..f878ca5 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -100,7 +100,6 @@ typedef struct {
 } wilc_wlan_io_func_t;
 
 typedef struct {
-	void (*rx_indicate)(u8 *, u32, u32);
 	void (*rx_complete)(void);
 } wilc_wlan_net_func_t;
 
-- 
1.9.1

