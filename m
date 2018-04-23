Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12878 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbeDWQew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:34:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 01/33] staging: wilc1000: refactor scan() to free kmalloc memory on failure cases
Date: Mon, 23 Apr 2018 22:03:03 +0530
Message-ID: <1524501215-4963-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183458_216730_5F5E6547)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added changes to free the allocated memory in scan() for error condition.
Also added 'NULL' check validation before accessing allocated memory.
Copied the SSID information in consecutive slots to avoid inbetween
holes while filling into array.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 62 +++++++++++++++++------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 706ba4c..f9a95f2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -581,6 +581,49 @@ static int set_channel(struct wiphy *wiphy,
 	return result;
 }
 
+static inline int
+wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
+			     struct hidden_network *ntwk)
+{
+	int i;
+	int slot_id = 0;
+
+	ntwk->net_info = kcalloc(request->n_ssids,
+				 sizeof(struct hidden_network), GFP_KERNEL);
+	if (!ntwk->net_info)
+		goto out;
+
+	ntwk->n_ssids = request->n_ssids;
+
+	for (i = 0; i < request->n_ssids; i++) {
+		if (request->ssids[i].ssid_len > 0) {
+			struct hidden_net_info *info = &ntwk->net_info[slot_id];
+
+			info->ssid = kmemdup(request->ssids[i].ssid,
+					     request->ssids[i].ssid_len,
+					     GFP_KERNEL);
+			if (!info->ssid)
+				goto out_free;
+
+			info->ssid_len = request->ssids[i].ssid_len;
+			slot_id++;
+		} else {
+			ntwk->n_ssids -= 1;
+		}
+	}
+	return 0;
+
+out_free:
+
+	for (i = 0; i < slot_id ; i--)
+		kfree(ntwk->net_info[i].ssid);
+
+	kfree(ntwk->net_info);
+out:
+
+	return -ENOMEM;
+}
+
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
@@ -605,23 +648,10 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			scan_ch_list[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
 
 		if (request->n_ssids >= 1) {
-			hidden_ntwk.net_info =
-				kmalloc_array(request->n_ssids,
-					      sizeof(struct hidden_network),
-					      GFP_KERNEL);
-			if (!hidden_ntwk.net_info)
+			if (wilc_wfi_cfg_alloc_fill_ssid(request,
+							 &hidden_ntwk))
 				return -ENOMEM;
-			hidden_ntwk.n_ssids = request->n_ssids;
-
-			for (i = 0; i < request->n_ssids; i++) {
-				if (request->ssids[i].ssid_len != 0) {
-					hidden_ntwk.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
-					memcpy(hidden_ntwk.net_info[i].ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
-					hidden_ntwk.net_info[i].ssid_len = request->ssids[i].ssid_len;
-				} else {
-					hidden_ntwk.n_ssids -= 1;
-				}
-			}
+
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					scan_ch_list,
 					request->n_channels,
-- 
2.7.4
