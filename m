Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYBTSbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:31:33 -0500
Subject: [PATCH] rndis_wlan: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 11:47:45 +0100
Message-Id: <1203504466.17534.16.camel@johannes.berg> (sfid-20080220_183136_454133_EFF98469)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is obviously wrong to use an enum in a little endian struct,
and those other enums should be declared differently.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/rndis_wlan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:43:22.000000000 +0100
+++ everything/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:45:35.000000000 +0100
@@ -228,9 +228,9 @@ struct NDIS_WLAN_BSSID_EX {
 	struct NDIS_802_11_SSID Ssid;
 	__le32 Privacy;
 	__le32 Rssi;
-	enum NDIS_802_11_NETWORK_TYPE NetworkTypeInUse;
+	__le32 NetworkTypeInUse;
 	struct NDIS_802_11_CONFIGURATION Configuration;
-	enum NDIS_802_11_NETWORK_INFRASTRUCTURE InfrastructureMode;
+	__le32 InfrastructureMode;
 	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
 	__le32 IELength;
 	u8 IEs[0];
@@ -279,11 +279,11 @@ struct RNDIS_CONFIG_PARAMETER_INFOBUFFER
 } __attribute__((packed));
 
 /* these have to match what is in wpa_supplicant */
-enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP, CIPHER_WEP104 }
-	wpa_cipher;
-enum { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE, KEY_MGMT_802_1X_NO_WPA,
-	KEY_MGMT_WPA_NONE } wpa_key_mgmt;
+enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
+enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
+		  CIPHER_WEP104 };
+enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
+		    KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE };
 
 /*
  *  private data


