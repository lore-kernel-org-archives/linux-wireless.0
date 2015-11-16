Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60357 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbbKPOF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/19] staging/wilc1000: move extern declarations to headers
Date: Mon, 16 Nov 2015 15:04:55 +0100
Message-Id: <1447682710-2908925-5-git-send-email-arnd@arndb.de> (sfid-20151116_150557_042494_F67DCFC9)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'extern' declarations belong into a header file rather than
a .c file, to ensure that the definition matches the declaration.

This moves all declarations into a header file that seems
most appropriate for it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/host_interface.c         |  9 +--------
 drivers/staging/wilc1000/host_interface.h         |  9 +++++++++
 drivers/staging/wilc1000/linux_mon.c              |  3 ---
 drivers/staging/wilc1000/linux_wlan.c             |  9 ---------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 +-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 ++
 drivers/staging/wilc1000/wilc_wlan.c              |  8 +-------
 drivers/staging/wilc1000/wilc_wlan.h              | 21 +++++++++++++++++++++
 9 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 228a2fefe714..d968483c6f00 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4,17 +4,12 @@
 #include <linux/delay.h>
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include "wilc_wlan.h"
 #include "wilc_wlan_if.h"
 #include "wilc_msgqueue.h"
 #include <linux/etherdevice.h>
 #include "wilc_wfi_netdevice.h"
 
-extern u8 wilc_connecting;
-
-extern struct timer_list wilc_during_ip_timer;
-
-extern u8 wilc_initialized;
-
 #define HOST_IF_MSG_SCAN                        0
 #define HOST_IF_MSG_CONNECT                     1
 #define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        2
@@ -271,8 +266,6 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern int wilc_wlan_get_num_conn_ifcs(void);
-
 static int add_handler_in_list(struct host_if_drv *handler)
 {
 	int i;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d0b85a53c29e..efeb9e233589 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -394,4 +394,13 @@ void wilc_free_join_params(void *pJoinParams);
 s32 wilc_get_statistics(struct host_if_drv *hWFIDrv,
 			    struct rf_info *pstrStatistics);
 void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv);
+
+extern bool wilc_optaining_ip;
+extern u8 wilc_connected_SSID[6];
+extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+
+extern int wilc_connecting;
+extern u8 wilc_initialized;
+extern struct timer_list wilc_during_ip_timer;
+
 #endif
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index f0a458764ff2..e550027645b7 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -26,9 +26,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-extern int  wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-
-
 static u8 srcAdd[6];
 static u8 bssid[6];
 static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d3d07fc30e23..f1e70b225deb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -37,10 +37,6 @@
  #define _linux_wlan_device_detection()		{}
  #define _linux_wlan_device_removal()		{}
 
-extern bool wilc_optaining_ip;
-extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-extern struct timer_list wilc_during_ip_timer;
-
 static int linux_wlan_device_power(int on_off)
 {
 	PRINT_D(INIT_DBG, "linux_wlan_device_power.. (%d)\n", on_off);
@@ -81,14 +77,9 @@ static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(struct net_device *dev);
 static void wlan_deinitialize_threads(struct net_device *dev);
-extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
-extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
 static int  mac_init_fn(struct net_device *ndev);
-int  wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-int  wilc_mac_open(struct net_device *ndev);
-int  wilc_mac_close(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f8fd7a895d44..49b82b4a0688 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -14,6 +14,7 @@
 #ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"
 #endif
+#include "host_interface.h"
 #include <linux/errno.h>
 
 #define IS_MANAGMEMENT				0x100
@@ -29,10 +30,8 @@ static u32 u32LastScannedNtwrksCountShadow;
 struct timer_list wilc_during_ip_timer;
 static struct timer_list hAgingTimer;
 static u8 op_ifcs;
-extern u8 wilc_connected_SSID[6];
 
 u8 wilc_initialized = 1;
-extern bool wilc_optaining_ip;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
 		.band             = IEEE80211_BAND_2GHZ, \
@@ -2149,7 +2148,6 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-extern bool wilc_enable_ps;
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -2484,8 +2482,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
-
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 5262b2513fa8..ae2aaea508db 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -103,6 +103,5 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-void wilc_enable_tcp_ack_filter(bool value);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 2a0a3b166a7c..3358fe3bcd0a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,6 +206,8 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
+int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
+
 extern struct wilc *wilc_dev;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a797c61e8061..f7359f79ff8d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,14 +1,8 @@
 #include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-#ifdef WILC_SDIO
-extern struct wilc_hif_func wilc_hif_sdio;
-#else
-extern struct wilc_hif_func wilc_hif_spi;
-#endif
-u32 wilc_get_chipid(u8 update);
-
 typedef struct {
 	int quit;
 	wilc_wlan_io_func_t io_func;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 6cb6abe26096..326d71bf91df 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,7 +1,10 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
+#include <linux/types.h>
+
 #define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
+
 /********************************************
  *
  *      Mac eth header length
@@ -255,6 +258,9 @@ struct wilc_hif_func {
 	void (*hif_set_default_bus_speed)(void);
 };
 
+extern struct wilc_hif_func wilc_hif_spi;
+extern struct wilc_hif_func wilc_hif_sdio;
+
 /********************************************
  *
  *      Configuration Structure
@@ -276,6 +282,8 @@ struct wilc_cfg_rsp {
 	u32 seq_no;
 };
 
+struct wilc;
+
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
@@ -291,4 +299,17 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
 void wilc_chip_sleep_manually(void);
+
+void wilc_enable_tcp_ack_filter(bool value);
+int wilc_wlan_get_num_conn_ifcs(void);
+int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
+
+int wilc_mac_open(struct net_device *ndev);
+int wilc_mac_close(struct net_device *ndev);
+
+int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
+void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
+
+extern bool wilc_enable_ps;
+
 #endif
-- 
2.1.0.rc2

