Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbeBSPaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:14 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/14] staging: wilc1000: rename strHostIfSetMulti to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:32 +0530
Message-ID: <1519054184-14301-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163018_665586_81EB1452)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3dc3d2e..edd35b7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2406,7 +2406,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 }
 
 static void Handle_SetMulticastFilter(struct wilc_vif *vif,
-				      struct set_multicast *strHostIfSetMulti)
+				      struct set_multicast *hif_set_mc)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2414,25 +2414,25 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 
 	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	wid.type = WID_BIN;
-	wid.size = sizeof(struct set_multicast) + (strHostIfSetMulti->cnt * ETH_ALEN);
+	wid.size = sizeof(struct set_multicast) + (hif_set_mc->cnt * ETH_ALEN);
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
 
 	cur_byte = wid.val;
-	*cur_byte++ = (strHostIfSetMulti->enabled & 0xFF);
+	*cur_byte++ = (hif_set_mc->enabled & 0xFF);
 	*cur_byte++ = 0;
 	*cur_byte++ = 0;
 	*cur_byte++ = 0;
 
-	*cur_byte++ = (strHostIfSetMulti->cnt & 0xFF);
-	*cur_byte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-	*cur_byte++ = ((strHostIfSetMulti->cnt >> 16) & 0xFF);
-	*cur_byte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
+	*cur_byte++ = (hif_set_mc->cnt & 0xFF);
+	*cur_byte++ = ((hif_set_mc->cnt >> 8) & 0xFF);
+	*cur_byte++ = ((hif_set_mc->cnt >> 16) & 0xFF);
+	*cur_byte++ = ((hif_set_mc->cnt >> 24) & 0xFF);
 
-	if ((strHostIfSetMulti->cnt) > 0)
+	if ((hif_set_mc->cnt) > 0)
 		memcpy(cur_byte, wilc_multicast_mac_addr_list,
-		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
+		       ((hif_set_mc->cnt) * ETH_ALEN));
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-- 
2.7.4
