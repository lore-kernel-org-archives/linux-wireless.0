Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:11869 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeA3QvZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 11:51:25 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 6/7] staging: wilc1000: rename Handle_ScanDone function to avoid camelCase
Date: Tue, 30 Jan 2018 22:20:32 +0530
Message-ID: <1517331033-5718-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180130_175128_404433_DEDF14B0)
In-Reply-To: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
References: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue reported by checkpatch.pl.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 43f8559..f5fdca7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -267,7 +267,7 @@ static struct wilc_vif *join_req_vif;
 
 static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
+static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event enuEvent);
 static void host_if_work(struct work_struct *work);
 
 /*!
@@ -847,7 +847,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 ERRORHANDLER:
 	if (result) {
 		del_timer(&hif_drv->scan_timer);
-		Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
+		handle_scan_done(vif, SCAN_EVENT_ABORTED);
 	}
 
 	kfree(scan_info->ch_freq_list);
@@ -863,8 +863,8 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	return result;
 }
 
-static s32 Handle_ScanDone(struct wilc_vif *vif,
-			   enum scan_event enuEvent)
+static s32 handle_scan_done(struct wilc_vif *vif,
+			    enum scan_event enuEvent)
 {
 	s32 result = 0;
 	u8 u8abort_running_scan;
@@ -1467,7 +1467,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if (hif_drv->usr_scan_req.scan_result) {
 				del_timer(&hif_drv->scan_timer);
-				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
+				handle_scan_done(vif, SCAN_EVENT_ABORTED);
 			}
 
 			strDisconnectNotifInfo.reason = 0;
@@ -1515,7 +1515,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
-				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
+				handle_scan_done(vif, SCAN_EVENT_ABORTED);
 		}
 	}
 
@@ -2532,7 +2532,7 @@ static void host_if_work(struct work_struct *work)
 		if (!wilc_wlan_get_num_conn_ifcs(wilc))
 			wilc_chip_sleep_manually(wilc);
 
-		Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
+		handle_scan_done(msg->vif, SCAN_EVENT_DONE);
 
 		if (msg->vif->hif_drv->remain_on_ch_pending)
 			Handle_RemainOnChan(msg->vif,
@@ -2574,7 +2574,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_SCAN_TIMER_FIRED:
-		Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
+		handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
 		break;
 
 	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-- 
2.7.4
