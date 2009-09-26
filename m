Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZIZMmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 08:42:52 -0400
Subject: [PATCH] cfg80211: always get BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Sep 2009 14:42:53 +0200
Message-Id: <1253968973.5122.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple problems were reported due to interaction
between wpa_supplicant and the wext compat code in
cfg80211, which appear to be due to it not getting
any bss pointer here when wpa_supplicant sets all
parameters -- do that now. We should still get the
bss after doing an extra scan, but that appears to
increase the time we need for connecting enough to
sometimes cause timeouts.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Hin-Tak Leung <hintak.leung@gmail.com>,
---
 net/wireless/sme.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-09-26 14:35:34.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-09-26 14:35:37.000000000 +0200
@@ -762,9 +762,8 @@ int __cfg80211_connect(struct cfg80211_r
 		wdev->conn->params.ssid = wdev->ssid;
 		wdev->conn->params.ssid_len = connect->ssid_len;
 
-		/* don't care about result -- but fill bssid & channel */
-		if (!wdev->conn->params.bssid || !wdev->conn->params.channel)
-			bss = cfg80211_get_conn_bss(wdev);
+		/* see if we have the bss already */
+		bss = cfg80211_get_conn_bss(wdev);
 
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;


