Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58816 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbJTWsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/19] staging/wilc1000: move extern declarations to headers
Date: Wed, 21 Oct 2015 00:47:23 +0200
Message-Id: <1445381258-1455986-5-git-send-email-arnd@arndb.de> (sfid-20151021_005604_974864_7842508E)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'extern' declarations belong into a header file rather than
a .c file, to ensure that the definition matches the declaration.

This moves all declarations into a header file that seems
most appropriate for it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/host_interface.c         | 10 +-------
 drivers/staging/wilc1000/host_interface.h         | 10 ++++++++
 drivers/staging/wilc1000/linux_mon.c              |  3 ---
 drivers/staging/wilc1000/linux_wlan.c             | 16 -------------
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  3 ---
 drivers/staging/wilc1000/linux_wlan_spi.c         |  1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 +-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  4 ++++
 drivers/staging/wilc1000/wilc_wlan.c              |  9 +------
 drivers/staging/wilc1000/wilc_wlan.h              | 29 ++++++++++++++++++++++-
 11 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c8c5f5c602c7..99c78d395653 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4,16 +4,11 @@
 #include <linux/delay.h>
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include "wilc_wlan.h"
 #include "wilc_wlan_if.h"
 #include "wilc_msgqueue.h"
 #include <linux/etherdevice.h>
 
-extern u8 wilc1000_connecting;
-
-extern struct timer_list wilc1000_during_ip_timer;
-
-extern u8 wilc1000_initialized;
-
 #define HOST_IF_MSG_SCAN                        0
 #define HOST_IF_MSG_CONNECT                     1
 #define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        2
