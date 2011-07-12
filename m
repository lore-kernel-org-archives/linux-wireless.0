Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:48374 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1GLHwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 03:52:13 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: libertas-dev@lists.infradead.org
Cc: daniel@zonque.org, linux-wireless@vger.kernel.org,
	Sven Neumann <s.neumann@raumfeld.com>
Subject: [PATCH] cfg80211: hold reg_mutex when updating regulatory
Date: Tue, 12 Jul 2011 09:43:59 +0200
Message-Id: <1310456639-16468-2-git-send-email-s.neumann@raumfeld.com> (sfid-20110712_095217_886820_C07255F8)
In-Reply-To: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wiphy_update_regulatory() uses the static variable
last_request and thus needs to be called with reg_mutex held.
This is the case for all users in reg.c, but the function was
exported for use by wiphy_register(), from where it is called
without the lock being held.

Fix this by making wiphy_update_regulatory() private and introducing
regulatory_update() as a wrapper that acquires and holds the lock.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
---
 net/wireless/core.c |    2 +-
 net/wireless/core.h |    2 --
 net/wireless/reg.c  |   14 ++++++++++++--
 net/wireless/reg.h  |    2 ++
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c22ef34..179921e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -577,7 +577,7 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	/* set up regulatory info */
-	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
+	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3dce1f1..0517d03 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -277,8 +277,6 @@ extern int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			       char *newname);
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
-void wiphy_update_regulatory(struct wiphy *wiphy,
-			     enum nl80211_reg_initiator setby);
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad0f39..c61fd89 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1119,11 +1119,13 @@ static void reg_process_ht_flags(struct wiphy *wiphy)
 
 }
 
-void wiphy_update_regulatory(struct wiphy *wiphy,
-			     enum nl80211_reg_initiator initiator)
+static void wiphy_update_regulatory(struct wiphy *wiphy,
+				    enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 
+	assert_reg_lock();
+
 	if (ignore_reg_update(wiphy, initiator))
 		goto out;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
@@ -1137,6 +1139,14 @@ out:
 		wiphy->reg_notifier(wiphy, last_request);
 }
 
+void regulatory_update(struct wiphy *wiphy,
+		       enum nl80211_reg_initiator setby)
+{
+	mutex_lock(&reg_mutex);
+	wiphy_update_regulatory(wiphy, setby);
+	mutex_unlock(&reg_mutex);
+}
+
 static void handle_channel_custom(struct wiphy *wiphy,
 				  enum ieee80211_band band,
 				  unsigned int chan_idx,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index b67d1c3..4a56799 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -16,6 +16,8 @@ void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
 
+void regulatory_update(struct wiphy *wiphy, enum nl80211_reg_initiator setby);
+
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
  * @wiphy: the wireless device where the beacon was found on
-- 
1.7.1

