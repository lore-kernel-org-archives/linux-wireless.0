Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:62621 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbeCHPK4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:56 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/10] staging: wilc1000: rename CfgScanResult to avoid camelCase
Date: Wed, 7 Mar 2018 07:02:23 +0530
Message-ID: <1520386350-31607-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161059_122935_3693BDEB)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2fda90d..051ba12 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -363,10 +363,9 @@ static void add_network_to_shadow(struct network_info *nw_info,
 	last_scanned_shadow[ap_index].join_params = pJoinParams;
 }
 
-static void CfgScanResult(enum scan_event scan_event,
-			  struct network_info *network_info,
-			  void *user_void,
-			  void *join_params)
+static void cfg_scan_result(enum scan_event scan_event,
+			    struct network_info *network_info,
+			    void *user_void, void *join_params)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -622,14 +621,14 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 					au8ScanChanList,
 					request->n_channels,
 					(const u8 *)request->ie,
-					request->ie_len, CfgScanResult,
+					request->ie_len, cfg_scan_result,
 					(void *)priv, &hidden_ntwk);
 		} else {
 			ret = wilc_scan(vif, USER_SCAN, ACTIVE_SCAN,
 					au8ScanChanList,
 					request->n_channels,
 					(const u8 *)request->ie,
-					request->ie_len, CfgScanResult,
+					request->ie_len, cfg_scan_result,
 					(void *)priv, NULL);
 		}
 	} else {
-- 
2.7.4
