Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbeCZLqb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:31 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 6/9] staging: wilc1000: fix to free allocated memory in wilc_add_ptk()
Date: Mon, 26 Mar 2018 17:16:00 +0530
Message-ID: <1522064763-11576-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134633_889817_131DFC3D)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free allocated memory in wilc_add_ptk() when it fails to enqueue the
command.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0494234..e58fa87 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2781,7 +2781,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
 		 u8 mode, u8 cipher_mode, u8 index)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 key_len = ptk_key_len;
@@ -2826,13 +2826,14 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
-
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "PTK Key\n");
-	else
-		wait_for_completion(&hif_drv->comp_test_key_block);
+		kfree(msg.body.key_info.attr.wpa.key);
+		return result;
+	}
 
-	return result;
+	wait_for_completion(&hif_drv->comp_test_key_block);
+	return 0;
 }
 
 int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
-- 
2.7.4
