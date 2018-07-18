Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32733 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeGSGqb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:31 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/23] staging: wilc1000: use lowercase for 'IFC_UP' struct element name
Date: Thu, 19 Jul 2018 04:15:09 +0530
Message-ID: <1531953919-20804-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080509_475249_0D3E9CD0)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use lowercase for structure element name to follow
linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 79166a5..9a016c5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -277,7 +277,7 @@ struct host_if_drv {
 	struct timer_list remain_on_ch_timer;
 	struct wilc_vif *remain_on_ch_timer_vif;
 
-	bool IFC_UP;
+	bool ifc_up;
 	int driver_handler_id;
 };
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 032afc2..84d3145 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -45,7 +45,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 	switch (event) {
 	case NETDEV_UP:
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
-			hif_drv->IFC_UP = 1;
+			hif_drv->ifc_up = 1;
 			wilc_optaining_ip = false;
 			del_timer(&wilc_during_ip_timer);
 		}
@@ -65,7 +65,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 
 	case NETDEV_DOWN:
 		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
-			hif_drv->IFC_UP = 0;
+			hif_drv->ifc_up = 0;
 			wilc_optaining_ip = false;
 		}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e561dce..ebe7adc2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -535,9 +535,9 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 
 		if (!wfi_drv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-		if (wfi_drv->IFC_UP && dev == wl->vif[1]->ndev)
+		if (wfi_drv->ifc_up && dev == wl->vif[1]->ndev)
 			disconn_info->reason = 3;
-		else if (!wfi_drv->IFC_UP && dev == wl->vif[1]->ndev)
+		else if (!wfi_drv->ifc_up && dev == wl->vif[1]->ndev)
 			disconn_info->reason = 1;
 
 		cfg80211_disconnected(dev, disconn_info->reason,
-- 
2.7.4
