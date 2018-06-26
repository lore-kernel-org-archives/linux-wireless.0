Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:32360 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeFZGHu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/12] staging: wilc1000: avoid use of static variable 'rssi'
Date: Tue, 26 Jun 2018 11:37:13 +0530
Message-ID: <1529993234-27294-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080753_858873_FA801120)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of static variable now allocating the data and passing to
handle_get_rssi() to fill the rssi information.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f61a20d..52c0c10 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -196,7 +196,6 @@ u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-static s8 rssi;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 clients_count;
@@ -1829,7 +1828,7 @@ static void handle_get_rssi(struct work_struct *work)
 
 	wid.id = (u16)WID_RSSI;
 	wid.type = WID_CHAR;
-	wid.val = &rssi;
+	wid.val = msg->body.data;
 	wid.size = sizeof(char);
 
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
@@ -3115,14 +3114,21 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+	msg->body.data = kzalloc(sizeof(s8), GFP_KERNEL);
+	if (!msg->body.data) {
+		kfree(msg);
+		return -ENOMEM;
+	}
+
 	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 	} else {
 		wait_for_completion(&msg->work_comp);
-		*rssi_level = rssi;
+		*rssi_level = *msg->body.data;
 	}
 
+	kfree(msg->body.data);
 	kfree(msg);
 
 	return result;
-- 
2.7.4
