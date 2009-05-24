Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZEXRZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:25:19 -0400
Subject: [PATCH] cfg80211: use key size constants
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 May 2009 16:57:19 +0200
Message-Id: <1243177039.29222.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcoding the key length for validation, use the
constants Zhu Yi recently added and add one for AES_CMAC too.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |    1 +
 net/wireless/util.c       |   11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-05-24 16:53:50.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-05-24 16:54:02.000000000 +0200
@@ -1092,6 +1092,7 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_WEP104 = 13,
 	WLAN_KEY_LEN_CCMP = 16,
 	WLAN_KEY_LEN_TKIP = 32,
+	WLAN_KEY_LEN_AES_CMAC = 16,
 };
 
 /*
--- wireless-testing.orig/net/wireless/util.c	2009-05-24 16:52:57.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2009-05-24 16:53:34.000000000 +0200
@@ -157,26 +157,25 @@ int cfg80211_validate_key_settings(struc
 	    params->cipher != WLAN_CIPHER_SUITE_WEP104)
 		return -EINVAL;
 
-	/* TODO: add definitions for the lengths to linux/ieee80211.h */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-		if (params->key_len != 5)
+		if (params->key_len != WLAN_KEY_LEN_WEP40)
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (params->key_len != 32)
+		if (params->key_len != WLAN_KEY_LEN_TKIP)
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		if (params->key_len != 16)
+		if (params->key_len != WLAN_KEY_LEN_CCMP)
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
-		if (params->key_len != 13)
+		if (params->key_len != WLAN_KEY_LEN_WEP104)
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		if (params->key_len != 16)
+		if (params->key_len != WLAN_KEY_LEN_AES_CMAC)
 			return -EINVAL;
 		break;
 	default:


