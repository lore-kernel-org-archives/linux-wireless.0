Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3592 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbJAHFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:05:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/12] staging: wilc1000: remove function pointer wlan_add_mgmt_to_tx_que
Date: Thu, 1 Oct 2015 16:03:43 +0900
Message-ID: <1443683023-6498-12-git-send-email-tony.cho@atmel.com> (sfid-20151001_091654_482375_AFC1CA15)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_add_mgmt_to_tx_que and just call
the function wilc_wlan_txq_add_mgmt_pkt.
Remove structure wilc_wlan_oup_t also because no members in it. Since
wilc_wlan_oup_t is deleted, it's variable, function parameters and related
codes are also deleted.
- deleted variables
gpstrWlanOps
oup
- modified functions
wilc1000_prepare_11b_core
wilc_wlan_init

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  6 ------
 drivers/staging/wilc1000/linux_mon.c              |  3 ++-
 drivers/staging/wilc1000/linux_wlan.c             | 17 +++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 +++-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 -
 drivers/staging/wilc1000/wilc_wlan.c              |  7 +------
 drivers/staging/wilc1000/wilc_wlan.h              |  2 ++
 drivers/staging/wilc1000/wilc_wlan_if.h           |  8 +-------
 8 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 246abb5..136d207 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -608,12 +608,6 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 {
 	s32 counter = 0, ret = 0;
 
-	if (gpstrWlanOps == NULL) {
-		PRINT_D(CORECONFIG_DBG, "Net Dev is still not initialized\n");
-		return 1;
-	} else {
-		PRINT_D(CORECONFIG_DBG, "Net Dev is initialized\n");
-	}
 	if (u8Mode == GET_CFG) {
 		for (counter = 0; counter < u32WIDsCount; counter++) {
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index b1af421..a943b23 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -197,7 +197,8 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	mgmt_tx->size = len;
 
 	memcpy(mgmt_tx->buff, buf, len);
-	g_linux_wlan->oup.wlan_add_mgmt_to_tx_que(mgmt_tx, mgmt_tx->buff, mgmt_tx->size, mgmt_tx_complete);
+	wilc_wlan_txq_add_mgmt_pkt(mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
+				   mgmt_tx_complete);
 
 	netif_wake_queue(dev);
 	return 0;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e91192c..c2e528f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -115,7 +115,6 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * and this data should be pointer to net device
  */
 linux_wlan_t *g_linux_wlan;
-wilc_wlan_oup_t *gpstrWlanOps;
 bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -1117,7 +1116,7 @@ extern u8 core_11b_ready(void);
 
 #define READY_CHECK_THRESHOLD		30
 extern void wilc_wlan_global_reset(void);
-u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_wlan_t *nic)
+u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 {
 	u8 trials = 0;
 
@@ -1140,7 +1139,7 @@ u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_w
 		probe = 0;
 		g_linux_wlan->wilc_sdio_func = local_sdio_func;
 		linux_to_wlan(nwi, nic);
-		wilc_wlan_init(nwi, nwo);
+		wilc_wlan_init(nwi);
 	}
 
 	if (READY_CHECK_THRESHOLD <= trials)
@@ -1154,7 +1153,6 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 {
 	int ret = 0;
 	wilc_wlan_inp_t nwi;
-	wilc_wlan_oup_t nwo;
 
 	sdio_unregister_driver(&wilc_bus);
 
@@ -1174,7 +1172,7 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	probe = 0;
 	g_linux_wlan->wilc_sdio_func = local_sdio_func;
 	linux_to_wlan(&nwi, g_linux_wlan);
-	ret = wilc_wlan_init(&nwi, &nwo);
+	ret = wilc_wlan_init(&nwi);
 
 	g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
 	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
@@ -1205,7 +1203,6 @@ __fail__:
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
 	wilc_wlan_inp_t nwi;
-	wilc_wlan_oup_t nwo;
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
@@ -1218,16 +1215,12 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		linux_to_wlan(&nwi, g_linux_wlan);
 
-		ret = wilc_wlan_init(&nwi, &nwo);
+		ret = wilc_wlan_init(&nwi);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
 			ret = -EIO;
 			goto _fail_locks_;
 		}
-		memcpy(&g_linux_wlan->oup, &nwo, sizeof(wilc_wlan_oup_t));
-
-		/*Save the oup structre into global pointer*/
-		gpstrWlanOps = &g_linux_wlan->oup;
 
 		ret = wlan_initialize_threads(nic);
 		if (ret < 0) {
@@ -1237,7 +1230,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(&nwi, &nwo, g_linux_wlan)) {
+		if (wilc1000_prepare_11b_core(&nwi, g_linux_wlan)) {
 			PRINT_ER("11b Core is not ready\n");
 			ret = -EIO;
 			goto _fail_threads_;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 755a817..45d1974 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2490,7 +2490,9 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 		}
 
-		g_linux_wlan->oup.wlan_add_mgmt_to_tx_que(mgmt_tx, mgmt_tx->buff, mgmt_tx->size, WILC_WFI_mgmt_tx_complete);
+		wilc_wlan_txq_add_mgmt_pkt(mgmt_tx, mgmt_tx->buff,
+					   mgmt_tx->size,
+					   WILC_WFI_mgmt_tx_complete);
 	} else {
 		PRINT_D(GENERIC_DBG, "This function transmits only management frames\n");
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d3a03c6..0403bc7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -164,7 +164,6 @@ typedef struct {
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
 	unsigned short dev_irq_num;
 	#endif
-	wilc_wlan_oup_t oup;
 	int close;
 	u8 u8NoIfcs;
 	tstrInterfaceInfo strInterfaceInfo[NUM_CONCURRENT_IFC];
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f4e57d8..9475ec7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1949,7 +1949,7 @@ u8 core_11b_ready(void)
 }
 #endif
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
+int wilc_wlan_init(wilc_wlan_inp_t *inp)
 {
 
 	int ret = 0;
@@ -2026,11 +2026,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	}
 #endif
 
-	/**
-	 *      export functions
-	 **/
-	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
-
 	if (!init_chip()) {
 		/* EIO	5 */
 		ret = -5;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 3ffd558..1ba433c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -315,4 +315,6 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
+int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size,
+			       wilc_tx_complete_func_t func);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index baa13e2..38d2206 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -121,11 +121,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 
 #define WILC_TX_ERR_NO_BUF	(-2)
 
-typedef struct {
-	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32,
-				       wilc_tx_complete_func_t);
-} wilc_wlan_oup_t;
-
 /********************************************
  *
  *      Wlan Configuration ID
@@ -946,11 +941,10 @@ typedef enum {
 	WID_MAX				= 0xFFFF
 } WID_T;
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup);
+int wilc_wlan_init(wilc_wlan_inp_t *inp);
 
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(u8 update);
-extern wilc_wlan_oup_t *gpstrWlanOps;
 
 #endif
-- 
1.9.1

