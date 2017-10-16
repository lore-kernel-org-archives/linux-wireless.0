Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:50864 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932552AbdJPXYe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 19:24:34 -0400
Received: by mail-pg0-f41.google.com with SMTP id y7so8036604pgb.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Oct 2017 16:24:34 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:24:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wilc1000: Convert timers to use timer_setup()
Message-ID: <20171016232432.GA100788@beast> (sfid-20171017_012654_904708_9441654F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As part of removing the timer_list.data field, this converts the wilc1000
driver to using from_timer and an explicit per-timer data field, since
there doesn't appear to be a way to sanely resolve vif from hif_drv.

Cc: Aditya Shankar <aditya.shankar@microchip.com>
Cc: Ganesh Krishna <ganesh.krishna@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/wilc1000/host_interface.c         | 39 +++++++++++++----------
 drivers/staging/wilc1000/host_interface.h         |  5 +++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 +--
 3 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7b620658ec38..c16f96308a97 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -238,6 +238,7 @@ static struct completion hif_driver_comp;
 static struct completion hif_wait_response;
 static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
+static struct wilc_vif *periodic_rssi_vif;
 
 u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
@@ -2272,7 +2273,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
-		hif_drv->remain_on_ch_timer.data = (unsigned long)vif;
+		hif_drv->remain_on_ch_timer_vif = vif;
 		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->duration));
@@ -2360,11 +2361,13 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 	return result;
 }
 
-static void ListenTimerCB(unsigned long arg)
+static void ListenTimerCB(struct timer_list *t)
 {
+	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
+						      remain_on_ch_timer);
+	struct wilc_vif *vif = hif_drv->remain_on_ch_timer_vif;
 	s32 result = 0;
 	struct host_if_msg msg;
-	struct wilc_vif *vif = (struct wilc_vif *)arg;
 
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
 
@@ -2643,9 +2646,10 @@ static void host_if_work(struct work_struct *work)
 	complete(&hif_thread_comp);
 }
 
-static void TimerCB_Scan(unsigned long arg)
+static void TimerCB_Scan(struct timer_list *t)
 {
-	struct wilc_vif *vif = (struct wilc_vif *)arg;
+	struct host_if_drv *hif_drv = from_timer(hif_drv, t, scan_timer);
+	struct wilc_vif *vif = hif_drv->scan_timer_vif;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -2655,9 +2659,11 @@ static void TimerCB_Scan(unsigned long arg)
 	wilc_enqueue_cmd(&msg);
 }
 
-static void TimerCB_Connect(unsigned long arg)
+static void TimerCB_Connect(struct timer_list *t)
 {
-	struct wilc_vif *vif = (struct wilc_vif *)arg;
+	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
+						      connect_timer);
+	struct wilc_vif *vif = hif_drv->connect_timer_vif;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3040,7 +3046,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		return -EFAULT;
 	}
 
-	hif_drv->connect_timer.data = (unsigned long)vif;
+	hif_drv->connect_timer_vif = vif;
 	mod_timer(&hif_drv->connect_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
@@ -3283,7 +3289,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 		return -EINVAL;
 	}
 
-	hif_drv->scan_timer.data = (unsigned long)vif;
+	hif_drv->scan_timer_vif = vif;
 	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
@@ -3309,9 +3315,9 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	return wilc_enqueue_cmd(&msg);
 }
 
-static void GetPeriodicRSSI(unsigned long arg)
+static void GetPeriodicRSSI(struct timer_list *unused)
 {
-	struct wilc_vif *vif = (struct wilc_vif *)arg;
+	struct wilc_vif *vif = periodic_rssi_vif;
 
 	if (!vif->hif_drv) {
 		netdev_err(vif->ndev, "Driver handler is NULL\n");
@@ -3321,7 +3327,6 @@ static void GetPeriodicRSSI(unsigned long arg)
 	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED)
 		wilc_get_statistics(vif, &vif->wilc->dummy_statistics);
 
-	periodic_rssi.data = (unsigned long)vif;
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
@@ -3374,14 +3379,14 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 			goto _fail_;
 		}
 
-		setup_timer(&periodic_rssi, GetPeriodicRSSI,
-			    (unsigned long)vif);
+		periodic_rssi_vif = vif;
+		timer_setup(&periodic_rssi, GetPeriodicRSSI, 0);
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
-	setup_timer(&hif_drv->scan_timer, TimerCB_Scan, 0);
-	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
-	setup_timer(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
+	timer_setup(&hif_drv->scan_timer, TimerCB_Scan, 0);
+	timer_setup(&hif_drv->connect_timer, TimerCB_Connect, 0);
+	timer_setup(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
 	mutex_init(&hif_drv->cfg_values_lock);
 	mutex_lock(&hif_drv->cfg_values_lock);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1ce5ead318c7..65734c38bf43 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -279,8 +279,13 @@ struct host_if_drv {
 	struct completion comp_inactive_time;
 
 	struct timer_list scan_timer;
+	struct wilc_vif *scan_timer_vif;
+
 	struct timer_list connect_timer;
+	struct wilc_vif *connect_timer_vif;
+
 	struct timer_list remain_on_ch_timer;
+	struct wilc_vif *remain_on_ch_timer_vif;
 
 	bool IFC_UP;
 	int driver_handler_id;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e7882b24a338..9241a387f528 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -266,7 +266,7 @@ static void update_scan_time(void)
 		last_scanned_shadow[i].time_scan = jiffies;
 }
 
-static void remove_network_from_shadow(unsigned long arg)
+static void remove_network_from_shadow(unsigned long unused)
 {
 	unsigned long now = jiffies;
 	int i, j;
@@ -287,7 +287,6 @@ static void remove_network_from_shadow(unsigned long arg)
 	}
 
 	if (last_scanned_cnt != 0) {
-		hAgingTimer.data = arg;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 	}
 }
@@ -304,7 +303,6 @@ static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 	int i;
 
 	if (last_scanned_cnt == 0) {
-		hAgingTimer.data = (unsigned long)user_void;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
