Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9818 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbeEKIOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:08 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 05/30] staging: wilc1000: fix line over 80 chars issue in host_int_handle_disconnect()
Date: Fri, 11 May 2018 13:43:06 +0530
Message-ID: <1526026411-11058-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101412_181481_5A78B0E6)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 char issue in host_int_handle_disconnect() by using
temp variable to hold the 'wilc_connect_result' function pointer.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 84eff27..b8dcca6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1396,6 +1396,7 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 {
 	struct disconnect_info disconn_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	wilc_connect_result conn_result = hif_drv->usr_conn_req.conn_result;
 
 	memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
@@ -1408,13 +1409,12 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 	disconn_info.ie = NULL;
 	disconn_info.ie_len = 0;
 
-	if (hif_drv->usr_conn_req.conn_result) {
+	if (conn_result) {
 		wilc_optaining_ip = false;
 		wilc_set_power_mgmt(vif, 0, 0);
 
-		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
-						  NULL, 0, &disconn_info,
-						  hif_drv->usr_conn_req.arg);
+		conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL, 0,
+			    &disconn_info, hif_drv->usr_conn_req.arg);
 	} else {
 		netdev_err(vif->ndev, "Connect result NULL\n");
 	}
-- 
2.7.4
