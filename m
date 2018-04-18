Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbeDRLkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/22] staging: wilc1000: remove inner block {} and resetting of mode variable
Date: Wed, 18 Apr 2018 17:09:06 +0530
Message-ID: <1524051564-15497-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134035_914126_17E96542)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup fixes to remove the uncessary inner block { /* */ } and setting
of 'mode' variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 43 +++++++++++------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0c7bf2b..ac4cd58 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1009,31 +1009,28 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			break;
 		}
 
-		{
-			mode = 0;
-			if (!pairwise) {
-				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					rx_mic = params->key + 24;
-					tx_mic = params->key + 16;
-					keylen = params->key_len - 16;
-				}
-
-				wilc_add_rx_gtk(vif, params->key, keylen,
-						key_index, params->seq_len,
-						params->seq, rx_mic,
-						tx_mic, STATION_MODE,
-						mode);
-			} else {
-				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					rx_mic = params->key + 24;
-					tx_mic = params->key + 16;
-					keylen = params->key_len - 16;
-				}
+		if (!pairwise) {
+			if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
+				rx_mic = params->key + 24;
+				tx_mic = params->key + 16;
+				keylen = params->key_len - 16;
+			}
 
-				wilc_add_ptk(vif, params->key, keylen,
-					     mac_addr, rx_mic, tx_mic,
-					     STATION_MODE, mode, key_index);
+			wilc_add_rx_gtk(vif, params->key, keylen,
+					key_index, params->seq_len,
+					params->seq, rx_mic,
+					tx_mic, STATION_MODE,
+					mode);
+		} else {
+			if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
+				rx_mic = params->key + 24;
+				tx_mic = params->key + 16;
+				keylen = params->key_len - 16;
 			}
+
+			wilc_add_ptk(vif, params->key, keylen,
+				     mac_addr, rx_mic, tx_mic,
+				     STATION_MODE, mode, key_index);
 		}
 		break;
 
-- 
2.7.4
