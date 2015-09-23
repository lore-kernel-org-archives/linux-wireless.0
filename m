Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18618 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbIWHIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 03:08:48 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/4] staging: wilc1000: remove define DISABLE_PWRSAVE_AND_SCAN_DURING_IP
Date: Wed, 23 Sep 2015 16:10:53 +0900
Message-ID: <1442992255-23005-2-git-send-email-glen.lee@atmel.com> (sfid-20150923_090852_188196_1E7AB4C8)
In-Reply-To: <1442992255-23005-1-git-send-email-glen.lee@atmel.com>
References: <1442992255-23005-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver will use define DISABLE_PWRSAVE_AND_SCAN_DURING_IP always. So remove
the ifdef line and define in Makefile.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile                 |  2 +-
 drivers/staging/wilc1000/host_interface.c         | 22 ----------------------
 drivers/staging/wilc1000/linux_wlan.c             | 14 --------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 ----------------
 4 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index bdeffea..afae7d6 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -10,7 +10,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
 		-DPLL_WORKAROUND -DCONNECT_DIRECT  -DAGING_ALG \
-		-DWILC_PARSE_SCAN_IN_HOST -DDISABLE_PWRSAVE_AND_SCAN_DURING_IP \
+		-DWILC_PARSE_SCAN_IN_HOST \
 		-Wno-unused-function -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 158d8b8..5d1c7f4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4,9 +4,7 @@
 
 extern u8 connecting;
 
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 extern struct timer_list hDuringIpTimer;
-#endif
 
 extern u8 g_wilc_initialized;
 /*****************************************************************************/
@@ -518,9 +516,7 @@ typedef enum {
 static tstrWILC_WFIDrv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 tstrWILC_WFIDrv *terminated_handle;
 tstrWILC_WFIDrv *gWFiDrvHandle;
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 bool g_obtainingIP = false;
-#endif
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
 static WILC_MsgQueueHandle gMsgQHostIF;
@@ -1307,14 +1303,12 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler,
 		goto ERRORHANDLER;
 	}
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
 	}
-	#endif
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 
@@ -2525,20 +2519,15 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 			 *  else change state to IDLE */
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
-				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-
 				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
-				#endif
 
 				PRINT_D(HOSTINF_DBG, "MAC status : CONNECTED and Connect Status : Successful\n");
 				pstrWFIDrv->enuHostIFstate = HOST_IF_CONNECTED;
 
-				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
 				g_obtainingIP = true;
 				mod_timer(&hDuringIpTimer,
 					  jiffies + msecs_to_jiffies(10000));
-				#endif
 
 				#ifdef WILC_PARSE_SCAN_IN_HOST
 				/* open a BA session if possible */
@@ -2601,11 +2590,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 			strDisconnectNotifInfo.ie_len = 0;
 
 			if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult != NULL)	{
-				#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-
 				g_obtainingIP = false;
 				host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
-				#endif
 
 				pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult(CONN_DISCONN_EVENT_DISCONN_NOTIF,
 										   NULL,
@@ -3076,11 +3062,8 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-
 	g_obtainingIP = false;
 	host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
-	#endif
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
@@ -3806,13 +3789,11 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler,
 		goto ERRORHANDLER;
 	}
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (g_obtainingIP || connecting) {
 		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		s32Error = -EBUSY;
 		goto ERRORHANDLER;
 	}
-	#endif
 
 	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
 
@@ -6389,10 +6370,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 		goto _fail_timer_2;
 	}
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-
 	g_obtainingIP = false;
-	#endif
 
 	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", pstrWFIDrv);
 	/* /////////////////////////////////////// */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7857ad2..1f1b34b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -17,9 +17,7 @@
 
 #include <linux/init.h>
 #include <linux/netdevice.h>
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 #include <linux/inetdevice.h>
-#endif
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -47,16 +45,12 @@
  #define _linux_wlan_device_removal()		{}
 #endif
 
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 extern bool g_obtainingIP;
-#endif
 extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 void wilc1000_wlan_deinit(linux_wlan_t *nic);
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 extern struct timer_list hDuringIpTimer;
-#endif
 
 static int linux_wlan_device_power(int on_off)
 {
@@ -86,13 +80,11 @@ static int linux_wlan_device_detection(int on_off)
 	return 0;
 }
 
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
 static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
 };
