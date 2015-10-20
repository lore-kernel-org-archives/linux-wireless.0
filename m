Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58478 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbbJTWsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/19] staging/wilc1000: make symbols static if possible
Date: Wed, 21 Oct 2015 00:47:21 +0200
Message-Id: <1445381258-1455986-3-git-send-email-arnd@arndb.de> (sfid-20151021_005302_400617_B1432AAE)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All symbols that are only referenced in the file that defines
them can be declared 'static' to avoid namespace pollution,
to produce better object code, and to make the source more
readable.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile                 |  3 +-
 drivers/staging/wilc1000/coreconfigurator.c       |  6 +--
 drivers/staging/wilc1000/host_interface.c         | 28 +++++++----
 drivers/staging/wilc1000/host_interface.h         | 29 ------------
 drivers/staging/wilc1000/linux_mon.c              |  6 +--
 drivers/staging/wilc1000/linux_wlan.c             | 25 +++++-----
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 58 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  1 -
 drivers/staging/wilc1000/wilc_wlan.c              | 26 ++++++----
 10 files changed, 85 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 64c2f1b83dfb..55b2ac2b15a8 100644
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
index 427adfd295da..28ab89b3a65d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -287,7 +287,7 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
+static u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 {
 	u16 u16index;
 
@@ -315,7 +315,7 @@ u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 
 /* This function gets the current channel information from
  * the 802.11n beacon/probe response frame */
-u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
+static u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 {
 	u16 index;
 
@@ -333,7 +333,7 @@ u8 get_current_channel_802_11n(u8 *pu8msa, u16 u16RxLen)
 	return 0;  /* no MIB here */
 }
 
-u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
+static u8 get_current_channel(u8 *pu8msa, u16 u16RxLen)
 {
 	/* Extract current channel information from */
 	/* the beacon/probe response frame          */
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 194ca3d3e920..4e9dfb493b9f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -232,7 +232,7 @@ struct join_bss_param {
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 bool g_obtainingIP;
-u8 P2P_LISTEN_STATE;
+static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
@@ -256,10 +256,10 @@ static u32 inactive_time;
 static u8 del_beacon;
 
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
@@ -398,7 +398,9 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
+static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx);
+
+static s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
@@ -433,7 +435,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	return s32Error;
 }
 
-s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
+static s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 
 	s32 s32Error = 0;
@@ -812,6 +814,9 @@ static s32 Handle_wait_msg_q_empty(void)
 	return 0;
 }
 
+static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
+			   enum scan_event enuEvent);
+
 static s32 Handle_Scan(struct host_if_drv *hif_drv,
 		       struct scan_attr *pstrHostIFscanAttr)
 {
@@ -1484,6 +1489,11 @@ done:
 	return s32Error;
 }
 
+static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
+				       u8 *pu8AssocRespInfo,
+				       u32 u32MaxAssocRespInfoLen,
+				       u32 *pu32RcvdAssocRespInfoLen);
+
 static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
@@ -2178,7 +2188,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 
 }
 
-s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
+static s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, s32Error = 0;
@@ -3594,7 +3604,7 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	return s32Error;
 }
 
-s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
+static s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv, u8 *pu8AssocRespInfo,
 					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 s32Error = 0;
@@ -4794,7 +4804,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 
 }
 
-s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
+static s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3df74f1bf9ff..1661eeb0a2e7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -622,21 +622,6 @@ s32 host_int_flush_join_req(struct host_if_drv *hWFIDrv);
 s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 
 /**
- *  @brief              gets a Association Response info
- *  @details
- *  @param[in,out] handle to the wifi driver,
- *                              Message containg assoc. resp info
- *  @return             Error code indicating success/failure
- *  @note
- *  @author		zsalah
- *  @date		8 March 2012
- *  @version		1.0
- */
-
-s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInfo,
-					u32 u32MaxAssocRespInfoLen, u32 *pu32RcvdAssocRespInfoLen);
-
-/**
  *  @brief              sets a channel
  *  @details
  *  @param[in,out] handle to the wifi driver,
@@ -887,18 +872,6 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx)
  */
 s32 host_int_del_All_Rx_BASession(struct host_if_drv *hWFIDrv, char *pBSSID, char TID);
 
