Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57009 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaCHDCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:02:37 -0500
Received: by mail-pd0-f177.google.com with SMTP id g10so4806376pdj.36
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 19:02:37 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: make __cfg80211_join_ibss() static
Date: Sat,  8 Mar 2014 11:01:24 +0800
Message-Id: <0962cca52541e7067f7c001046fd6d36e7a76640.1394247591.git.gamerh2o@gmail.com> (sfid-20140308_040300_375074_18D0DBEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function __cfg80211_join_ibss() is only used in net/wireless/ibss.c,
so make it static.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/core.h | 4 ----
 net/wireless/ibss.c | 8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 4068300..766aabc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -246,10 +246,6 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
                       unsigned long age_secs);
 
 /* IBSS */
-int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct cfg80211_ibss_params *params,
-			 struct cfg80211_cached_keys *connkeys);
 int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_ibss_params *params,
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 349db9d..a6b5bda 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -82,10 +82,10 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 }
 EXPORT_SYMBOL(cfg80211_ibss_joined);
 
-int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct cfg80211_ibss_params *params,
-			 struct cfg80211_cached_keys *connkeys)
+static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+				struct net_device *dev,
+				struct cfg80211_ibss_params *params,
+				struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_channel *check_chan;
-- 
1.8.5.3

