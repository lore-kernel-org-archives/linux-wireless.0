Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34372 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbeFZGHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:47 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/12] staging: wilc1000: avoid use of static variable 'inactive_time'
Date: Tue, 26 Jun 2018 11:37:12 +0530
Message-ID: <1529993234-27294-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080750_131297_0BD7C8CA)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoided the use of static variable 'inactive_time' and move it as part of
'sta_inactive_t' structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2251c39f..f61a20d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -110,6 +110,7 @@ struct set_ip_addr {
 };
 
 struct sta_inactive_t {
+	u32 inactive_time;
 	u8 mac[6];
 };
 
@@ -198,7 +199,6 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 static s8 rssi;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
-static u32 inactive_time;
 static u32 clients_count;
 
 static void *host_int_parse_join_bss_param(struct network_info *info);
@@ -1927,7 +1927,7 @@ static void handle_get_inactive_time(struct work_struct *work)
 
 	wid.id = (u16)WID_GET_INACTIVE_TIME;
 	wid.type = WID_INT;
-	wid.val = (s8 *)&inactive_time;
+	wid.val = (s8 *)&hif_sta_inactive->inactive_time;
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
@@ -3095,7 +3095,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	else
 		wait_for_completion(&msg->work_comp);
 
-	*out_val = inactive_time;
+	*out_val = msg->body.mac_info.inactive_time;
 	kfree(msg);
 
 	return result;
-- 
2.7.4
