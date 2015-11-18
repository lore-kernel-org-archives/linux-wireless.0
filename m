Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20807 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbbKRGJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/16] staging: wilc1000: wilc_wlan_cfg_get: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:35 +0900
Message-ID: <1447827097-9436-15-git-send-email-glen.lee@atmel.com> (sfid-20151118_071409_760523_1E4457FD)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes the struct wilc to the function and use it instead of
global variable wilc_dev.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/linux_wlan.c       | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c        | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h        | 3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 6278aec..0cd2acc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -597,7 +597,7 @@ s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 		for (counter = 0; counter < count; counter++) {
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
 				   (counter == count - 1));
-			if (!wilc_wlan_cfg_get(!counter,
+			if (!wilc_wlan_cfg_get(wilc, !counter,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 792cc0b..1457e75 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -939,7 +939,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_irq_enable_;
 		}
 
-		if (wilc_wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
+		if (wilc_wlan_cfg_get(wl, 1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 03c707b..a271851 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1540,10 +1540,10 @@ int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 	return ret_size;
 }
 
-int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler)
+int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
+		      u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
-	struct wilc *wilc = wilc_dev;
 	u32 offset;
 	int ret_size;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index e1a8c73..2ac63a3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -291,7 +291,8 @@ void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
-int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler);
+int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
+		      u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
-- 
1.9.1

