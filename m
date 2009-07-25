Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZGYOyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 10:54:41 -0400
Subject: [PATCH] nl80211: add missing parameter clearing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 16:54:36 +0200
Message-Id: <1248533676.19945.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni and Maxim reported an oops when using wpa_supplicant -Dnl80211,
which seems to be due to random data being contained in the crypto
settings for the assoc() command. This seems to be due to the missing
memset here, so add it -- it's certainly missing but I'm not 100%
certain that it will fix the problem.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-25 16:50:39.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-25 16:51:00.000000000 +0200
@@ -3385,6 +3385,8 @@ static int nl80211_crypto_settings(struc
 				   struct cfg80211_crypto_settings *settings,
 				   int cipher_limit)
 {
+	memset(settings, 0, sizeof(*settings));
+
 	settings->control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
 
 	if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {


