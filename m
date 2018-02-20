Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbeBTO6k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:40 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/12] staging: wilc1000: rename pstrDelStaParam to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:58 +0530
Message-ID: <1519138681-1982-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155846_701027_6430CE2A)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 64a2060..8ec33b3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2162,8 +2162,7 @@ static void handle_del_all_sta(struct wilc_vif *vif,
 	complete(&hif_wait_response);
 }
 
-static void handle_del_station(struct wilc_vif *vif,
-			       struct del_sta *pstrDelStaParam)
+static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2179,7 +2178,7 @@ static void handle_del_station(struct wilc_vif *vif,
 
 	cur_byte = wid.val;
 
-	ether_addr_copy(cur_byte, pstrDelStaParam->mac_addr);
+	ether_addr_copy(cur_byte, param->mac_addr);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-- 
2.7.4
