Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZELKpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 06:45:10 -0400
Subject: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 12:44:37 +0200
Message-Id: <1242125077.4331.0.camel@johannes.local>
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

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-12 12:38:41.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-05-12 12:38:59.000000000 +0200
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


