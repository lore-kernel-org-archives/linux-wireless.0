Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12385 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMF5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:05:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 06/29] staging: wilc1000: use 'void' return type for host_int_get_assoc_res_info()
Date: Thu, 20 Sep 2018 11:53:17 +0530
Message-ID: <1537424620-6982-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082455_269257_B8226B0C)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change return type to 'void' for host_int_get_assoc_res_info() as its
return value is not used. 'rcvd_assoc_resp_info_len' parameter value is
used to know the status.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7729f83..237a098d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1388,10 +1388,10 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 	kfree(msg);
 }
 
-static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
-				       u8 *assoc_resp_info,
-				       u32 max_assoc_resp_info_len,
-				       u32 *rcvd_assoc_resp_info_len)
+static void host_int_get_assoc_res_info(struct wilc_vif *vif,
+					u8 *assoc_resp_info,
+					u32 max_assoc_resp_info_len,
+					u32 *rcvd_assoc_resp_info_len)
 {
 	int result;
 	struct wid wid;
@@ -1406,11 +1406,10 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	if (result) {
 		*rcvd_assoc_resp_info_len = 0;
 		netdev_err(vif->ndev, "Failed to send association response\n");
-		return -EINVAL;
+		return;
 	}
 
 	*rcvd_assoc_resp_info_len = wid.size;
-	return result;
 }
 
 static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv)
-- 
2.7.4
