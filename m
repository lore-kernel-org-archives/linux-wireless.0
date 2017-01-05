Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:20935 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S967172AbdAEHhZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 02:37:25 -0500
From: Aditya Shankar <aditya.shankar@microchip.com>
To: Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Connect to highest RSSI value for required SSID
Date: Thu, 5 Jan 2017 13:03:41 +0530
Message-ID: <1483601621-27545-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170105_083833_883275_8C7A3D85)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Connect to the highest rssi with the required SSID in the shadow
table if the connection criteria is based only on the SSID.
For the first matching SSID, an index to the table is saved.
Later the index is updated if matching SSID has a higher
RSSI value than the last saved index.

However if decision is made based on BSSID, there is only one match
in the table and corresponding index is used.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c1a24f7..32206b8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -665,6 +665,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = 0;
 	u32 i;
+	u32 sel_bssi_idx = last_scanned_cnt + 1;
 	u8 u8security = NO_ENCRYPT;
 	enum AUTHTYPE tenuAuth_type = ANY;
 
@@ -688,18 +689,25 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
-			if (!sme->bssid)
-				break;
-			else
+			if (!sme->bssid) {
+				if (sel_bssi_idx == (last_scanned_cnt + 1))
+					sel_bssi_idx = i;
+				else if (last_scanned_shadow[i].rssi >
+					 last_scanned_shadow[sel_bssi_idx].rssi)
+					sel_bssi_idx = i;
+			} else {
 				if (memcmp(last_scanned_shadow[i].bssid,
 					   sme->bssid,
-					   ETH_ALEN) == 0)
+					   ETH_ALEN) == 0){
+					sel_bssi_idx = i;
 					break;
+				}
+			}
 		}
 	}
 
-	if (i < last_scanned_cnt) {
-		pstrNetworkInfo = &last_scanned_shadow[i];
+	if (sel_bssi_idx < last_scanned_cnt) {
+		pstrNetworkInfo = &last_scanned_shadow[sel_bssi_idx];
 	} else {
 		s32Error = -ENOENT;
 		wilc_connecting = 0;
-- 
2.7.4
