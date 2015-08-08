Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36220 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbbHHMMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 08:12:41 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: Remove unused extern declarations
Date: Sat,  8 Aug 2015 17:41:34 +0530
Message-Id: <1439035896-15213-3-git-send-email-csgorentla@gmail.com> (sfid-20150808_141319_423151_6A2D6E5F)
In-Reply-To: <1439035896-15213-2-git-send-email-csgorentla@gmail.com>
References: <1439035896-15213-1-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'extern' declarations which are not referenced within the file are
removed.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 1 -
 drivers/staging/wilc1000/linux_wlan_sdio.c        | 1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 --
 drivers/staging/wilc1000/wilc_wlan.c              | 3 ---
 4 files changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bc06d56..8b36683 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -9,7 +9,6 @@ extern u8 connecting;
 extern WILC_TimerHandle hDuringIpTimer;
 #endif
 
-extern bool bEnablePS;
 /*BugID_5137*/
 extern u8 g_wilc_initialized;
 /*****************************************************************************/
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 858e3a1..37f31f4 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -31,7 +31,6 @@
 struct sdio_func *local_sdio_func;
 extern linux_wlan_t *g_linux_wlan;
 extern int wilc_netdev_init(void);
-extern int sdio_clear_int(void);
 extern void wilc_handle_isr(void);
 
 static unsigned int sdio_default_speed;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3525145..4918481 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -22,7 +22,6 @@
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-extern void linux_wlan_free(void *vp);
 extern int linux_wlan_get_firmware(perInterface_wlan_t *p_nic);
 extern void linux_wlan_unlock(void *vp);
 extern u16 Set_machw_change_vir_if(bool bValue);
@@ -1619,7 +1618,6 @@ static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
  *  @version	1.0
  */
 
-extern uint32_t Statisitcs_totalAcks, Statisitcs_DroppedAcks;
 static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *mac, struct station_info *sinfo)
 {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 1eb13f9..75782a2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -16,7 +16,6 @@
  *      Global
  *
  ********************************************/
-extern unsigned int int_clrd;
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 extern wilc_cfg_func_t mac_cfg;
@@ -24,8 +23,6 @@ extern wilc_cfg_func_t mac_cfg;
 extern u8 g_wilc_initialized; /* AMR : 0422 RK3026 Crash issue */
 #endif
 extern void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size);
-extern void frmw_to_linux(uint8_t *buff, uint32_t size);
-int sdio_xfer_cnt(void);
 uint32_t wilc_get_chipid(uint8_t update);
 u16 Set_machw_change_vir_if(bool bValue);
 
-- 
2.5.0

