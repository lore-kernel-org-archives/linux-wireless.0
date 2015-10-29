Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27067 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965300AbbJ2DEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:53 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 47/64] staging: wilc1000: rename u64P2p_MgmtTimeout of struct host_if_drv
Date: Thu, 29 Oct 2015 12:05:39 +0900
Message-ID: <1446087956-19054-14-git-send-email-glen.lee@atmel.com> (sfid-20151029_040455_948554_8D747C04)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u64P2p_MgmtTimeout of struct host_if_drv to p2p_timeout
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 294f90c..00f2717 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4158,7 +4158,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	hif_drv->cfg_values.passive_scan_time = PASSIVE_SCAN_TIME;
 	hif_drv->cfg_values.curr_tx_rate = AUTORATE;
 
-	hif_drv->u64P2p_MgmtTimeout = 0;
+	hif_drv->p2p_timeout = 0;
 
 	PRINT_INFO(HOSTINF_DBG, "Initialization values, Site survey value: %d\n Scan source: %d\n Active scan time: %d\n Passive scan time: %d\nCurrent tx Rate = %d\n",
 		   hif_drv->cfg_values.site_survey_enabled,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8450e22..c9a4ce8 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -264,7 +264,7 @@ struct host_if_drv {
 	struct user_conn_req usr_conn_req;
 	struct remain_ch remain_on_ch;
 	u8 remain_on_ch_pending;
-	u64 u64P2p_MgmtTimeout;
+	u64 p2p_timeout;
 	u8 u8P2PConnect;
 
 	enum host_if_state hif_state;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3060b8d..116c37d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1050,7 +1050,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	u8P2Plocalrandom = 0x01;
 	u8P2Precvrandom = 0x00;
 	bWilc_ie = false;
-	pstrWFIDrv->u64P2p_MgmtTimeout = 0;
+	pstrWFIDrv->p2p_timeout = 0;
 
 	s32Error = host_int_disconnect(priv->hWILCWFIDrv, reason_code);
 	if (s32Error != 0) {
@@ -1958,7 +1958,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
 			PRINT_D(GENERIC_DBG, "Rx Action Frame Type: %x %x\n", buff[ACTION_SUBTYPE_ID], buff[P2P_PUB_ACTION_SUBTYPE]);
 
-			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->u64P2p_MgmtTimeout)) {
+			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
 				PRINT_D(GENERIC_DBG, "Receiving action frames from wrong channels\n");
 				return;
 			}
@@ -2331,10 +2331,10 @@ static int mgmt_tx(struct wiphy *wiphy,
 			}
 
 			PRINT_D(GENERIC_DBG, "TX: ACTION FRAME Type:%x : Chan:%d\n", buf[ACTION_SUBTYPE_ID], chan->hw_value);
-			pstrWFIDrv->u64P2p_MgmtTimeout = (jiffies + msecs_to_jiffies(wait));
-
-			PRINT_D(GENERIC_DBG, "Current Jiffies: %lu Timeout:%llu\n", jiffies, pstrWFIDrv->u64P2p_MgmtTimeout);
+			pstrWFIDrv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
 
+			PRINT_D(GENERIC_DBG, "Current Jiffies: %lu Timeout:%llu\n",
+				jiffies, pstrWFIDrv->p2p_timeout);
 		}
 
 		wilc_wlan_txq_add_mgmt_pkt(mgmt_tx, mgmt_tx->buff,
@@ -2358,7 +2358,7 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 
 
 	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
-	pstrWFIDrv->u64P2p_MgmtTimeout = jiffies;
+	pstrWFIDrv->p2p_timeout = jiffies;
 
 	if (!priv->bInP2PlistenState) {
 		cfg80211_remain_on_channel_expired(priv->wdev,
-- 
1.9.1

