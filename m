Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:37639 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3IZQDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 12:03:33 -0400
From: Bruno Randolf <br1@einfach.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Bruno Randolf <br1@einfach.org>
Subject: [PATCH] cfg80211: fix warning when using WEXT for IBSS
Date: Thu, 26 Sep 2013 16:55:28 +0100
Message-Id: <1380210928-6604-1-git-send-email-br1@einfach.org> (sfid-20130926_180352_931750_6EA1486F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix kernel warning when using WEXT for configuring ad-hoc mode,
e.g.  "iwconfig wlan0 essid test channel 1"

[ 1003.460000] WARNING: at net/wireless/chan.c:373
cfg80211_chandef_usable+0x50/0x21c [cfg80211]()

The warning is caused by an uninitialized variable center_freq1.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/wireless/ibss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 39bff7d..a096e2c 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -263,6 +263,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
 				wdev->wext.ibss.chandef.chan = chan;
+				wdev->wext.ibss.chandef.center_freq1 = chan->center_freq;
 				break;
 			}
 
@@ -347,6 +348,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 	if (chan) {
 		wdev->wext.ibss.chandef.chan = chan;
 		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		wdev->wext.ibss.chandef.center_freq1 = freq;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
-- 
1.8.1.2

