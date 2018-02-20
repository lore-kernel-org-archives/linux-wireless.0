Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbeBTO6a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:30 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/12] staging: wilc1000: rename pstrSetBeaconParam to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:55 +0530
Message-ID: <1519138681-1982-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155833_151858_C0EFE1EC)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 51 +++++++++++++++----------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 57f0201..9eb808e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1986,8 +1986,7 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 	return result;
 }
 
-static void handle_add_beacon(struct wilc_vif *vif,
-			      struct beacon_attr *pstrSetBeaconParam)
+static void handle_add_beacon(struct wilc_vif *vif, struct beacon_attr *param)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -1995,38 +1994,38 @@ static void handle_add_beacon(struct wilc_vif *vif,
 
 	wid.id = (u16)WID_ADD_BEACON;
 	wid.type = WID_BIN;
-	wid.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
+	wid.size = param->head_len + param->tail_len + 16;
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
 
 	cur_byte = wid.val;
-	*cur_byte++ = (pstrSetBeaconParam->interval & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->interval >> 8) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->interval >> 16) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->interval >> 24) & 0xFF);
+	*cur_byte++ = (param->interval & 0xFF);
+	*cur_byte++ = ((param->interval >> 8) & 0xFF);
+	*cur_byte++ = ((param->interval >> 16) & 0xFF);
+	*cur_byte++ = ((param->interval >> 24) & 0xFF);
 
-	*cur_byte++ = (pstrSetBeaconParam->dtim_period & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 8) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 16) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 24) & 0xFF);
+	*cur_byte++ = (param->dtim_period & 0xFF);
+	*cur_byte++ = ((param->dtim_period >> 8) & 0xFF);
+	*cur_byte++ = ((param->dtim_period >> 16) & 0xFF);
+	*cur_byte++ = ((param->dtim_period >> 24) & 0xFF);
 
-	*cur_byte++ = (pstrSetBeaconParam->head_len & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 8) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 16) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 24) & 0xFF);
+	*cur_byte++ = (param->head_len & 0xFF);
+	*cur_byte++ = ((param->head_len >> 8) & 0xFF);
+	*cur_byte++ = ((param->head_len >> 16) & 0xFF);
+	*cur_byte++ = ((param->head_len >> 24) & 0xFF);
 
-	memcpy(cur_byte, pstrSetBeaconParam->head, pstrSetBeaconParam->head_len);
-	cur_byte += pstrSetBeaconParam->head_len;
+	memcpy(cur_byte, param->head, param->head_len);
+	cur_byte += param->head_len;
 
-	*cur_byte++ = (pstrSetBeaconParam->tail_len & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 8) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
-	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
+	*cur_byte++ = (param->tail_len & 0xFF);
+	*cur_byte++ = ((param->tail_len >> 8) & 0xFF);
+	*cur_byte++ = ((param->tail_len >> 16) & 0xFF);
+	*cur_byte++ = ((param->tail_len >> 24) & 0xFF);
 
-	if (pstrSetBeaconParam->tail)
-		memcpy(cur_byte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
-	cur_byte += pstrSetBeaconParam->tail_len;
+	if (param->tail)
+		memcpy(cur_byte, param->tail, param->tail_len);
+	cur_byte += param->tail_len;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2035,8 +2034,8 @@ static void handle_add_beacon(struct wilc_vif *vif,
 
 ERRORHANDLER:
 	kfree(wid.val);
-	kfree(pstrSetBeaconParam->head);
-	kfree(pstrSetBeaconParam->tail);
+	kfree(param->head);
+	kfree(param->tail);
 }
 
 static void handle_del_beacon(struct wilc_vif *vif)
-- 
2.7.4
