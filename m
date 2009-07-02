Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZGBTeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 15:34:37 -0400
Subject: [PATCH] nl80211: limit to one pairwise cipher for associate()
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 21:34:36 +0200
Message-Id: <1246563276.16770.48.camel@johannes.local>
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
 net/wireless/nl80211.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-02 21:30:54.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-02 21:31:55.000000000 +0200
@@ -3119,7 +3119,8 @@ unlock_rtnl:
 }
 
 static int nl80211_crypto_settings(struct genl_info *info,
-				   struct cfg80211_crypto_settings *settings)
+				   struct cfg80211_crypto_settings *settings,
+				   int cipher_limit)
 {
 	settings->control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
 
@@ -3134,7 +3135,7 @@ static int nl80211_crypto_settings(struc
 		if (len % sizeof(u32))
 			return -EINVAL;
 
-		if (settings->n_ciphers_pairwise > NL80211_MAX_NR_CIPHER_SUITES)
+		if (settings->n_ciphers_pairwise > cipher_limit)
 			return -EINVAL;
 
 		memcpy(settings->ciphers_pairwise, data, len);
@@ -3250,7 +3251,7 @@ static int nl80211_associate(struct sk_b
 	if (info->attrs[NL80211_ATTR_PREV_BSSID])
 		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
 
-	err = nl80211_crypto_settings(info, &crypto);
+	err = nl80211_crypto_settings(info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 					  ssid, ssid_len, ie, ie_len, use_mfp,
@@ -3655,7 +3656,8 @@ static int nl80211_connect(struct sk_buf
 
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
-	err = nl80211_crypto_settings(info, &connect.crypto);
+	err = nl80211_crypto_settings(info, &connect.crypto,
+				      NL80211_MAX_NR_CIPHER_SUITES);
 	if (err)
 		return err;
 	rtnl_lock();


