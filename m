Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4389 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbeEGIoG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:06 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/30] staging: wilc1000: fix line over 80 chars in host_int_parse_assoc_resp_info()
Date: Mon, 7 May 2018 14:13:12 +0530
Message-ID: <1525682614-3824-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104416_524861_E96C27AC)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issue in host_int_parse_assoc_resp_info() by
using shorter name for the local variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c9c5d352..b1f67a7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1320,18 +1320,19 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	memset(&conn_info, 0, sizeof(struct connect_info));
 
 	if (mac_status == MAC_STATUS_CONNECTED) {
-		u32 rcvd_assoc_resp_info_len;
+		u32 assoc_resp_info_len;
 
 		memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
 		host_int_get_assoc_res_info(vif, rcv_assoc_resp,
 					    MAX_ASSOC_RESP_FRAME_SIZE,
-					    &rcvd_assoc_resp_info_len);
+					    &assoc_resp_info_len);
 
-		if (rcvd_assoc_resp_info_len != 0) {
+		if (assoc_resp_info_len != 0) {
 			s32 err = 0;
 
-			err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
+			err = wilc_parse_assoc_resp_info(rcv_assoc_resp,
+							 assoc_resp_info_len,
 							 &connect_resp_info);
 			if (err)
 				netdev_err(vif->ndev,
-- 
2.7.4
