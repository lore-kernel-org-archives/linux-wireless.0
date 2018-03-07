Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34753 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeCHPwb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:31 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/10] staging: wilc1000: rename WILC_HostIf_PackStaParam to avoid camelCase
Date: Wed, 7 Mar 2018 07:43:57 +0530
Message-ID: <1520388839-7048-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165234_396229_6FBF533A)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5bf3bcc..b26ea85 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2081,7 +2081,7 @@ static void handle_del_beacon(struct wilc_vif *vif)
 		netdev_err(vif->ndev, "Failed to send delete beacon\n");
 }
 
-static u32 WILC_HostIf_PackStaParam(u8 *buff, struct add_sta_param *param)
+static u32 wilc_hif_pack_sta_param(u8 *buff, struct add_sta_param *param)
 {
 	u8 *cur_byte;
 
@@ -2127,7 +2127,7 @@ static void handle_add_station(struct wilc_vif *vif,
 		goto error;
 
 	cur_byte = wid.val;
-	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
+	cur_byte += wilc_hif_pack_sta_param(cur_byte, param);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2223,7 +2223,7 @@ static void handle_edit_station(struct wilc_vif *vif,
 		goto error;
 
 	cur_byte = wid.val;
-	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
+	cur_byte += wilc_hif_pack_sta_param(cur_byte, param);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-- 
2.7.4
