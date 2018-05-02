Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53170 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:38 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/21] staging: wilc1000: remove the use of cur_byte variable in functions
Date: Wed, 2 May 2018 12:43:40 +0530
Message-ID: <1525245227-3924-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093237_273902_491355CC)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using the intermediate variable to hold the value, now directly
using the allocated variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 930af0c..6746e2f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2017,7 +2017,6 @@ static void handle_del_beacon(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *cur_byte;
 	u8 del_beacon = 0;
 
 	wid.id = (u16)WID_DEL_BEACON;
@@ -2025,8 +2024,6 @@ static void handle_del_beacon(struct wilc_vif *vif)
 	wid.size = sizeof(char);
 	wid.val = &del_beacon;
 
-	cur_byte = wid.val;
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
@@ -2136,7 +2133,6 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *cur_byte;
 
 	wid.id = (u16)WID_REMOVE_STA;
 	wid.type = WID_BIN;
@@ -2146,9 +2142,7 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 	if (!wid.val)
 		goto error;
 
-	cur_byte = wid.val;
-
-	ether_addr_copy(cur_byte, param->mac_addr);
+	ether_addr_copy(wid.val, param->mac_addr);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-- 
2.7.4
