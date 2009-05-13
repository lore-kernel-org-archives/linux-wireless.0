Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314AbZEMKLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 06:11:04 -0400
Subject: [PATCH v2] cfg80211: fix a couple of bugs with key ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
In-Reply-To: <1242125077.4331.0.camel@johannes.local>
References: <1242125077.4331.0.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 13 May 2009 12:10:33 +0200
Message-Id: <1242209433.29288.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few small bugs/oversights in the key handling
code I wrote:
 * SIOCSIWENCODE should default to setting key 0 if no
   default key is set already and no index is given,
 * key removal should not require key material,
 * SIOCSIWENCODEEXT should default to changing the default
   management key if no index is given.
 * SIOCSIWENCODEEXT needs to use ext->key_len rather than
   erq->length to verify the key length

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-12 12:38:41.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-05-13 12:09:13.000000000 +0200
@@ -557,7 +557,7 @@ int cfg80211_wext_siwencode(struct net_d
 	if (idx == 0) {
 		idx = wdev->wext.default_key;
 		if (idx < 0)
-			return -EINVAL;
+			idx = 0;
 	} else if (idx < 1 || idx > 4)
 		return -EINVAL;
 	else
@@ -580,7 +580,7 @@ int cfg80211_wext_siwencode(struct net_d
 		params.cipher = WLAN_CIPHER_SUITE_WEP40;
 	else if (erq->length == 13)
 		params.cipher = WLAN_CIPHER_SUITE_WEP104;
-	else
+	else if (!remove)
 		return -EINVAL;
 
 	return cfg80211_set_encryption(rdev, dev, NULL, remove,
@@ -614,9 +614,9 @@ int cfg80211_wext_siwencodeext(struct ne
 		cipher = 0;
 		break;
 	case IW_ENCODE_ALG_WEP:
-		if (erq->length == 5)
+		if (ext->key_len == 5)
 			cipher = WLAN_CIPHER_SUITE_WEP40;
-		else if (erq->length == 13)
+		else if (ext->key_len == 13)
 			cipher = WLAN_CIPHER_SUITE_WEP104;
 		else
 			return -EINVAL;
@@ -640,13 +640,9 @@ int cfg80211_wext_siwencodeext(struct ne
 	idx = erq->flags & IW_ENCODE_INDEX;
 	if (cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
 		if (idx < 4 || idx > 5) {
-			/*
-			 * XXX: Only wpa_supplicant ever used this
-			 *	can we still change the ABI a little
-			 *	so we do not need to keep track of
-			 *	the default key?
-			 */
-			return -EINVAL;
+			idx = wdev->wext.default_mgmt_key;
+			if (idx < 0)
+				return -EINVAL;
 		} else
 			idx--;
 	} else {


