Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57916 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 15/24] staging: wilc1000: move 'rcv_assoc_resp' as part of hif_drv
Date: Tue, 14 Aug 2018 12:20:07 +0530
Message-ID: <1534229416-13254-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085114_257636_693D7F9C)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
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
index 98098fb..4c148bc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -187,8 +187,6 @@ struct join_bss_param {
 
 static u8 p2p_listen_state;
 
-static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
-
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 
@@ -1498,16 +1496,16 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
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
index 4a84dd2..80cb298 100644
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
