Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:56579 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934950AbeCHPK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:59 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/10] staging: wilc1000: rename au8ScanChanList to avoid camelCase
Date: Wed, 7 Mar 2018 07:02:24 +0530
Message-ID: <1520386350-31607-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161129_122220_009AD9FE)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 051ba12..1f6c02a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -581,7 +581,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	struct wilc_priv *priv;
 	u32 i;
 	s32 ret = 0;
-	u8 au8ScanChanList[MAX_NUM_SCANNED_NETWORKS];
+	u8 scan_ch_list[MAX_NUM_SCANNED_NETWORKS];
 	struct hidden_network hidden_ntwk;
 	struct wilc_vif *vif;
 
@@ -597,7 +597,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	priv->cfg_scanning = true;
 	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
 		for (i = 0; i < request->n_channels; i++)
-			au8ScanChanList[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
+			scan_ch_list[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
 
 		if (request->n_ssids >= 1) {
 			hidden_ntwk.net_info =
@@ -618,14 +618,14 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				}
 			}
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
-					au8ScanChanList,
+					scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
 					(void *)priv, &hidden_ntwk);
 		} else {
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
-					au8ScanChanList,
+					scan_ch_list,
 					request->n_channels,
 					(const u8 *)request->ie,
 					request->ie_len, cfg_scan_result,
-- 
2.7.4