-
-/**
- *  @brief           host_int_get_ipaddress
- *  @details       get IP address on firmware
- *  @param[in]
- *  @return         Error code.
- *  @author		Abdelrahman Sobhy
- *  @date
- *  @version	1.0
- */
-s32 host_int_get_ipaddress(struct host_if_drv *hWFIDrv, u8 *pu8IPAddr, u8 idx);
-
 /**
  *  @brief           host_int_remain_on_channel
  *  @details
@@ -948,8 +921,6 @@ s32 host_int_frame_register(struct host_if_drv *hWFIDrv, u16 u16FrameType, bool
 int host_int_set_wfi_drv_handler(struct host_if_drv *address);
 int host_int_set_operation_mode(struct host_if_drv *wfi_drv, u32 mode);
 
-static s32 Handle_ScanDone(struct host_if_drv *drvHandler, enum scan_event enuEvent);
-
 void host_int_freeJoinParams(void *pJoinParams);
 
 s32 host_int_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 450af1b77f99..d93594474a2d 100644
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
index b879b8be0f3f..1b496e84100e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -239,9 +239,8 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 	}
 	return IRQ_WAKE_THREAD;
 }
-#endif
 
-irqreturn_t isr_bh_routine(int irq, void *userdata)
+static irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
 	struct wilc *nic;
 
@@ -259,7 +258,6 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	return IRQ_HANDLED;
 }
 
-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static int init_irq(struct wilc *p_nic)
 {
 	int ret = 0;
@@ -358,7 +356,7 @@ void linux_wlan_mac_indicate(int flag)
 
 }
 
-struct net_device *GetIfHandler(u8 *pMacHeader)
+static struct net_device *GetIfHandler(u8 *pMacHeader)
 {
 	u8 *Bssid, *Bssid1;
 	int i = 0;
@@ -551,7 +549,7 @@ _fail_:
 }
 
 #ifdef COMPLEMENT_BOOT
-int repeat_power_cycle(perInterface_wlan_t *nic);
+static int repeat_power_cycle(perInterface_wlan_t *nic);
 #endif
 
 static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
@@ -944,7 +942,7 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 	}
 }
 
-int wlan_init_locks(struct wilc *p_nic)
+static int wlan_init_locks(struct wilc *p_nic)
 {
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
@@ -977,7 +975,8 @@ static int wlan_deinit_locks(struct wilc *nic)
 
 	return 0;
 }
-void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
+
+static void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
@@ -1003,7 +1002,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 #endif
 }
 
-int wlan_initialize_threads(perInterface_wlan_t *nic)
+static int wlan_initialize_threads(perInterface_wlan_t *nic)
 {
 
 	int ret = 0;
@@ -1053,7 +1052,7 @@ extern u8 core_11b_ready(void);
 
 #define READY_CHECK_THRESHOLD		30
 extern void wilc_wlan_global_reset(void);
-u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
+static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	u8 trials = 0;
 
@@ -1086,7 +1085,7 @@ u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 }
 
-int repeat_power_cycle(perInterface_wlan_t *nic)
+static int repeat_power_cycle(perInterface_wlan_t *nic)
 {
 	int ret = 0;
 	wilc_wlan_inp_t nwi;
@@ -1265,7 +1264,7 @@ _fail_locks_:
  *      - this function will be called automatically by OS when module inserted.
  */
 
-int mac_init_fn(struct net_device *ndev)
+static int mac_init_fn(struct net_device *ndev)
 {
 
 	/*Why we do this !!!*/
@@ -1351,7 +1350,7 @@ _err_:
 	return ret;
 }
 
-struct net_device_stats *mac_stats(struct net_device *dev)
+static struct net_device_stats *mac_stats(struct net_device *dev)
 {
 	perInterface_wlan_t *nic = netdev_priv(dev);
 
@@ -1554,7 +1553,7 @@ int mac_close(struct net_device *ndev)
 	return 0;
 }
 
-int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
+static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
 
 	u8 *buff = NULL;
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index ebacd297abca..96558accf877 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -37,14 +37,14 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 };
 
 
+#ifndef WILC_SDIO_IRQ_GPIO
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
-#ifndef WILC_SDIO_IRQ_GPIO
 	sdio_release_host(func);
 	wilc_handle_isr();
 	sdio_claim_host(func);
