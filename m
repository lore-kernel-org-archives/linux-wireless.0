Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:33435 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbcKQJKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 04:10:35 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/2] cfg80211: get rid of name indirection trick for ieee80211_get_channel()
Date: Thu, 17 Nov 2016 09:02:39 +0000
Message-Id: <1479373360-1398-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_101042_064916_9227AC26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment on the name indirection suggested an issue but turned out
to be untrue. Digging in older kernel version showed issue with ipw2x00
but that is no longer true so get rid on the name indirection.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h | 17 +++--------------
 net/wireless/util.c    |  5 ++---
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2019310..ef42749 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3955,26 +3955,15 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
  */
 int ieee80211_frequency_to_channel(int freq);
 
-/*
- * Name indirection necessary because the ieee80211 code also has
- * a function named "ieee80211_get_channel", so if you include
- * cfg80211's header file you get cfg80211's version, if you try
- * to include both header files you'll (rightfully!) get a symbol
- * clash.
- */
-struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
-						  int freq);
 /**
  * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ *
  * @wiphy: the struct wiphy to get the channel for
  * @freq: the center frequency of the channel
+ *
  * Return: The channel struct from @wiphy at @freq.
  */
-static inline struct ieee80211_channel *
-ieee80211_get_channel(struct wiphy *wiphy, int freq)
-{
-	return __ieee80211_get_channel(wiphy, freq);
-}
+struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq);
 
 /**
  * ieee80211_get_response_rate - get basic rate for a given rate
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 88725f8..f717694 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -114,8 +114,7 @@ int ieee80211_frequency_to_channel(int freq)
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
-struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
-						  int freq)
+struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq)
 {
 	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -135,7 +134,7 @@ struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 
 	return NULL;
 }
-EXPORT_SYMBOL(__ieee80211_get_channel);
+EXPORT_SYMBOL(ieee80211_get_channel);
 
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				     enum nl80211_band band)
-- 
1.9.1
