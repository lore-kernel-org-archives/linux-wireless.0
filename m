Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44341 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752062AbeDLIVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:21:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: fix NULL pointer exception in host_int_parse_assoc_resp_info()
Date: Thu, 12 Apr 2018 13:51:14 +0530
Message-ID: <1523521274-8719-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180412_102140_840353_F685A582)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit fe014d4e6b55 (staging: wilc1000: free memory allocated for general info
message from firmware) introduced a bug by using wrong source address in
kmemdup(). 'conn_info.req_ies' is used for source address in kempdup()
instead of 'hif_drv->usr_conn_req.ies'.

This commit fixes the NULL pointer dereference issue in
host_int_parse_assoc_resp_info() by using the correct source address in
kmemdup().

Fixes: fe014d4e6b55 (staging: wilc1000: free memory allocated for
general info message from firmware)
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 316d73c..302e3cb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1387,7 +1387,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	}
 
 	if (hif_drv->usr_conn_req.ies) {
-		conn_info.req_ies = kmemdup(conn_info.req_ies,
+		conn_info.req_ies = kmemdup(hif_drv->usr_conn_req.ies,
 					    hif_drv->usr_conn_req.ies_len,
 					    GFP_KERNEL);
 		if (conn_info.req_ies)
-- 
2.7.4