-#endif
 
 #define wilc_wlan_deinit(nic)	{ if (&g_linux_wlan->oup != NULL)	 \
 		if (g_linux_wlan->oup.wlan_cleanup != NULL) \
@@ -196,7 +188,6 @@ static int DebuggingThreadTask(void *vp)
 }
 #endif
 
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr)
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
@@ -295,7 +286,6 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	return NOTIFY_DONE;
 
 }
-#endif
 
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
@@ -1844,9 +1834,7 @@ int wilc_netdev_init(void)
 	if (!g_linux_wlan)
 		return -ENOMEM;
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	register_inetaddr_notifier(&g_dev_notifier);
-	#endif
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 		/*allocate first ethernet device with perinterface_wlan_t as its private data*/
@@ -1970,9 +1958,7 @@ static void __exit exit_wilc_driver(void)
 
 	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
 				       || ((g_linux_wlan->strInterfaceInfo[1].wilc_netdev) != NULL))) {
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 		unregister_inetaddr_notifier(&g_dev_notifier);
-	#endif
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			nic[i] = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index de8c83d..97201ff 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -30,18 +30,14 @@ extern int mac_close(struct net_device *ndev);
 
 tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 u32 u32LastScannedNtwrksCountShadow;
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 struct timer_list hDuringIpTimer;
-#endif
 struct timer_list hAgingTimer;
 static u8 op_ifcs;
 extern u8 u8ConnectedSSID[6];
 
 u8 g_wilc_initialized = 1;
 extern linux_wlan_t *g_linux_wlan;
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 extern bool g_obtainingIP;
-#endif
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = IEEE80211_BAND_2GHZ, \
@@ -261,13 +257,11 @@ static void remove_network_from_shadow(unsigned long arg)
 	}
 }
 
-#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 static void clear_duringIP(unsigned long arg)
 {
 	PRINT_D(GENERIC_DBG, "GO:IP Obtained , enable scan\n");
 	g_obtainingIP = false;
 }
-#endif
 
 int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
@@ -619,9 +613,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 					u16ConnectStatus, GFP_KERNEL);                         /* TODO: mostafa: u16ConnectStatus to */
 		/* be replaced by pstrConnectInfo->u16ConnectStatus */
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
-		#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 		g_obtainingIP = false;
-		#endif
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		u8P2Plocalrandom = 0x01;
@@ -2716,11 +2708,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	bWilc_ie = false;
 
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	g_obtainingIP = false;
 	del_timer(&hDuringIpTimer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
-	#endif
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
 		Set_machw_change_vir_if(true);
@@ -2927,10 +2917,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
 
-		#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 		g_obtainingIP = true;
 		mod_timer(&hDuringIpTimer, jiffies + msecs_to_jiffies(duringIP_TIME));
-		#endif
 		host_int_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		/*Delete block ack has to be the latest config packet*/
 		/*sent before downloading new FW. This is because it blocks on*/
@@ -3610,9 +3598,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		setup_timer(&hAgingTimer, remove_network_from_shadow, 0);
-		#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 		setup_timer(&hDuringIpTimer, clear_duringIP, 0);
-		#endif
 	}
 	op_ifcs++;
 	if (s32Error < 0) {
@@ -3659,12 +3645,10 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	/* Clear the Shadow scan */
 	clear_shadow_scan(priv);
-	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	if (op_ifcs == 0) {
 		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
 		del_timer_sync(&hDuringIpTimer);
 	}
-	#endif
 
 	if (s32Error)
 		PRINT_ER("Error while deintializing host interface\n");
-- 
1.9.1

