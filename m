Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46349 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZARBYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 20:24:19 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix slot time debug message
Date: Sun, 18 Jan 2009 02:24:15 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901180224.16315.chunkeey@web.de> (sfid-20090118_022425_115947_5E34A848)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlan0: switched to short barker preamble (BSSID=00:01:aa:bb:cc:dd)
wlan0: switched to short slot (BSSID=) <something is missing here>

should be:

wlan0: switched to short barker preamble (BSSID=00:01:aa:bb:cc:dd)
wlan0: switched to short slot (BSSID=00:01:aa:bb:cc:dd)

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81c5cff..43da622 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -687,8 +687,8 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	if (use_short_slot != bss_conf->use_short_slot) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: switched to %s slot"
-			       " (BSSID=%s)\n",
+			printk(KERN_DEBUG "%s: switched to %s slot time"
+			       " (BSSID=%pM)\n",
 			       sdata->dev->name,
 			       use_short_slot ? "short" : "long",
 			       ifsta->bssid);