-#endif
 }
+#endif
 
 
 int linux_sdio_cmd52(sdio_cmd52_t *cmd)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 18e40e515a48..c54c9fce41e7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -27,10 +27,10 @@ extern u16 Set_machw_change_vir_if(bool bValue);
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
 
@@ -93,15 +93,15 @@ struct p2p_mgmt_data {
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
@@ -116,19 +116,19 @@ struct add_key_params {
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
 
@@ -150,7 +150,7 @@ void clear_shadow_scan(void *pUserVoid)
 
 }
 
-u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
+static u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 {
 	u8 i;
 	int rssi_v = 0;
@@ -163,7 +163,7 @@ u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
+static void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -203,7 +203,7 @@ void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 
 }
 
-void reset_shadow_found(void *pUserVoid)
+static void reset_shadow_found(void *pUserVoid)
 {
 	int i;
 
@@ -213,7 +213,7 @@ void reset_shadow_found(void *pUserVoid)
 	}
 }
 
-void update_scan_time(void *pUserVoid)
+static void update_scan_time(void *pUserVoid)
 {
 	int i;
 
@@ -259,7 +259,7 @@ static void clear_duringIP(unsigned long arg)
 	g_obtainingIP = false;
 }
 
-int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
 	int state = -1;
 	int i;
@@ -282,7 +282,7 @@ int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 	return state;
 }
 
-void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
+static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
 	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
@@ -1759,7 +1759,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
  *  @version
  */
 
-void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
+static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -1811,7 +1811,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
  *  @date	12 DEC 2012
  *  @version
  */
-void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
+static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -2142,7 +2142,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
  *  @date	01 JAN 2014
  *  @version	1.0
  */
-void WILC_WFI_add_wilcvendorspec(u8 *buff)
+static void WILC_WFI_add_wilcvendorspec(u8 *buff)
 {
 	memcpy(buff, u8P2P_vendorspec, sizeof(u8P2P_vendorspec));
 }
@@ -3259,7 +3259,7 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-struct wireless_dev *WILC_WFI_CfgAlloc(void)
+static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 {
 
 	struct wireless_dev *wdev;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 39cd8e1b5675..e7ea397644de 100644
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
index c8564249092c..83fd41a4f521 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -82,7 +82,9 @@ typedef struct {
 
 static wilc_wlan_dev_t g_wlan;
 
+#ifdef WILC_OPTIMIZE_SLEEP_INT
 static inline void chip_allow_sleep(void);
+#endif
 static inline void chip_wakeup(void);
 /********************************************
  *
@@ -138,6 +140,7 @@ static inline void release_bus(BUS_RELEASE_T release)
  *
  ********************************************/
 
+#ifdef TCP_ACK_FILTER
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
 
@@ -160,6 +163,7 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 	p->txq_entries -= 1;
 
 }
+#endif
 
 static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 {
@@ -273,19 +277,19 @@ typedef struct {
 
 
 
-struct Ack_session_info *Free_head;
-struct Ack_session_info *Alloc_head;
+static struct Ack_session_info *Free_head;
+static struct Ack_session_info *Alloc_head;
 
 #define NOT_TCP_ACK			(-1)
 
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
-struct Ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
-Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
+static struct Ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
+static Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
 
-u32 PendingAcks_arrBase;
-u32 Opened_TCP_session;
-u32 Pending_Acks;
+static u32 PendingAcks_arrBase;
+static u32 Opened_TCP_session;
+static u32 Pending_Acks;
 
 
 
@@ -449,17 +453,19 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 }
 #endif
 
-bool EnableTCPAckFilter = false;
+static bool EnableTCPAckFilter = false;
 
 void Enable_TCP_ACK_Filter(bool value)
 {
 	EnableTCPAckFilter = value;
 }
 
-bool is_TCP_ACK_Filter_Enabled(void)
+#ifdef TCP_ACK_FILTER
+static bool is_TCP_ACK_Filter_Enabled(void)
 {
 	return EnableTCPAckFilter;
 }
+#endif
 
 static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 {
@@ -1834,7 +1840,7 @@ void wilc_bus_set_default_speed(void)
 	/* Restore bus speed to default.  */
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
-u32 init_chip(void)
+static u32 init_chip(void)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
-- 
2.1.0.rc2

