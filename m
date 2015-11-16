Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:58529 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbKPOF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/19] staging/wilc1000: make symbols static if possible
Date: Mon, 16 Nov 2015 15:04:53 +0100
Message-Id: <1447682710-2908925-3-git-send-email-arnd@arndb.de> (sfid-20151116_151332_079376_5E976338)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All symbols that are only referenced in the file that defines
them can be declared 'static' to avoid namespace pollution,
to produce better object code, and to make the source more
readable.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile                 |  3 +-
 drivers/staging/wilc1000/coreconfigurator.c       |  4 +-
 drivers/staging/wilc1000/host_interface.c         | 35 ++++++++------
 drivers/staging/wilc1000/host_interface.h         |  8 ----
 drivers/staging/wilc1000/linux_mon.c              |  6 +--
 drivers/staging/wilc1000/linux_wlan.c             | 19 ++++----
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 56 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  1 -
 drivers/staging/wilc1000/wilc_wlan.c              | 23 ++++++----
 10 files changed, 81 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 650123df0b4c..9696f69bda48 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -8,8 +8,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
 
-ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
-		-Wno-unused-function -DWILC_DEBUGFS
+ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
 ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index fd7240c9da3e..eef06cdcc905 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -285,7 +285,7 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
+static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 {
 	u16 u16index;
 
@@ -313,7 +313,7 @@ u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 
 /* This function gets the current channel information from
  * the 802.11n beacon/probe response frame */
-u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
+static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 {
 	u16 index;
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6c205b97293d..93bdb224f973 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -234,7 +234,7 @@ struct join_bss_param {
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 bool g_obtainingIP;
-u8 P2P_LISTEN_STATE;
+static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
@@ -259,10 +259,10 @@ static u8 del_beacon;
 static u32 clients_count;
 
 static u8 *join_req;
-u8 *info_element;
+static u8 *info_element;
 static u8 mode_11i;
-u8 auth_type;
-u32 join_req_size;
+static u8 auth_type;
+static u32 join_req_size;
 static u32 info_element_size;
 static struct host_if_drv *join_req_drv;
 #define REAL_JOIN_REQ 0
@@ -396,7 +396,9 @@ static s32 handle_set_operation_mode(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
+static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx);
+
+static s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -430,7 +432,7 @@ s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
+static s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -817,6 +819,9 @@ static void Handle_wait_msg_q_empty(void)
 	up(&hif_sema_wait_response);
 }
 
+static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
+			   enum scan_event enuEvent);
+
 static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
@@ -1483,6 +1488,11 @@ done:
 	return result;
 }
 
+static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+				       u8 *pu8AssocRespInfo,
+				       u32 u32MaxAssocRespInfoLen,
+				       u32 *pu32RcvdAssocRespInfoLen);
+
 static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
@@ -2140,7 +2150,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 	up(&hif_drv->sem_get_link_speed);
 }
 
-s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, result = 0;
@@ -3534,11 +3544,10 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return result;
 }
 
-
-s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
-				u8 *pu8AssocRespInfo,
-				u32 u32MaxAssocRespInfoLen,
-				u32 *pu32RcvdAssocRespInfoLen)
+static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+				       u8 *pu8AssocRespInfo,
+				       u32 u32MaxAssocRespInfoLen,
+				       u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -4706,7 +4715,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	return result;
 }
 
-s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c1ed2e236ee2..312da75fc02e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -338,10 +338,6 @@ s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 			  u8 u8channel, void *pJoinParams);
 s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
-s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv,
-				u8 *pu8AssocRespInfo,
-				u32 u32MaxAssocRespInfoLen,
-				u32 *pu32RcvdAssocRespInfoLen);
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
 s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
@@ -379,7 +375,6 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv,
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv,
 				  char *pBSSID,
 				  char TID);
