Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbeBSPap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:45 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/14] staging: wilc1000: rename ListenTimerCB to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:41 +0530
Message-ID: <1519054184-14301-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163049_138551_5EBB615F)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6e39766..6dd1061 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2362,7 +2362,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 	return result;
 }
 
-static void ListenTimerCB(struct timer_list *t)
+static void listen_timer_cb(struct timer_list *t)
 {
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
 						      remain_on_ch_timer);
@@ -3387,7 +3387,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	timer_setup(&hif_drv->scan_timer, timer_scan_cb, 0);
 	timer_setup(&hif_drv->connect_timer, timer_connect_cb, 0);
-	timer_setup(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
+	timer_setup(&hif_drv->remain_on_ch_timer, listen_timer_cb, 0);
 
 	mutex_init(&hif_drv->cfg_values_lock);
 	mutex_lock(&hif_drv->cfg_values_lock);
-- 
2.7.4
