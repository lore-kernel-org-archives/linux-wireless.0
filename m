Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57547 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424959AbeCBOXU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:20 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/13] staging: wilc1000: rename enuEvent to avoid camelCase
Date: Fri, 2 Mar 2018 19:52:37 +0530
Message-ID: <1520000569-27738-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152326_674447_8A0F691F)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 253225c..b46a759 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -267,7 +267,7 @@ static struct wilc_vif *join_req_vif;
 
 static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event enuEvent);
+static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
 static void host_if_work(struct work_struct *work);
 
 /*!
@@ -863,15 +863,14 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	return result;
 }
 
-static s32 handle_scan_done(struct wilc_vif *vif,
-			    enum scan_event enuEvent)
+static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 {
 	s32 result = 0;
 	u8 u8abort_running_scan;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (enuEvent == SCAN_EVENT_ABORTED) {
+	if (evt == SCAN_EVENT_ABORTED) {
 		u8abort_running_scan = 1;
 		wid.id = (u16)WID_ABORT_RUNNING_SCAN;
 		wid.type = WID_CHAR;
@@ -893,7 +892,7 @@ static s32 handle_scan_done(struct wilc_vif *vif,
 	}
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		hif_drv->usr_scan_req.scan_result(enuEvent, NULL,
+		hif_drv->usr_scan_req.scan_result(evt, NULL,
 						  hif_drv->usr_scan_req.arg, NULL);
 		hif_drv->usr_scan_req.scan_result = NULL;
 	}
-- 
2.7.4
