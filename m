Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:52322 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbeGSGqs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:48 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 18/23] staging: wilc1000: avoid host_int_get_assoc_res_info() forward declaration
Date: Thu, 19 Jul 2018 04:15:14 +0530
Message-ID: <1531953919-20804-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080525_456283_932A1C43)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder the function position in host interface to avoid forward
declaration of host_int_get_assoc_res_info().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 47 ++++++++++++++-----------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eabe5c7..f49e849 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1287,7 +1287,27 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u8 *assoc_resp_info,
 				       u32 max_assoc_resp_info_len,
-				       u32 *rcvd_assoc_resp_info_len);
+				       u32 *rcvd_assoc_resp_info_len)
+{
+	s32 result;
+	struct wid wid;
+
+	wid.id = WID_ASSOC_RES_INFO;
+	wid.type = WID_STR;
+	wid.val = assoc_resp_info;
+	wid.size = max_assoc_resp_info_len;
+
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result) {
+		*rcvd_assoc_resp_info_len = 0;
+		netdev_err(vif->ndev, "Failed to send association response\n");
+		return -EINVAL;
+	}
+
+	*rcvd_assoc_resp_info_len = wid.size;
+	return result;
+}
 
 static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv)
 {
@@ -2979,31 +2999,6 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	return result;
 }
 
-static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
-				       u8 *assoc_resp_info,
-				       u32 max_assoc_resp_info_len,
-				       u32 *rcvd_assoc_resp_info_len)
-{
-	s32 result = 0;
-	struct wid wid;
-
-	wid.id = WID_ASSOC_RES_INFO;
-	wid.type = WID_STR;
-	wid.val = assoc_resp_info;
-	wid.size = max_assoc_resp_info_len;
-
-	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result) {
-		*rcvd_assoc_resp_info_len = 0;
-		netdev_err(vif->ndev, "Failed to send association response\n");
-		return -EINVAL;
-	}
-
-	*rcvd_assoc_resp_info_len = wid.size;
-	return result;
-}
-
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
 	int result;
-- 
2.7.4
