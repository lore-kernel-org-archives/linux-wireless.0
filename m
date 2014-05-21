Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49172 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaEUUKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:10:42 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so3296004wiw.16
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:10:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6656: iowpa.h removed dead code.
Date: Wed, 21 May 2014 21:09:40 +0100
Message-Id: <1400702984-3221-2-git-send-email-tvboxspy@gmail.com> (sfid-20140521_221045_643809_9779BFF3)
In-Reply-To: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
References: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead strutures

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iowpa.h | 53 ------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/staging/vt6656/iowpa.h b/drivers/staging/vt6656/iowpa.h
index 97af32e..98f2b21 100644
--- a/drivers/staging/vt6656/iowpa.h
+++ b/drivers/staging/vt6656/iowpa.h
@@ -31,43 +31,6 @@
 
 #define WPA_IE_LEN 64
 
-//WPA related
-/*
-typedef enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-typedef enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-	       CIPHER_WEP104 } wpa_cipher;
-typedef enum { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
-	       KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE } wpa_key_mgmt;
-*/
-
-enum {
-	VIAWGET_SET_WPA = 1,
-	VIAWGET_SET_KEY = 2,
-	VIAWGET_SET_SCAN = 3,
-	VIAWGET_GET_SCAN = 4,
-	VIAWGET_GET_SSID = 5,
-	VIAWGET_GET_BSSID = 6,
-	VIAWGET_SET_DROP_UNENCRYPT = 7,
-	VIAWGET_SET_DEAUTHENTICATE = 8,
-	VIAWGET_SET_ASSOCIATE = 9,
-	VIAWGET_SET_DISASSOCIATE = 10
-};
-
-enum {
-	VIAWGET_ASSOC_MSG = 1,
-	VIAWGET_DISASSOC_MSG = 2,
-	VIAWGET_PTK_MIC_MSG = 3,
-	VIAWGET_GTK_MIC_MSG = 4,
-	VIAWGET_CCKM_ROAM_MSG = 5,
-	VIAWGET_DEVICECLOSE_MSG = 6
-};
-
-typedef struct viawget_wpa_header {
-	u8 type;
-	u16 req_ie_len;
-	u16 resp_ie_len;
-} __packed viawget_wpa_header;
-
 struct viawget_wpa_param {
 	u32 cmd;
 	u8 addr[6];
@@ -109,20 +72,4 @@ struct viawget_wpa_param {
 	} u;
 } __packed;
 
-struct viawget_scan_result {
-	u8 bssid[6];
-	u8 ssid[32];
-	u16 ssid_len;
-	u8 wpa_ie[WPA_IE_LEN];
-	u16 wpa_ie_len;
-	u8 rsn_ie[WPA_IE_LEN];
-	u16 rsn_ie_len;
-	int freq; // MHz
-	int caps; // e.g. privacy
-	int qual; // signal quality
-	int noise;
-	int level;
-	int maxrate;
-} __packed;
-
 #endif /* __IOWPA_H__ */
-- 
1.9.1

