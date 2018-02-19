Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbeBSPam (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:42 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/14] staging: wilc1000: rename functions starting with TimerCB_ to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:40 +0530
Message-ID: <1519054184-14301-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163048_522274_E7B2FB51)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issues found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b861c95..6e39766 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2647,7 +2647,7 @@ static void host_if_work(struct work_struct *work)
 	complete(&hif_thread_comp);
 }
 
-static void TimerCB_Scan(struct timer_list *t)
+static void timer_scan_cb(struct timer_list *t)
 {
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t, scan_timer);
 	struct wilc_vif *vif = hif_drv->scan_timer_vif;
@@ -2660,7 +2660,7 @@ static void TimerCB_Scan(struct timer_list *t)
 	wilc_enqueue_cmd(&msg);
 }
 
-static void TimerCB_Connect(struct timer_list *t)
+static void timer_connect_cb(struct timer_list *t)
 {
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
 						      connect_timer);
@@ -3385,8 +3385,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
-	timer_setup(&hif_drv->scan_timer, TimerCB_Scan, 0);
-	timer_setup(&hif_drv->connect_timer, TimerCB_Connect, 0);
+	timer_setup(&hif_drv->scan_timer, timer_scan_cb, 0);
+	timer_setup(&hif_drv->connect_timer, timer_connect_cb, 0);
 	timer_setup(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
 	mutex_init(&hif_drv->cfg_values_lock);
-- 
2.7.4
