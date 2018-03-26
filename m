Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeCZLq1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:27 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 5/9] staging: wilc1000: free allocated memory after processing wilc_send_config_pkt()
Date: Mon, 26 Mar 2018 17:15:59 +0530
Message-ID: <1522064763-11576-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134630_324300_057D18DC)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free allocated memory after completing wilc_send_config_pkt() function.
Remove unncessary use of 'stamac' pointer in handle_get_inactive_time().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4db15c7..0494234 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1909,7 +1909,6 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 				    struct sta_inactive_t *hif_sta_inactive)
 {
 	s32 result = 0;
-	u8 *stamac;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1920,11 +1919,11 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 	if (!wid.val)
 		return -ENOMEM;
 
-	stamac = wid.val;
-	ether_addr_copy(stamac, hif_sta_inactive->mac);
+	ether_addr_copy(wid.val, hif_sta_inactive->mac);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
+	kfree(wid.val);
 
 	if (result) {
 		netdev_err(vif->ndev, "Failed to SET inactive time\n");
@@ -2225,6 +2224,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
+	kfree(wid.val);
 	if (result != 0)
 		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
@@ -2269,6 +2269,7 @@ static int handle_register_frame(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
+	kfree(wid.val);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to frame register\n");
 		result = -EINVAL;
@@ -2300,6 +2301,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
+		kfree(wid.val);
 		if (result != 0) {
 			netdev_err(vif->ndev, "Failed to set remain channel\n");
 			goto _done_;
-- 
2.7.4
