Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:11869 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbeA3QvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 11:51:12 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/7] staging: wilc1000: rename Handle_DelAllSta() and its variable using camelCase
Date: Tue, 30 Jan 2018 22:20:28 +0530
Message-ID: <1517331033-5718-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180130_175116_809535_C0F39C43)
In-Reply-To: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
References: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8f8e727..f0168e3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2123,34 +2123,34 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	kfree(wid.val);
 }
 
-static void Handle_DelAllSta(struct wilc_vif *vif,
-			     struct del_all_sta *pstrDelAllStaParam)
+static void handle_del_all_sta(struct wilc_vif *vif,
+			       struct del_all_sta *param)
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *curr_byte;
 	u8 i;
-	u8 au8Zero_Buff[6] = {0};
+	u8 zero_buff[6] = {0};
 
 	wid.id = (u16)WID_DEL_ALL_STA;
 	wid.type = WID_STR;
-	wid.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
+	wid.size = (param->assoc_sta * ETH_ALEN) + 1;
 
-	wid.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
+	wid.val = kmalloc((param->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
+	curr_byte = wid.val;
 
-	*(pu8CurrByte++) = pstrDelAllStaParam->assoc_sta;
+	*(curr_byte++) = param->assoc_sta;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
-		if (memcmp(pstrDelAllStaParam->del_all_sta[i], au8Zero_Buff, ETH_ALEN))
-			memcpy(pu8CurrByte, pstrDelAllStaParam->del_all_sta[i], ETH_ALEN);
+		if (memcmp(param->del_all_sta[i], zero_buff, ETH_ALEN))
+			memcpy(curr_byte, param->del_all_sta[i], ETH_ALEN);
 		else
 			continue;
 
-		pu8CurrByte += ETH_ALEN;
+		curr_byte += ETH_ALEN;
 	}
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
@@ -2626,7 +2626,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_DEL_ALL_STA:
-		Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
+		handle_del_all_sta(msg->vif, &msg->body.del_all_sta_info);
 		break;
 
 	case HOST_IF_MSG_SET_TX_POWER:
-- 
2.7.4