-s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
 s32 host_int_remain_on_channel(struct host_if_drv *hWFIDrv,
 			       u32 u32SessionID,
 			       u32 u32duration,
@@ -394,9 +389,6 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv,
 int host_int_set_wfi_drv_handler(struct host_if_drv *address);
 int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler,
-			   enum scan_event enuEvent);
-
 void host_int_freeJoinParams(void *pJoinParams);
 
 s32 host_int_get_statistics(struct host_if_drv *hWFIDrv,
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 589a11fd977c..2d518acb4af3 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -29,9 +29,9 @@ static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
 
-u8 srcAdd[6];
-u8 bssid[6];
-u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+static u8 srcAdd[6];
+static u8 bssid[6];
+static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 /**
  *  @brief      WILC_WFI_monitor_rx
  *  @details
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 086f1dbfb157..b95dba74a37d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -225,9 +225,8 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 	}
 	return IRQ_WAKE_THREAD;
 }
-#endif
 
-irqreturn_t isr_bh_routine(int irq, void *userdata)
+static irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -246,7 +245,6 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	return IRQ_HANDLED;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static int init_irq(struct net_device *dev)
 {
 	int ret = 0;
@@ -333,7 +331,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 	}
 }
 
-struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
+static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 {
 	u8 *bssid, *bssid1;
 	int i = 0;
@@ -839,7 +837,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 	}
 }
 
-int wlan_init_locks(struct net_device *dev)
+static int wlan_init_locks(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wl;
@@ -884,7 +882,7 @@ static int wlan_deinit_locks(struct net_device *dev)
 	return 0;
 }
 
-void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
+static void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
@@ -895,7 +893,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 #endif
 }
 
-int wlan_initialize_threads(struct net_device *dev)
+static int wlan_initialize_threads(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -921,7 +919,6 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wl;
-
 	nic = netdev_priv(dev);
 	wl = nic->wilc;
 
@@ -1049,7 +1046,7 @@ _fail_locks_:
 	return ret;
 }
 
-int mac_init_fn(struct net_device *ndev)
+static int mac_init_fn(struct net_device *ndev)
 {
 	netif_start_queue(ndev);
 	netif_stop_queue(ndev);
@@ -1131,7 +1128,7 @@ int mac_open(struct net_device *ndev)
 	return 0;
 }
 
-struct net_device_stats *mac_stats(struct net_device *dev)
+static struct net_device_stats *mac_stats(struct net_device *dev)
 {
 	perInterface_wlan_t *nic = netdev_priv(dev);
 
@@ -1325,7 +1322,7 @@ int mac_close(struct net_device *ndev)
 	return 0;
 }
 
-int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
+static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
 	u8 *buff = NULL;
 	s8 rssi;
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 9e8ba04ca9c8..a0640ebe904e 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -39,18 +39,18 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 };
 
 
+#ifndef WILC_SDIO_IRQ_GPIO
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
 	struct wilc_sdio *wl_sdio;
 
 	wl_sdio = sdio_get_drvdata(func);
 
-#ifndef WILC_SDIO_IRQ_GPIO
 	sdio_release_host(func);
 	wilc_handle_isr(wl_sdio->wilc);
 	sdio_claim_host(func);
-#endif
 }
+#endif
 
 
 int linux_sdio_cmd52(sdio_cmd52_t *cmd)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 849f86b5ff30..842f0e4bec97 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -24,10 +24,10 @@
 extern int mac_open(struct net_device *ndev);
 extern int mac_close(struct net_device *ndev);
 
-tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
-u32 u32LastScannedNtwrksCountShadow;
+static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
+static u32 u32LastScannedNtwrksCountShadow;
 struct timer_list hDuringIpTimer;
-struct timer_list hAgingTimer;
+static struct timer_list hAgingTimer;
 static u8 op_ifcs;
 extern u8 u8ConnectedSSID[6];
 
@@ -90,15 +90,15 @@ struct p2p_mgmt_data {
 };
 
 /*Global variable used to state the current  connected STA channel*/
-u8 u8WLANChannel = INVALID_CHANNEL;
+static u8 u8WLANChannel = INVALID_CHANNEL;
 
-u8 curr_channel;
+static u8 curr_channel;
 
-u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
-u8 u8P2Plocalrandom = 0x01;
-u8 u8P2Precvrandom = 0x00;
-u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
-bool bWilc_ie;
+static u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
+static u8 u8P2Plocalrandom = 0x01;
+static u8 u8P2Precvrandom = 0x00;
+static u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
+static bool bWilc_ie;
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.channels = WILC_WFI_2ghz_channels,
@@ -113,19 +113,19 @@ struct add_key_params {
 	bool pairwise;
 	u8 *mac_addr;
 };
-struct add_key_params g_add_gtk_key_params;
-struct wilc_wfi_key g_key_gtk_params;
-struct add_key_params g_add_ptk_key_params;
-struct wilc_wfi_key g_key_ptk_params;
-struct wilc_wfi_wep_key g_key_wep_params;
-bool g_ptk_keys_saved;
-bool g_gtk_keys_saved;
-bool g_wep_keys_saved;
+static struct add_key_params g_add_gtk_key_params;
+static struct wilc_wfi_key g_key_gtk_params;
+static struct add_key_params g_add_ptk_key_params;
+static struct wilc_wfi_key g_key_ptk_params;
+static struct wilc_wfi_wep_key g_key_wep_params;
+static bool g_ptk_keys_saved;
+static bool g_gtk_keys_saved;
+static bool g_wep_keys_saved;
 
 #define AGING_TIME	(9 * 1000)
 #define duringIP_TIME 15000
 
-void clear_shadow_scan(void *pUserVoid)
+static void clear_shadow_scan(void *pUserVoid)
 {
 	int i;
 
@@ -147,7 +147,7 @@ void clear_shadow_scan(void *pUserVoid)
 
 }
 
-u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
+static u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 {
 	u8 i;
 	int rssi_v = 0;
@@ -160,7 +160,7 @@ u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
+static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -200,7 +200,7 @@ void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 
 }
 
-void reset_shadow_found(void *pUserVoid)
+static void reset_shadow_found(void *pUserVoid)
 {
 	int i;
 
@@ -210,7 +210,7 @@ void reset_shadow_found(void *pUserVoid)
 	}
 }
 
