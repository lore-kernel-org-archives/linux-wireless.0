Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753134AbeBSPa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:28 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/14] staging: wilc1000: rename strHostIfStaInactiveT to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:36 +0530
Message-ID: <1519054184-14301-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163104_864875_9FB655D4)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eda395d..f685da2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1944,7 +1944,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 }
 
 static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
-				   struct sta_inactive_t *strHostIfStaInactiveT)
+				   struct sta_inactive_t *hif_sta_inactive)
 {
 	s32 result = 0;
 	u8 *stamac;
@@ -1959,7 +1959,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 		return -ENOMEM;
 
 	stamac = wid.val;
-	ether_addr_copy(stamac, strHostIfStaInactiveT->mac);
+	ether_addr_copy(stamac, hif_sta_inactive->mac);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-- 
2.7.4
