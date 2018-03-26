Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbeCZLqe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:34 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 7/9] staging: wilc1000: free allocated memory in wilc_add_rx_gtk()
Date: Mon, 26 Mar 2018 17:16:01 +0530
Message-ID: <1522064763-11576-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134637_035712_96EE14B8)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free memory allocated in wilc_add_rx_gtk() before returing from the
function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e58fa87..d2efec2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2841,7 +2841,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 key_len = gtk_key_len;
@@ -2880,8 +2880,10 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg.body.key_info.attr.wpa.key = kmemdup(rx_gtk,
 						 key_len,
 						 GFP_KERNEL);
-	if (!msg.body.key_info.attr.wpa.key)
+	if (!msg.body.key_info.attr.wpa.key) {
+		kfree(msg.body.key_info.attr.wpa.seq);
 		return -ENOMEM;
+	}
 
 	if (rx_mic)
 		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
@@ -2896,12 +2898,15 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "RX GTK\n");
-	else
-		wait_for_completion(&hif_drv->comp_test_key_block);
+		kfree(msg.body.key_info.attr.wpa.seq);
+		kfree(msg.body.key_info.attr.wpa.key);
+		return result;
+	}
 
-	return result;
+	wait_for_completion(&hif_drv->comp_test_key_block);
+	return 0;
 }
 
 int wilc_set_pmkid_info(struct wilc_vif *vif,
-- 
2.7.4
