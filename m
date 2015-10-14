Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43498 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbbJNLrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:10 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/16] staging: wilc1000: remove typedef from the linux_wlan_t
Date: Wed, 14 Oct 2015 20:46:30 +0900
Message-ID: <1444823204-16736-2-git-send-email-tony.cho@atmel.com> (sfid-20151014_134717_035359_C5E21198)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct linux_wlan_t and renames it
to the wilc. In addition, all of linux_wlan_t is replaced with struct wilc
and memory allocation style is changed with preferred form as well like the
following:
	p = kmalloc(sizeof(*p), ...) where "struct wilc" is used

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 38 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  8 ++---
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ccab89f..b879b8b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -49,7 +49,7 @@ extern bool g_obtainingIP;
 extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-void wilc1000_wlan_deinit(linux_wlan_t *nic);
+void wilc1000_wlan_deinit(struct wilc *nic);
 extern struct timer_list hDuringIpTimer;
 
 static int linux_wlan_device_power(int on_off)
@@ -96,8 +96,8 @@ static struct notifier_block g_dev_notifier = {
  */
 static struct semaphore close_exit_sync;
 
-static int wlan_deinit_locks(linux_wlan_t *nic);
-static void wlan_deinitialize_threads(linux_wlan_t *nic);
+static int wlan_deinit_locks(struct wilc *nic);
+static void wlan_deinitialize_threads(struct wilc *nic);
 extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
@@ -114,7 +114,7 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * for now - in frmw_to_linux there should be private data to be passed to it
  * and this data should be pointer to net device
  */
-linux_wlan_t *g_linux_wlan;
+struct wilc *g_linux_wlan;
 bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -243,9 +243,9 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
-	linux_wlan_t *nic;
+	struct wilc *nic;
 
-	nic = (linux_wlan_t *)userdata;
+	nic = (struct wilc *)userdata;
 
 	/*While mac is closing cacncel the handling of any interrupts received*/
 	if (g_linux_wlan->close) {
@@ -260,10 +260,10 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 }
 
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
-static int init_irq(linux_wlan_t *p_nic)
+static int init_irq(struct wilc *p_nic)
 {
 	int ret = 0;
-	linux_wlan_t *nic = p_nic;
+	struct wilc *nic = p_nic;
 
 	/*initialize GPIO and register IRQ num*/
 	/*GPIO request*/
@@ -299,7 +299,7 @@ static int init_irq(linux_wlan_t *p_nic)
 }
 #endif
 
-static void deinit_irq(linux_wlan_t *nic)
+static void deinit_irq(struct wilc *nic)
 {
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 	/* Deintialize IRQ */
@@ -336,7 +336,7 @@ void linux_wlan_mac_indicate(int flag)
 	/*I have to do it that way becuase there is no mean to encapsulate device pointer
 	 * as a parameter
 	 */
-	linux_wlan_t *pd = g_linux_wlan;
+	struct wilc *pd = g_linux_wlan;
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
@@ -594,7 +594,7 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 _fail_:
 	return ret;
 }
-static int linux_wlan_firmware_download(linux_wlan_t *p_nic)
+static int linux_wlan_firmware_download(struct wilc *p_nic)
 {
 
 	int ret = 0;
@@ -626,7 +626,7 @@ _FAIL_:
 }
 
 /* startup configuration - could be changed later using iconfig*/
-static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_nic)
+static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_nic)
 {
 
 	unsigned char c_val[64];
@@ -882,7 +882,7 @@ _fail_:
 }
 
 /**************************/
-void wilc1000_wlan_deinit(linux_wlan_t *nic)
+void wilc1000_wlan_deinit(struct wilc *nic)
 {
 
 	if (g_linux_wlan->wilc1000_initialized)	{
@@ -944,7 +944,7 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 	}
 }
 
-int wlan_init_locks(linux_wlan_t *p_nic)
+int wlan_init_locks(struct wilc *p_nic)
 {
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
@@ -965,7 +965,7 @@ int wlan_init_locks(linux_wlan_t *p_nic)
 	return 0;
 }
 
-static int wlan_deinit_locks(linux_wlan_t *nic)
+static int wlan_deinit_locks(struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
@@ -977,7 +977,7 @@ static int wlan_deinit_locks(linux_wlan_t *nic)
 
 	return 0;
 }
-void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
+void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
@@ -1031,7 +1031,7 @@ _fail_2:
 	return ret;
 }
 
-static void wlan_deinitialize_threads(linux_wlan_t *nic)
+static void wlan_deinitialize_threads(struct wilc *nic)
 {
 
 	g_linux_wlan->close = 1;
@@ -1053,7 +1053,7 @@ extern u8 core_11b_ready(void);
 
 #define READY_CHECK_THRESHOLD		30
 extern void wilc_wlan_global_reset(void);
-u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
+u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	u8 trials = 0;
 
@@ -1714,7 +1714,7 @@ int wilc_netdev_init(void)
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = kzalloc(sizeof(linux_wlan_t), GFP_KERNEL);
+	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
 	if (!g_linux_wlan)
 		return -ENOMEM;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a950b04..08ba5ba 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2523,7 +2523,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-void wilc1000_wlan_deinit(linux_wlan_t *nic);
+void wilc1000_wlan_deinit(struct wilc *nic);
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8bcfcc2..373959b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -154,7 +154,8 @@ typedef struct {
 	struct host_if_drv *drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
-typedef struct {
+
+struct wilc {
 	int mac_status;
 	int wilc1000_initialized;
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
@@ -188,8 +189,7 @@ typedef struct {
 #else
 	struct spi_device *wilc_spidev;
 #endif
-
-} linux_wlan_t;
+};
 
 typedef struct {
 	u8 u8IfIdx;
@@ -206,7 +206,7 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-extern linux_wlan_t *g_linux_wlan;
+extern struct wilc *g_linux_wlan;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
-- 
1.9.1