@@ -268,9 +263,6 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern void wilc1000_chip_sleep_manually(u32 u32SleepTime);
-extern int wilc1000_wlan_get_num_conn_ifcs(void);
-
 static int add_handler_in_list(struct host_if_drv *handler)
 {
 	int i;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 826ed0f30615..1f537ed9d7f3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -925,4 +925,14 @@ void wilc1000_free_join_params(void *pJoinParams);
 
 s32 wilc1000_get_statistics(struct host_if_drv *hWFIDrv, struct rf_info *pstrStatistics);
 
+void wilc1000_resolve_disconnect_aberration(struct host_if_drv *drvHandler);
+
+extern bool wilc1000_optaining_ip;
+extern u8 wilc1000_connected_SSID[6];
+extern u8 wilc1000_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+
+extern int wilc1000_connecting;
+extern u8 wilc1000_initialized;
+extern struct timer_list wilc1000_during_ip_timer;
+
 #endif
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 52443f039a43..50196c3aa61d 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -26,9 +26,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-extern int  wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-
-
 static u8 srcAdd[6];
 static u8 bssid[6];
 static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index be4b1b1199f8..50477d70eb24 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -45,13 +45,6 @@
  #define _linux_wlan_device_removal()		{}
 #endif
 
-extern bool wilc1000_optaining_ip;
-extern u16 wilc1000_set_machw_change_vir_if(bool bValue);
-extern void wilc1000_resolve_disconnect_aberration(void *drvHandler);
-extern u8 wilc1000_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-void wilc1000_wlan_deinit(struct wilc *nic);
-extern struct timer_list wilc1000_during_ip_timer;
-
 static int linux_wlan_device_power(int on_off)
 {
 	PRINT_D(INIT_DBG, "linux_wlan_device_power.. (%d)\n", on_off);
@@ -98,14 +91,9 @@ static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(struct wilc *nic);
 static void wlan_deinitialize_threads(struct wilc *nic);
-extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
-extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
 static int  mac_init_fn(struct net_device *ndev);
-int  wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int  wilc1000_mac_open(struct net_device *ndev);
-int  wilc1000_mac_close(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
@@ -1047,11 +1035,7 @@ static void wlan_deinitialize_threads(struct wilc *nic)
 
 #ifdef COMPLEMENT_BOOT
 
-extern volatile int wilc1000_probe;
-extern u8 wilc1000_core_11b_ready(void);
-
 #define READY_CHECK_THRESHOLD		30
-extern void wilc_wlan_global_reset(void);
 static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	u8 trials = 0;
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 470f4bf372f1..4e8c4e6d499e 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -23,9 +23,6 @@
 
 
 struct sdio_func *wilc1000_sdio_func;
-extern int wilc_netdev_init(void);
-extern void wilc_handle_isr(void);
-
 static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 8d8310681658..43cfeda97030 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -42,7 +42,6 @@
 static u32 SPEED = MIN_SPEED;
 
 struct spi_device *wilc_spi_dev;
-void wilc1000_spi_deinit(void *vp);
 
 static int __init wilc_bus_probe(struct spi_device *spi)
 {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 672741632f85..0ed05aafa5bf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -14,6 +14,7 @@
 #ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"
 #endif
+#include "host_interface.h"
 #include <linux/errno.h>
 
 #define IS_MANAGMEMENT				0x100
@@ -21,21 +22,13 @@
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-extern int wilc1000_wlan_get_firmware(perInterface_wlan_t *p_nic);
-extern u16 wilc1000_set_machw_change_vir_if(bool bValue);
-
-extern int wilc1000_mac_open(struct net_device *ndev);
-extern int wilc1000_mac_close(struct net_device *ndev);
-
 static tstrNetworkInfo astrLastScannedNtwrksShadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 u32LastScannedNtwrksCountShadow;
 struct timer_list wilc1000_during_ip_timer;
 static struct timer_list hAgingTimer;
 static u8 op_ifcs;
-extern u8 wilc1000_connected_SSID[6];
 
 u8 wilc1000_initialized = 1;
-extern bool wilc1000_optaining_ip;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = IEEE80211_BAND_2GHZ, \
@@ -473,8 +466,6 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 }
 
 
-int wilc1000_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
-
 
 /**
  *  @brief      CfgConnectResult
@@ -2156,7 +2147,6 @@ static void WILC_WFI_add_wilcvendorspec(u8 *buff)
  *  @date	01 JUL 2012
  *  @version
  */
-extern bool wilc1000_enable_ps;
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -2488,9 +2478,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-void wilc1000_wlan_deinit(struct wilc *nic);
-int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
-
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index a87982cfcd4b..ae2aaea508db 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -103,6 +103,5 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-void wilc1000_enable_tcp_ack_filter(bool value);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 700f6f343b52..28610d889c0c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,6 +206,10 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
+int wilc1000_wlan_get_firmware(perInterface_wlan_t *p_nic);
+void wilc1000_wlan_deinit(struct wilc *nic);
+int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
+
 extern struct wilc *wilc1000_dev;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 140778d8aab5..a147547fb66e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -8,6 +8,7 @@
 /* //////////////////////////////////////////////////////////////////////////// */
 
 #include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
@@ -16,14 +17,6 @@
  *      Global
  *
  ********************************************/
-extern wilc_hif_func_t wilc1000_hif_sdio;
-extern wilc_hif_func_t wilc1000_hif_spi;
-extern void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
-u32 wilc_get_chipid(u8 update);
-u16 wilc1000_set_machw_change_vir_if(bool bValue);
-
-
-
 typedef struct {
 	int quit;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bd89689fbf10..64295a664ea9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,7 +1,7 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
-
+#include <linux/types.h>
 
 #define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
 
@@ -270,6 +270,9 @@ typedef struct {
 	void (*hif_set_default_bus_speed)(void);
 } wilc_hif_func_t;
 
+extern wilc_hif_func_t wilc1000_hif_spi;
+extern wilc_hif_func_t wilc1000_hif_sdio;
+
 /********************************************
  *
  *      Configuration Structure
@@ -309,4 +312,28 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			       wilc_tx_complete_func_t func);
+extern void wilc_wlan_global_reset(void);
+
+void wilc1000_enable_tcp_ack_filter(bool value);
+void wilc1000_chip_sleep_manually(u32 u32SleepTime);
+int wilc1000_wlan_get_num_conn_ifcs(void);
+int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
+int wilc_netdev_init(void);
+void wilc_handle_isr(void);
+
+u16 wilc1000_set_machw_change_vir_if(bool bValue);
+
+int wilc1000_mac_open(struct net_device *ndev);
+int wilc1000_mac_close(struct net_device *ndev);
+
+void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
+
+int wilc1000_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
+void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
+u8 wilc1000_core_11b_ready(void);
+
+extern bool wilc1000_enable_ps;
+extern volatile int wilc1000_probe;
+
+
 #endif
-- 
2.1.0.rc2

