Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbeBSPaf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:35 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/14] staging: wilc1000: rename pstrRcvdNetworkInfo to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:38 +0530
Message-ID: <1519054184-14301-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163047_171801_639CC6BE)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d489b27..24c9a36 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1245,7 +1245,7 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 }
 
 static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
-				struct rcvd_net_info *pstrRcvdNetworkInfo)
+				struct rcvd_net_info *rcvd_info)
 {
 	u32 i;
 	bool bNewNtwrkFound;
@@ -1257,7 +1257,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 	bNewNtwrkFound = true;
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		wilc_parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
+		wilc_parse_network_info(rcvd_info->buffer, &pstrNetworkInfo);
 		if (!pstrNetworkInfo ||
 		    !hif_drv->usr_scan_req.scan_result) {
 			netdev_err(vif->ndev, "driver is null\n");
@@ -1302,8 +1302,8 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 	}
 
 done:
-	kfree(pstrRcvdNetworkInfo->buffer);
-	pstrRcvdNetworkInfo->buffer = NULL;
+	kfree(rcvd_info->buffer);
+	rcvd_info->buffer = NULL;
 
 	if (pstrNetworkInfo) {
 		kfree(pstrNetworkInfo->ies);
-- 
2.7.4
