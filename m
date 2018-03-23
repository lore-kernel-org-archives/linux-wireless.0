Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34176 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeCWPJd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:09:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 7/9] staging: wilc1000: free allocated memory in wilc_add_rx_gtk()
Date: Fri, 23 Mar 2018 20:38:56 +0530
Message-ID: <1521817738-7557-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180323_160947_437328_3001CDAE)
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free memory allocated in wilc_add_rx_gtk() before returing from the
function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a8771d5..74095ec 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2881,8 +2881,10 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
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
@@ -2897,10 +2899,13 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "RX GTK\n");
-	else
+		kfree(msg.body.key_info.attr.wpa.seq);
+		kfree(msg.body.key_info.attr.wpa.key);
+	} else {
 		wait_for_completion(&hif_drv->comp_test_key_block);
+	}
 
 	return result;
 }
-- 
2.7.4