-void update_scan_time(void *pUserVoid)
+static void update_scan_time(void *pUserVoid)
 {
 	int i;
 
@@ -256,7 +256,7 @@ static void clear_duringIP(unsigned long arg)
 	g_obtainingIP = false;
 }
 
-int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
 	int state = -1;
 	int i;
@@ -279,7 +279,7 @@ int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 	return state;
 }
 
-void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
+static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
 	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
@@ -1766,7 +1766,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
  *  @version
  */
 
-void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
+static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -1818,7 +1818,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
  *  @date	12 DEC 2012
  *  @version
  */
-void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
+static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -3285,7 +3285,7 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-struct wireless_dev *WILC_WFI_CfgAlloc(void)
+static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 {
 
 	struct wireless_dev *wdev;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index d7bdca1f4c5b..9f9a9aeb3655 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -90,7 +90,6 @@ static const struct ieee80211_txrx_stypes
 #define WILC_WFI_DWELL_PASSIVE 100
 #define WILC_WFI_DWELL_ACTIVE  40
 
-struct wireless_dev *WILC_WFI_CfgAlloc(void);
 struct wireless_dev *wilc_create_wiphy(struct net_device *net);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f702cca2095a..5c8c59257f58 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -40,7 +40,9 @@ typedef struct {
 
 static wilc_wlan_dev_t g_wlan;
 
+#ifdef WILC_OPTIMIZE_SLEEP_INT
 static inline void chip_allow_sleep(void);
+#endif
 static inline void chip_wakeup(void);
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
@@ -81,6 +83,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 	mutex_unlock(&g_linux_wlan->hif_cs);
 }
 
+#ifdef TCP_ACK_FILTER
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
@@ -99,6 +102,7 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 	}
 	p->txq_entries -= 1;
 }
+#endif
 
 static struct txq_entry_t *
 wilc_wlan_txq_remove_from_head(struct net_device *dev)
@@ -209,16 +213,17 @@ struct pending_acks_info {
 	struct txq_entry_t  *txqe;
 };
 
+
 #define NOT_TCP_ACK			(-1)
 
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
-struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
-struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
+static struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
+static struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
 
-u32 pending_base;
-u32 tcp_session;
-u32 pending_acks;
+static u32 pending_base;
+static u32 tcp_session;
+static u32 pending_acks;
 
 static inline int init_tcp_tracking(void)
 {
@@ -386,17 +391,19 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 }
 #endif
 
-bool enabled = false;
+static bool enabled = false;
 
 void enable_tcp_ack_filter(bool value)
 {
 	enabled = value;
 }
 
-bool is_tcp_ack_filter_enabled(void)
+#ifdef TCP_ACK_FILTER
+static bool is_tcp_ack_filter_enabled(void)
 {
 	return enabled;
 }
+#endif
 
 static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 {
@@ -1582,7 +1589,7 @@ void wilc_bus_set_default_speed(void)
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
 
-u32 init_chip(struct net_device *dev)
+static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
-- 
2.1.0.rc2

