Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbeBTO6M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:12 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/12] staging: wilc1000: rename pu8HdnNtwrksWidVal to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:50 +0530
Message-ID: <1519138681-1982-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155815_444383_B8E4E587)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
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
index 6f93966..f3a56e5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -754,7 +754,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	u32 i;
 	u8 *buffer;
 	u8 valuesize = 0;
-	u8 *pu8HdnNtwrksWidVal = NULL;
+	u8 *hdn_ntwk_wid_val = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	hif_drv->usr_scan_req.scan_result = scan_info->result;
@@ -780,8 +780,8 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 
 	for (i = 0; i < scan_info->hidden_network.n_ssids; i++)
 		valuesize += ((scan_info->hidden_network.net_info[i].ssid_len) + 1);
-	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
-	wid_list[index].val = pu8HdnNtwrksWidVal;
+	hdn_ntwk_wid_val = kmalloc(valuesize + 1, GFP_KERNEL);
+	wid_list[index].val = hdn_ntwk_wid_val;
 	if (wid_list[index].val) {
 		buffer = wid_list[index].val;
 
@@ -858,7 +858,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	kfree(scan_info->hidden_network.net_info);
 	scan_info->hidden_network.net_info = NULL;
 
-	kfree(pu8HdnNtwrksWidVal);
+	kfree(hdn_ntwk_wid_val);
 
 	return result;
 }
-- 
2.7.4
