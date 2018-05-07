Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2126 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbeEGIoK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:10 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/30] staging: wilc1000: rename kmalloc with kmemdup() in handle_connect_timeout()
Date: Mon, 7 May 2018 14:13:13 +0530
Message-ID: <1525682614-3824-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104417_357283_A896E6B9)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of kmalloc and memcpy use kmemdup in handle_connect_timeout().
Also return -ENOMEM incase of failure to allocate the memory.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1f67a7..ad9270e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1166,10 +1166,11 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 		if (hif_drv->usr_conn_req.ies) {
 			info.req_ies_len = hif_drv->usr_conn_req.ies_len;
-			info.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-			memcpy(info.req_ies,
-			       hif_drv->usr_conn_req.ies,
-			       hif_drv->usr_conn_req.ies_len);
+			info.req_ies = kmemdup(hif_drv->usr_conn_req.ies,
+					       hif_drv->usr_conn_req.ies_len,
+					       GFP_KERNEL);
+			if (!info.req_ies)
+				return -ENOMEM;
 		}
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
-- 
2.7.4
