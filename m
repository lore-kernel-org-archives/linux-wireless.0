Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12105 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeEGIoA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/30] staging: wilc1000: fix line over 80 chars issue in host_int_handle_disconnect()
Date: Mon, 7 May 2018 14:13:10 +0530
Message-ID: <1525682614-3824-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104404_344018_1CD42A33)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
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
index a341ff1..0d84af9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1401,6 +1401,7 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 {
 	struct disconnect_info disconn_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	wilc_connect_result conn_result = hif_drv->usr_conn_req.conn_result;
 
 	memset(&disconn_info, 0, sizeof(struct disconnect_info));
 
@@ -1413,13 +1414,12 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
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
