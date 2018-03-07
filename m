Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:63422 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeCHPwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:17 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/10] staging: wilc1000: fix line over 80 char in handle_scan()
Date: Wed, 7 Mar 2018 07:43:53 +0530
Message-ID: <1520388839-7048-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165219_988929_A42739E5)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issue reported by checkpatch.pl script in
handle_scan().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d0c17cd..a218497 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -771,6 +771,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	u8 valuesize = 0;
 	u8 *hdn_ntwk_wid_val = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct hidden_network *hidden_net = &scan_info->hidden_network;
 
 	hif_drv->usr_scan_req.scan_result = scan_info->result;
 	hif_drv->usr_scan_req.arg = scan_info->arg;
@@ -793,19 +794,20 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	wid_list[index].id = (u16)WID_SSID_PROBE_REQ;
 	wid_list[index].type = WID_STR;
 
-	for (i = 0; i < scan_info->hidden_network.n_ssids; i++)
-		valuesize += ((scan_info->hidden_network.net_info[i].ssid_len) + 1);
+	for (i = 0; i < hidden_net->n_ssids; i++)
+		valuesize += ((hidden_net->net_info[i].ssid_len) + 1);
 	hdn_ntwk_wid_val = kmalloc(valuesize + 1, GFP_KERNEL);
 	wid_list[index].val = hdn_ntwk_wid_val;
 	if (wid_list[index].val) {
 		buffer = wid_list[index].val;
 
-		*buffer++ = scan_info->hidden_network.n_ssids;
+		*buffer++ = hidden_net->n_ssids;
 
-		for (i = 0; i < scan_info->hidden_network.n_ssids; i++) {
-			*buffer++ = scan_info->hidden_network.net_info[i].ssid_len;
-			memcpy(buffer, scan_info->hidden_network.net_info[i].ssid, scan_info->hidden_network.net_info[i].ssid_len);
-			buffer += scan_info->hidden_network.net_info[i].ssid_len;
+		for (i = 0; i < hidden_net->n_ssids; i++) {
+			*buffer++ = hidden_net->net_info[i].ssid_len;
+			memcpy(buffer, hidden_net->net_info[i].ssid,
+			       hidden_net->net_info[i].ssid_len);
+			buffer += hidden_net->net_info[i].ssid_len;
 		}
 
 		wid_list[index].size = (s32)(valuesize + 1);
@@ -833,7 +835,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 
 		for (i = 0; i < scan_info->ch_list_len; i++)	{
 			if (scan_info->ch_freq_list[i] > 0)
-				scan_info->ch_freq_list[i] = scan_info->ch_freq_list[i] - 1;
+				scan_info->ch_freq_list[i] -= 1;
 		}
 	}
 
-- 
2.7.4
