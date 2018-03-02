Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:30127 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425214AbeCBOXw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:52 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/13] staging: wilc1000: fix line over 80 char in wilc_del_allstation() & wilc_deinit()
Date: Fri, 2 Mar 2018 19:52:45 +0530
Message-ID: <1520000569-27738-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152355_367863_B7AD9EF0)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 57f90e4..e071eaf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3444,7 +3444,8 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-						  hif_drv->usr_scan_req.arg, NULL);
+						  hif_drv->usr_scan_req.arg,
+						  NULL);
 		hif_drv->usr_scan_req.scan_result = NULL;
 	}
 
@@ -3796,7 +3797,8 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
-			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i], ETH_ALEN);
+			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i],
+			       ETH_ALEN);
 			assoc_sta++;
 		}
 	}
-- 
2.7.4
