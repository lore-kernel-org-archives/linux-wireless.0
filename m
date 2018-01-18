Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16916 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932405AbeARNSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:18:40 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/14] staging: wilc1000: rename Handle_ScanDone() to avoid camelCase
Date: Thu, 18 Jan 2018 18:47:10 +0530
Message-ID: <1516281432-7724-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180118_141920_807779_AFADC29F)
In-Reply-To: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix "Avoid camelCase" issue reported by checkpatch.pl
script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d017c86..5ea7c4b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -267,7 +267,7 @@ static struct wilc_vif *join_req_vif;
 
 static void *host_parse_join_bss_param(struct network_info *info);
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
@@ -1461,7 +1461,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if (hif_drv->usr_scan_req.scan_result) {
 				del_timer(&hif_drv->scan_timer);
-				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
+				handle_scan_done(vif, SCAN_EVENT_ABORTED);
 			}
 
 			strDisconnectNotifInfo.reason = 0;
@@ -1509,7 +1509,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
-				Handle_ScanDone(vif, SCAN_EVENT_ABORTED);
+				handle_scan_done(vif, SCAN_EVENT_ABORTED);
 		}
 	}
 
@@ -2526,7 +2526,7 @@ static void host_if_work(struct work_struct *work)
 		if (!wilc_wlan_get_num_conn_ifcs(wilc))
 			wilc_chip_sleep_manually(wilc);
 
-		Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
+		handle_scan_done(msg->vif, SCAN_EVENT_DONE);
 
 		if (msg->vif->hif_drv->remain_on_ch_pending)
 			Handle_RemainOnChan(msg->vif,
@@ -2568,7 +2568,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_SCAN_TIMER_FIRED:
-		Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
+		handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
 		break;
 
 	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-- 
2.7.4
