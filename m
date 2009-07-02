Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZGBTgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 15:36:35 -0400
Subject: [PATCH v2] nl80211: limit to one pairwise cipher for associate()
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1246563276.16770.48.camel@johannes.local>
References: <1246563276.16770.48.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 21:36:37 +0200
Message-Id: <1246563397.16770.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this case, only one cipher makes sense, unlike for
connect() where it may be possible to have the card or
driver select.

No changes to mac80211 due to the way the structs are
laid out -- but the loop in net/mac80211/cfg.c will
degrade to just zero or one passes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sorry, based on wrong patch.

 net/wireless/nl80211.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-02 21:34:53.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-02 21:34:53.000000000 +0200
@@ -3118,7 +3118,8 @@ unlock_rtnl:
 }
 
 static int nl80211_crypto_settings(struct genl_info *info,
-				   struct cfg80211_crypto_settings *settings)
+				   struct cfg80211_crypto_settings *settings,
+				   int cipher_limit)
 {
 	settings->control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
 
@@ -3133,7 +3134,7 @@ static int nl80211_crypto_settings(struc
 		if (len % sizeof(u32))
 			return -EINVAL;
 
-		if (settings->n_ciphers_pairwise > NL80211_MAX_NR_CIPHER_SUITES)
+		if (settings->n_ciphers_pairwise > cipher_limit)
 			return -EINVAL;
 
 		memcpy(settings->ciphers_pairwise, data, len);
@@ -3246,7 +3247,7 @@ static int nl80211_associate(struct sk_b
 		}
 	}
 
-	err = nl80211_crypto_settings(info, &crypto);
+	err = nl80211_crypto_settings(info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, ssid,
 					  ssid_len, ie, ie_len, use_mfp,
@@ -3651,7 +3652,8 @@ static int nl80211_connect(struct sk_buf
 
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
-	err = nl80211_crypto_settings(info, &connect.crypto);
+	err = nl80211_crypto_settings(info, &connect.crypto,
+				      NL80211_MAX_NR_CIPHER_SUITES);
 	if (err)
 		return err;
 	rtnl_lock();


