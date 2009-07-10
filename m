Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZGJQfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:35:53 -0400
Subject: [PATCH] cfg80211: fix wext setting SSID
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 18:35:49 +0200
Message-Id: <1247243749.29747.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel reported that you can't set the SSID from "foo" to
"bar". I tried reproducing, but used different values,
with different lengths, and thus never saw the obvious
problem.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
*sigh*
tons of stupid mistakes

 net/wireless/wext-sme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-10 18:33:59.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-10 18:34:08.000000000 +0200
@@ -166,7 +166,7 @@ int cfg80211_mgd_wext_siwessid(struct ne
 
 	if (wdev->wext.connect.ssid && len &&
 	    len == wdev->wext.connect.ssid_len &&
-	    memcmp(wdev->wext.connect.ssid, ssid, len))
+	    memcmp(wdev->wext.connect.ssid, ssid, len) == 0)
 		goto out;
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {


