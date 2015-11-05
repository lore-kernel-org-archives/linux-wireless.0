Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26480 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbbKEFeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:34:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 08/38] staging: wilc1000: rename gau8MulticastMacAddrList variable
Date: Thu, 5 Nov 2015 14:36:09 +0900
Message-ID: <1446701799-24870-8-git-send-email-glen.lee@atmel.com> (sfid-20151105_063420_022234_46D64EA5)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
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
index 8494a032..d0e4039 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -243,7 +243,7 @@ static struct semaphore hif_sema_wait_response;
 static struct semaphore hif_sema_deinit;
 static struct timer_list periodic_rssi;
 
-u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
@@ -2713,7 +2713,8 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
 	if ((strHostIfSetMulti->cnt) > 0)
-		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
+		memcpy(pu8CurrByte, multicast_mac_addr_list,
+		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 09ddba2..1e14e97 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -46,7 +46,7 @@
 
 extern bool g_obtainingIP;
 extern void resolve_disconnect_aberration(void *drvHandler);
-extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+extern u8 multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 extern struct timer_list hDuringIpTimer;
 
 static int linux_wlan_device_power(int on_off)
@@ -1343,9 +1343,14 @@ static void wilc_set_multicast_list(struct net_device *dev)
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

