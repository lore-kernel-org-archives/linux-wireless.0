Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21521 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbIHIIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 04:08:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: delete definition USE_WIRELESS
Date: Tue, 8 Sep 2015 17:08:03 +0900
Message-ID: <1441699683-31463-5-git-send-email-tony.cho@atmel.com> (sfid-20150908_100818_693316_09FAC8AE)
In-Reply-To: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
References: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kim, Leo" <leo.kim@atmel.com>

The preprocessor definition, USE_WIRELESS is always in use.
So, this patch deletes the definitions from the makefile and source codes.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Makefile     |  2 +-
 drivers/staging/wilc1000/linux_mon.c  |  8 --------
 drivers/staging/wilc1000/linux_wlan.c | 33 ---------------------------------
 drivers/staging/wilc1000/wilc_wlan.c  |  4 ----
 4 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 3b6bc7b..8336a89 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -11,7 +11,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
 		-DPLL_WORKAROUND -DCONNECT_DIRECT  -DAGING_ALG \
 		-DWILC_PARSE_SCAN_IN_HOST -DDISABLE_PWRSAVE_AND_SCAN_DURING_IP \
-		-Wno-unused-function -DUSE_WIRELESS -DWILC_DEBUGFS
+		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
 ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index dd80071..d873877 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -31,9 +31,7 @@ extern linux_wlan_t *g_linux_wlan;
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-#if USE_WIRELESS
 extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
-#endif
 
 
 u8 srcAdd[6];
@@ -346,7 +344,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	PRINT_INFO(HOSTAPD_DBG, "SKB netdevice name = %s\n", skb->dev->name);
 	PRINT_INFO(HOSTAPD_DBG, "MONITOR real dev name = %s\n", mon_priv->real_ndev->name);
 
-	#if USE_WIRELESS
 	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcAdd, &skb->data[10], 6);
 	memcpy(bssid, &skb->data[16], 6);
@@ -357,7 +354,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		dev_kfree_skb(skb);
 	} else
 		ret = mac_xmit(skb, mon_priv->real_ndev);
-	#endif
 
 	/* return NETDEV_TX_OK; */
 	return ret;
@@ -388,7 +384,6 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 	dev->type = ARPHRD_IEEE80211_RADIOTAP;
 	eth_zero_addr(dev->dev_addr);
 
-	#ifdef USE_WIRELESS
 	{
 		/* u8 * mac_add; */
 		unsigned char mac_add[] = {0x00, 0x50, 0xc2, 0x5e, 0x10, 0x8f};
@@ -398,9 +393,6 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 		/* mac_add[ETH_ALEN-1]+=1; */
 		memcpy(dev->dev_addr, mac_add, ETH_ALEN);
 	}
-	#else
-	dev->dev_addr[0] = 0x12;
-	#endif
 
 }
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b24cb75..70a9450 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2,9 +2,7 @@
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#ifdef USE_WIRELESS
 #include "wilc_wfi_cfgoperations.h"
-#endif
 
 #include "linux_wlan_common.h"
 
@@ -947,12 +945,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                    ( In BSS Station Set SSID to "" (null string)      */
 	/*                      to enable Broadcast SSID suppport )              */
 	/*  --------------------------------------------------------------       */
-#ifndef USE_WIRELESS
-	strcpy(c_val, "nwifi");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SSID, c_val, (strlen(c_val) + 1), 0, 0))
-		goto _fail_;
-#endif
-
 	c_val[0] = 0;
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
@@ -1747,14 +1739,12 @@ int mac_open(struct net_device *ndev)
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
-	#ifdef USE_WIRELESS
 	ret = WILC_WFI_InitHostInt(ndev);
 	if (ret < 0) {
 		PRINT_ER("Failed to initialize host interface\n");
 
 		return ret;
 	}
-	#endif
 
 	/*initialize platform*/
 	PRINT_D(INIT_DBG, "*** re-init ***\n");
@@ -1992,20 +1982,16 @@ int mac_close(struct net_device *ndev)
 		/* Stop the network interface queue */
 		netif_stop_queue(nic->wilc_netdev);
 
-		#ifdef USE_WIRELESS
 		WILC_WFI_DeInitHostInt(nic->wilc_netdev);
-		#endif
 	}
 
 	if (g_linux_wlan->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
 		g_linux_wlan->close = 1;
 		wilc1000_wlan_deinit(g_linux_wlan);
-		#ifdef USE_WIRELESS
 		#ifdef WILC_AP_EXTERNAL_MLME
 		WILC_WFI_deinit_mon_interface();
 		#endif
-		#endif
 	}
 
 	up(&close_exit_sync);
@@ -2025,14 +2011,11 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	s32 s32Error = WILC_SUCCESS;
 
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
-	#ifdef USE_WIRELESS
 	nic = netdev_priv(ndev);
 
 	if (!g_linux_wlan->wilc1000_initialized)
 		return 0;
 
-	#endif
-
 	switch (cmd) {
 
 	/* ]] 2013-06-24 */
@@ -2049,13 +2032,10 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				return PTR_ERR(buff);
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
-
-					#ifdef USE_WIRELESS
 				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 				s32Error = host_int_get_rssi(priv->hWILCWFIDrv, &(rssi));
 				if (s32Error)
 					PRINT_ER("Failed to send get rssi param's message queue ");
-					#endif
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
 
 				/*Rounding up the rssi negative value*/
@@ -2143,13 +2123,6 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 
 		/* nic = netdev_priv(wilc_netdev); */
 
-#ifdef USE_WIRELESS
-		/*	if(nic->monitor_flag)
-		 *      {
-		 *              WILC_WFI_monitor_rx(nic->wilc_netdev,skb);
-		 *              return;
-		 *      }*/
-#endif
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
 			#ifndef TCP_ENHANCEMENTS
 		/*get source and dest ip addresses*/
@@ -2248,7 +2221,6 @@ int wilc_netdev_init(void)
 		g_linux_wlan->u8NoIfcs++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
-		#ifdef USE_WIRELESS
 		{
 			struct wireless_dev *wdev;
 			/*Register WiFi*/
@@ -2274,7 +2246,6 @@ int wilc_netdev_init(void)
 			nic->netstats.tx_bytes = 0;
 
 		}
-		#endif
 
 		if (register_netdev(ndev)) {
 			PRINT_ER("Device couldn't be registered - %s\n", ndev->name);
@@ -2375,21 +2346,17 @@ static void __exit exit_wilc_driver(void)
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			#ifdef USE_WIRELESS
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
 			WILC_WFI_WiphyFree(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-			#endif
 			PRINT_D(INIT_DBG, "Freeing netdev...\n");
 			free_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 		}
 	}
 
-#ifdef USE_WIRELESS
 #ifdef WILC_AP_EXTERNAL_MLME
 	/* Bug 4600 : WILC_WFI_deinit_mon_interface was already called at mac_close */
 	/* WILC_WFI_deinit_mon_interface(); */
 #endif
-#endif
 
 	/* if(g_linux_wlan->open_ifcs==0) */
 	{
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b0ae09d..4c54ea7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1230,11 +1230,7 @@ static void wilc_wlan_handle_rxq(void)
 				/* reset mgmt indicator bit, to use pkt_offeset in furthur calculations */
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
-#ifdef USE_WIRELESS
 				WILC_WFI_mgmt_rx(&buffer[offset + HOST_HDR_OFFSET], pkt_len);
-
-#endif
-
 			}
 			/* BUG4530 fix */
 			else
-- 
1.9.1

