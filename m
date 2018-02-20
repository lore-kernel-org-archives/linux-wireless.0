Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbeBTO6d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:33 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/12] staging: wilc1000: rename pstrStatistics to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:56 +0530
Message-ID: <1519138681-1982-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155843_814256_0A938BBF)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid caseCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9eb808e..593f7f1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1889,7 +1889,7 @@ static void handle_get_rssi(struct wilc_vif *vif)
 }
 
 static s32 handle_get_statistics(struct wilc_vif *vif,
-				 struct rf_info *pstrStatistics)
+				 struct rf_info *stats)
 {
 	struct wid wid_list[5];
 	u32 wid_cnt = 0, result = 0;
@@ -1897,31 +1897,31 @@ static s32 handle_get_statistics(struct wilc_vif *vif,
 	wid_list[wid_cnt].id = WID_LINKSPEED;
 	wid_list[wid_cnt].type = WID_CHAR;
 	wid_list[wid_cnt].size = sizeof(char);
-	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->link_speed;
+	wid_list[wid_cnt].val = (s8 *)&stats->link_speed;
 	wid_cnt++;
 
 	wid_list[wid_cnt].id = WID_RSSI;
 	wid_list[wid_cnt].type = WID_CHAR;
 	wid_list[wid_cnt].size = sizeof(char);
-	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->rssi;
+	wid_list[wid_cnt].val = (s8 *)&stats->rssi;
 	wid_cnt++;
 
 	wid_list[wid_cnt].id = WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type = WID_INT;
 	wid_list[wid_cnt].size = sizeof(u32);
-	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->tx_cnt;
+	wid_list[wid_cnt].val = (s8 *)&stats->tx_cnt;
 	wid_cnt++;
 
 	wid_list[wid_cnt].id = WID_RECEIVED_FRAGMENT_COUNT;
 	wid_list[wid_cnt].type = WID_INT;
 	wid_list[wid_cnt].size = sizeof(u32);
-	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->rx_cnt;
+	wid_list[wid_cnt].val = (s8 *)&stats->rx_cnt;
 	wid_cnt++;
 
 	wid_list[wid_cnt].id = WID_FAILED_COUNT;
 	wid_list[wid_cnt].type = WID_INT;
 	wid_list[wid_cnt].size = sizeof(u32);
-	wid_list[wid_cnt].val = (s8 *)&pstrStatistics->tx_fail_cnt;
+	wid_list[wid_cnt].val = (s8 *)&stats->tx_fail_cnt;
 	wid_cnt++;
 
 	result = wilc_send_config_pkt(vif, GET_CFG, wid_list,
@@ -1931,13 +1931,13 @@ static s32 handle_get_statistics(struct wilc_vif *vif,
 	if (result)
 		netdev_err(vif->ndev, "Failed to send scan parameters\n");
 
-	if (pstrStatistics->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
-	    pstrStatistics->link_speed != DEFAULT_LINK_SPEED)
+	if (stats->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
+	    stats->link_speed != DEFAULT_LINK_SPEED)
 		wilc_enable_tcp_ack_filter(true);
-	else if (pstrStatistics->link_speed != DEFAULT_LINK_SPEED)
+	else if (stats->link_speed != DEFAULT_LINK_SPEED)
 		wilc_enable_tcp_ack_filter(false);
 
-	if (pstrStatistics != &vif->wilc->dummy_statistics)
+	if (stats != &vif->wilc->dummy_statistics)
 		complete(&hif_wait_response);
 	return 0;
 }
-- 
2.7.4
