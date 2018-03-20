Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:4575 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbeCTQz5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:55:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/11] staging: wilc1000: refactor scan() to free kmalloc memory on failure cases
Date: Tue, 20 Mar 2018 22:25:34 +0530
Message-ID: <1521564944-3565-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175600_848817_9AE996BF)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added changes to free the allocated memory in scan() for error condition.
Also added 'NULL' check validation before accessing allocated memory.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 62 +++++++++++++++++------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9d8d5d0..b784e15 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -582,6 +582,49 @@ static int set_channel(struct wiphy *wiphy,
 	return result;
 }
 
+static inline bool
+wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
+			     struct hidden_network *ntwk)
+{
+	int i = 0;
+
+	ntwk->net_info = kcalloc(request->n_ssids,
+				 sizeof(struct hidden_network), GFP_KERNEL);
+
+	if (!ntwk->net_info)
+		goto out;
+
+	ntwk->n_ssids = request->n_ssids;
+
+	for (i = 0; i < request->n_ssids; i++) {
+		if (request->ssids[i].ssid_len > 0) {
+			struct hidden_net_info *info = &ntwk->net_info[i];
+
+			info->ssid = kmemdup(request->ssids[i].ssid,
+					     request->ssids[i].ssid_len,
+					     GFP_KERNEL);
+
+			if (!info->ssid)
+				goto out_free;
+
+			info->ssid_len = request->ssids[i].ssid_len;
+		} else {
+			ntwk->n_ssids -= 1;
+		}
+	}
+	return true;
+
+out_free:
+
+	for (; i >= 0 ; i--)
+		kfree(ntwk->net_info[i].ssid);
+
+	kfree(ntwk->net_info);
+out:
+
+	return false;
+}
+
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
@@ -606,23 +649,10 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 			scan_ch_list[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
 
 		if (request->n_ssids >= 1) {
-			hidden_ntwk.net_info =
-				kmalloc_array(request->n_ssids,
-					      sizeof(struct hidden_network),
-					      GFP_KERNEL);
-			if (!hidden_ntwk.net_info)
+			if (!wilc_wfi_cfg_alloc_fill_ssid(request,
+							  &hidden_ntwk))
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
