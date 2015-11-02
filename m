Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7282 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbKBItF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:05 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/38] staging: wilc1000: rename gau8MulticastMacAddrList variable
Date: Mon, 2 Nov 2015 17:50:51 +0900
Message-ID: <1446454281-22484-8-git-send-email-glen.lee@atmel.com> (sfid-20151102_094909_348436_8AD0A095)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames gau8MulticastMacAddrList variable to multicast_mac_addr_list
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c |  5 +++--
 drivers/staging/wilc1000/linux_wlan.c     | 11 ++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 584f718..de84c5d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -243,7 +243,7 @@ static struct semaphore hif_sema_wait_response;
 static struct semaphore hif_sema_deinit;
 static struct timer_list periodic_rssi;
 
-u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
@@ -2804,7 +2804,8 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
 	if ((strHostIfSetMulti->cnt) > 0)
-		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
+		memcpy(pu8CurrByte, multicast_mac_addr_list,
+		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3422d99..315906b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -47,7 +47,7 @@
 
 extern bool g_obtainingIP;
 extern void resolve_disconnect_aberration(void *drvHandler);
-extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+extern u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 extern struct timer_list hDuringIpTimer;
 
 static int linux_wlan_device_power(int on_off)
@@ -1347,9 +1347,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	/* Store all of the multicast addresses in the hardware filter */
 	netdev_for_each_mc_addr(ha, dev)
 	{
-		memcpy(gau8MulticastMacAddrList[i], ha->addr, ETH_ALEN);
+		memcpy(multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
 		PRINT_D(INIT_DBG, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
-			gau8MulticastMacAddrList[i][0], gau8MulticastMacAddrList[i][1], gau8MulticastMacAddrList[i][2], gau8MulticastMacAddrList[i][3], gau8MulticastMacAddrList[i][4], gau8MulticastMacAddrList[i][5]);
+			multicast_mac_addr_list[i][0],
+			multicast_mac_addr_list[i][1],
+			multicast_mac_addr_list[i][2],
+			multicast_mac_addr_list[i][3],
+			multicast_mac_addr_list[i][4],
+			multicast_mac_addr_list[i][5]);
 		i++;
 	}
 
-- 
1.9.1

