Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12575 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbeIDLES (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:18 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 14/26] staging: wilc1000: move 'rcv_assoc_resp' as part of hif_drv
Date: Tue, 4 Sep 2018 12:09:30 +0530
Message-ID: <1536043182-19735-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084101_910361_78E7C483)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variable and move 'rcv_assoc_resp' as part of
'hif_drv' struct. Rename from 'rcv_assoc_resp' to 'assoc_resp'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++-----
 drivers/staging/wilc1000/host_interface.h | 1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 18448fa..c3f2fc9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -191,8 +191,6 @@ static u8 p2p_listen_state;
 static struct completion hif_driver_comp;
 static struct mutex hif_deinit_lock;
 
-static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
-
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 
@@ -1502,16 +1500,16 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	if (mac_status == MAC_STATUS_CONNECTED) {
 		u32 assoc_resp_info_len;
 
-		memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
+		memset(hif_drv->assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
-		host_int_get_assoc_res_info(vif, rcv_assoc_resp,
+		host_int_get_assoc_res_info(vif, hif_drv->assoc_resp,
 					    MAX_ASSOC_RESP_FRAME_SIZE,
 					    &assoc_resp_info_len);
 
 		if (assoc_resp_info_len != 0) {
 			s32 err = 0;
 
-			err = wilc_parse_assoc_resp_info(rcv_assoc_resp,
+			err = wilc_parse_assoc_resp_info(hif_drv->assoc_resp,
 							 assoc_resp_info_len,
 							 &conn_info);
 			if (err)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4dd8510..12dec47 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -284,6 +284,7 @@ struct host_if_drv {
 
 	bool ifc_up;
 	int driver_handler_id;
+	u8 assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 };
 
 struct add_sta_param {
-- 
2.7.4
