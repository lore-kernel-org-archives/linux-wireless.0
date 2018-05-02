Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:23631 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbeEBHPe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:34 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/21] staging: wilc1000: remove static variable 'del_beacon' and null check
Date: Wed, 2 May 2018 12:43:39 +0530
Message-ID: <1525245227-3924-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093237_969464_A679E6E6)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using local variable instead of static varible 'del_beacon'. Also removed
the unnecessary 'if' check in handle_del_beacon().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5b824b..930af0c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -246,7 +246,6 @@ static s8 rssi;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 inactive_time;
-static u8 del_beacon;
 static u32 clients_count;
 
 #define REAL_JOIN_REQ 0
@@ -2019,15 +2018,13 @@ static void handle_del_beacon(struct wilc_vif *vif)
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
+	u8 del_beacon = 0;
 
 	wid.id = (u16)WID_DEL_BEACON;
 	wid.type = WID_CHAR;
 	wid.size = sizeof(char);
 	wid.val = &del_beacon;
 
-	if (!wid.val)
-		return;
-
 	cur_byte = wid.val;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-- 
2.7.4
