Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32804 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1E4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:56:21 -0400
Received: by mail-pf0-f194.google.com with SMTP id x3so19167773pfb.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 21:56:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: use mutex instead of struct semaphore hSemScanReq
Date: Mon, 28 Mar 2016 13:56:00 +0900
Message-Id: <1459140960-10645-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160328_065624_634330_C634855C)
In-Reply-To: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces struct semaphore hSemScanReq with struct mutex
scan_req_lock. It is better to use mutex than semaphore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f6aec47..358632b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -451,7 +451,7 @@ static void CfgScanResult(enum scan_event scan_event,
 		} else if (scan_event == SCAN_EVENT_DONE) {
 			refresh_scan(priv, 1, false);
 
-			down(&(priv->hSemScanReq));
+			mutex_lock(&priv->scan_req_lock);
 
 			if (priv->pstrScanReq) {
 				cfg80211_scan_done(priv->pstrScanReq, false);
@@ -459,9 +459,9 @@ static void CfgScanResult(enum scan_event scan_event,
 				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
 			}
-			up(&(priv->hSemScanReq));
+			mutex_unlock(&priv->scan_req_lock);
 		} else if (scan_event == SCAN_EVENT_ABORTED) {
-			down(&(priv->hSemScanReq));
+			mutex_lock(&priv->scan_req_lock);
 
 			if (priv->pstrScanReq) {
 				update_scan_time();
@@ -471,7 +471,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
 			}
-			up(&(priv->hSemScanReq));
+			mutex_unlock(&priv->scan_req_lock);
 		}
 	}
 }
@@ -2307,7 +2307,7 @@ int wilc_init_host_int(struct net_device *net)
 
 	priv->bInP2PlistenState = false;
 
-	sema_init(&(priv->hSemScanReq), 1);
+	mutex_init(&priv->scan_req_lock);
 	s32Error = wilc_init(net, &priv->hif_drv);
 	if (s32Error)
 		netdev_err(net, "Error while initializing hostinterface\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 94a41b4..3d0ca8e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -130,7 +130,7 @@ struct wilc_priv {
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
 	/* semaphores */
-	struct semaphore hSemScanReq;
+	struct mutex scan_req_lock;
 	/*  */
 	bool gbAutoRateAdjusted;
 
-- 
2.7.4

