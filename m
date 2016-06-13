Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34954 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965443AbcFMKiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:17 -0400
Received: by mail-pf0-f174.google.com with SMTP id c2so45163378pfa.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:17 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 3/7] staging: wilc1000: Replace semaphore cfg_event with completion
Date: Mon, 13 Jun 2016 16:07:35 +0530
Message-Id: <1465814259-3009-4-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_124010_117480_F75362B3)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'cfg_event' is used as completion, so convert
it to a struct completion type.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/linux_wlan.c         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 16 +++++++++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a933551..81a469a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -683,7 +683,7 @@ static int wlan_init_locks(struct net_device *dev)
 
 	init_completion(&wl->txq_event);
 
-	sema_init(&wl->cfg_event, 0);
+	init_completion(&wl->cfg_event);
 	sema_init(&wl->sync_event, 0);
 	init_completion(&wl->txq_thread_started);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 239cd43..5fbc07c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -178,7 +178,7 @@ struct wilc {
 	struct mutex rxq_cs;
 	struct mutex hif_cs;
 
-	struct semaphore cfg_event;
+	struct completion cfg_event;
 	struct semaphore sync_event;
 	struct completion txq_event;
 	struct completion txq_thread_started;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9afbe8d..2d6eb43 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -310,7 +310,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	netdev_dbg(vif->ndev, "Adding config packet ...\n");
 	if (wilc->quit) {
 		netdev_dbg(vif->ndev, "Return due to clear function\n");
-		up(&wilc->cfg_event);
+		complete(&wilc->cfg_event);
 		return 0;
 	}
 
@@ -769,7 +769,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 	do {
 		if (wilc->quit) {
-			up(&wilc->cfg_event);
+			complete(&wilc->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove(wilc);
@@ -820,7 +820,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 					wilc_wlan_cfg_indicate_rx(wilc, &buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
 						if (wilc->cfg_seq_no == rsp.seq_no)
-							up(&wilc->cfg_event);
+							complete(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
 
@@ -1228,11 +1228,12 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
-		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
-					    CFG_PKTS_TIMEOUT)) {
+		if (!wait_for_completion_timeout(&wilc->cfg_event,
+					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
 			netdev_dbg(vif->ndev, "Set Timed Out\n");
 			ret_size = 0;
 		}
+
 		wilc->cfg_frame_in_use = 0;
 		wilc->cfg_frame_offset = 0;
 		wilc->cfg_seq_no += 1;
@@ -1246,6 +1247,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 {
 	u32 offset;
 	int ret_size;
+
 	struct wilc *wilc = vif->wilc;
 
 	if (wilc->cfg_frame_in_use)
@@ -1265,8 +1267,8 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
 
-		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
-					    CFG_PKTS_TIMEOUT)) {
+		if (!wait_for_completion_timeout(&wilc->cfg_event,
+					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
 			netdev_dbg(vif->ndev, "Get Timed Out\n");
 			ret_size = 0;
 		}
-- 
2.7.4

