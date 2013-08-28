Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:37736 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3H1Llm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 07:41:42 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 1/6] cfg80211: export cfg80211_chandef_dfs_required
Date: Wed, 28 Aug 2013 13:41:28 +0200
Message-Id: <1377690093-27024-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130828_134152_423642_2AB19F20)
In-Reply-To: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1377690093-27024-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will be used later by the IBSS CSA implementation of mac80211.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCHv1:
 * remove one more newline in net/wireless/core.h
---
 include/net/cfg80211.h |    9 +++++++++
 net/wireless/chan.c    |    1 +
 net/wireless/core.h    |    9 ---------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d530c54..47fdb1d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -437,6 +437,15 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
 /**
+ * cfg80211_chandef_dfs_required - checks if radar detection is required
+ * @wiphy: the wiphy to validate against
+ * @chandef: the channel definition to check
+ * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
+ */
+int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
+				  const struct cfg80211_chan_def *c);
+
+/**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
  *
  * In some channel types, not all rates may be used - for example CCK
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 50f6195..16f3c3a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -328,6 +328,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
 					       width);
 }
+EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
 
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9ad43c6..b43efac 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -382,15 +382,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum cfg80211_chan_mode chanmode,
 				 u8 radar_detect);
 
-/**
- * cfg80211_chandef_dfs_required - checks if radar detection is required
- * @wiphy: the wiphy to validate against
- * @chandef: the channel definition to check
- * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
- */
-int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *c);
-
 void cfg80211_set_dfs_state(struct wiphy *wiphy,
 			    const struct cfg80211_chan_def *chandef,
 			    enum nl80211_dfs_state dfs_state);
-- 
1.7.10.4

