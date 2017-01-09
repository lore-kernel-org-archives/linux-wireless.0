Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:42212 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752305AbdAIGMi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 01:12:38 -0500
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ganesh Krishna <ganesh.krishna@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2] staging: wilc1000: Connect to highest RSSI value for required SSID
Date: Mon, 9 Jan 2017 11:42:15 +0530
Message-ID: <1483942335-7957-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170109_071308_936448_CF482B2B)
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

changes in v2:
initialize sel_bssi_idx to UINT_MAX.
Combine two checks for identifying
sel_bssi_idx value for a SSID.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c1a24f7..507bdf7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -665,6 +665,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = 0;
 	u32 i;
+	u32 sel_bssi_idx = UINT_MAX;
 	u8 u8security = NO_ENCRYPT;
 	enum AUTHTYPE tenuAuth_type = ANY;
 
@@ -688,18 +689,24 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
-			if (!sme->bssid)
-				break;
-			else
+			if (!sme->bssid) {
+				if (sel_bssi_idx == UINT_MAX ||
+				    last_scanned_shadow[i].rssi >
+				    last_scanned_shadow[sel_bssi_idx].rssi)
+					sel_bssi_idx = i;
+			} else {
 				if (memcmp(last_scanned_shadow[i].bssid,
 					   sme->bssid,
-					   ETH_ALEN) == 0)
+					   ETH_ALEN) == 0) {
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
