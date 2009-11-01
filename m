Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55908 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbZKAJTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 04:19:00 -0500
Date: Sun, 1 Nov 2009 11:18:49 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Fix WEXT compat siwauth wpa and group cipher
Message-ID: <20091101091849.GA32252@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither of these commands should clear the current configuration value
if they return error. Furthermore, cfg80211_set_cipher_group() should
be able to handle IW_AUTH_CIPHER_NONE without reporting error.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/wireless/wext-compat.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- uml.orig/net/wireless/wext-compat.c	2009-11-01 10:54:56.000000000 +0200
+++ uml/net/wireless/wext-compat.c	2009-11-01 10:58:45.000000000 +0200
@@ -904,8 +904,6 @@ static int cfg80211_set_auth_alg(struct 
 
 static int cfg80211_set_wpa_version(struct wireless_dev *wdev, u32 wpa_versions)
 {
-	wdev->wext.connect.crypto.wpa_versions = 0;
-
 	if (wpa_versions & ~(IW_AUTH_WPA_VERSION_WPA |
 			     IW_AUTH_WPA_VERSION_WPA2|
 		             IW_AUTH_WPA_VERSION_DISABLED))
@@ -933,8 +931,6 @@ static int cfg80211_set_wpa_version(stru
 
 static int cfg80211_set_cipher_group(struct wireless_dev *wdev, u32 cipher)
 {
-	wdev->wext.connect.crypto.cipher_group = 0;
-
 	if (cipher & IW_AUTH_CIPHER_WEP40)
 		wdev->wext.connect.crypto.cipher_group =
 			WLAN_CIPHER_SUITE_WEP40;
@@ -950,6 +946,8 @@ static int cfg80211_set_cipher_group(str
 	else if (cipher & IW_AUTH_CIPHER_AES_CMAC)
 		wdev->wext.connect.crypto.cipher_group =
 			WLAN_CIPHER_SUITE_AES_CMAC;
+	else if (cipher & IW_AUTH_CIPHER_NONE)
+		wdev->wext.connect.crypto.cipher_group = 0;
 	else
 		return -EINVAL;
 

-- 
Jouni Malinen                                            PGP id EFC895FA
