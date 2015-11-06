Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37306 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKFCPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:15:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 48/73] staging: wilc1000: rename drvHandler in wilc_wlan_cfg_set function
Date: Fri, 6 Nov 2015 11:13:09 +0900
Message-ID: <1446776014-28094-48-git-send-email-glen.lee@atmel.com> (sfid-20151106_033805_818773_E3F827EF)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename drvHandler to drv_handler that is seventh argument of
wilc_wlan_cfg_set function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 2e1d9b8..f0a8131 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1477,7 +1477,7 @@ static int wilc_wlan_cfg_commit(int type, u32 drv_handler)
 }
 
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drvHandler)
+		      int commit, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
@@ -1500,7 +1500,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
 		p->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
+		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
 		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 1eaac9a..03af19b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -304,7 +304,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-		      int commit, u32 drvHandler);
+		      int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
-- 
1.9.1

