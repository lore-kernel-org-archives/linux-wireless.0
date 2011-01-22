Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54759 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1AVAMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:12:43 -0500
Received: by ewy5 with SMTP id 5so1227954ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 16:12:42 -0800 (PST)
From: Paul Fertser <fercerpav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "Thomas d'Otreppe" <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>
Subject: [RFC][PATCH] cfg80211: report monitor interface channel via wext when possible
Date: Sat, 22 Jan 2011 03:11:38 +0300
Message-Id: <1295655098-17534-1-git-send-email-fercerpav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to retrieve the channel for the monitor interface
in cases when it can be determined unambigously. Tested with ath5k.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 net/wireless/chan.c        |    5 +++--
 net/wireless/wext-compat.c |   12 ++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..869e764 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -81,6 +81,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *chan;
+	struct wireless_dev *passed_wdev = wdev;
 	int result;
 
 	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
@@ -128,8 +129,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	if (result)
 		return result;
 
-	if (wdev)
-		wdev->channel = chan;
+	if (passed_wdev)
+		passed_wdev->channel = chan;
 
 	return 0;
 }
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 3e5dbd4..aa637e6 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -819,6 +819,8 @@ int cfg80211_wext_giwfreq(struct net_device *dev,
 			  struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	int result;
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -828,6 +830,16 @@ int cfg80211_wext_giwfreq(struct net_device *dev,
 	default:
 		if (!wdev->channel)
 			return -EINVAL;
+		/* The actual working channel might have been changed, verify it
+		 * by re-setting pretending we want to set channel for a monitor
+		 * interface */
+		result = rdev->ops->set_channel(&rdev->wiphy, NULL,
+						wdev->channel,
+						NL80211_CHAN_NO_HT);
+		if (result) {
+			wdev->channel = NULL;
+			return -EINVAL;
+		}
 		freq->m = wdev->channel->center_freq;
 		freq->e = 6;
 		return 0;
-- 
1.7.2.2

