Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbeBSPaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:17 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/14] staging: wilc1000: rename host_int_get_assoc_res_info() parameters to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:33 +0530
Message-ID: <1519054184-14301-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163022_047181_65475FEE)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issues reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index edd35b7..ec98ccd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1314,9 +1314,9 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 }
 
 static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
-				       u8 *pu8AssocRespInfo,
-				       u32 u32MaxAssocRespInfoLen,
-				       u32 *pu32RcvdAssocRespInfoLen);
+				       u8 *assoc_resp_info,
+				       u32 max_assoc_resp_info_len,
+				       u32 *rcvd_assoc_resp_info_len);
 
 static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
@@ -3080,27 +3080,27 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 }
 
 static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
-				       u8 *pu8AssocRespInfo,
-				       u32 u32MaxAssocRespInfoLen,
-				       u32 *pu32RcvdAssocRespInfoLen)
+				       u8 *assoc_resp_info,
+				       u32 max_assoc_resp_info_len,
+				       u32 *rcvd_assoc_resp_info_len)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_ASSOC_RES_INFO;
 	wid.type = WID_STR;
-	wid.val = pu8AssocRespInfo;
-	wid.size = u32MaxAssocRespInfoLen;
+	wid.val = assoc_resp_info;
+	wid.size = max_assoc_resp_info_len;
 
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
-		*pu32RcvdAssocRespInfoLen = 0;
+		*rcvd_assoc_resp_info_len = 0;
 		netdev_err(vif->ndev, "Failed to send association response\n");
 		return -EINVAL;
 	}
 
-	*pu32RcvdAssocRespInfoLen = wid.size;
+	*rcvd_assoc_resp_info_len = wid.size;
 	return result;
 }
 
-- 
2.7.4
