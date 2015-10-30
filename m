Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56521 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478AbbJ3Joh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:44:37 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 03/17] staging: wilc1000: wilc_wlan_cfg_get: add argument struct net_device
Date: Fri, 30 Oct 2015 18:47:09 +0900
Message-ID: <1446198443-6623-3-git-send-email-glen.lee@atmel.com> (sfid-20151030_104440_627182_E82157CF)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds argument struct net_device and use netdev private data member wilc
instead of g_linux_wlan, pass dev to the functions as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 3 ++-
 drivers/staging/wilc1000/linux_wlan.c       | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c        | 8 ++++++--
 drivers/staging/wilc1000/wilc_wlan.h        | 3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3b4a950..530d64a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -595,7 +595,8 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 		for (counter = 0; counter < count; counter++) {
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
 				   (counter == count - 1));
-			if (!wilc_wlan_cfg_get(!counter,
+			if (!wilc_wlan_cfg_get(dev,
+					       !counter,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d0161cd..4ed324c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1153,7 +1153,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wilc_bus_set_max_speed();
 
-		if (wilc_wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
+		if (wilc_wlan_cfg_get(dev, 1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 16224ce..768fd30 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1809,12 +1809,16 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 
 	return ret_size;
 }
-int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
+int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
+		      u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
 	int ret_size;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
 
+	wilc = nic->wilc;
 
 	if (p->cfg_frame_in_use)
 		return 0;
@@ -1834,7 +1838,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 			ret_size = 0;
 
 
-		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+		if (linux_wlan_lock_timeout(&wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2eb7e20..2879a93 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -305,7 +305,8 @@ void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
-int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
+int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
+		      u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
-- 
1.9.1

