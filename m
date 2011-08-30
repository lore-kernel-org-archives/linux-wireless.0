Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:46119 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1H3VtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 17:49:11 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-wireless@vger.kernel.org
Cc: Sven Neumann <s.neumann@raumfeld.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Daniel Mack <daniel@zonque.org>
Subject: [PATCH 1/2] cfg80211: hold reg_mutex when updating regulatory
Date: Tue, 30 Aug 2011 23:38:53 +0200
Message-Id: <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com> (sfid-20110830_234916_502902_0ADB0C7F)
In-Reply-To: <20110830191437.GC2660@tuxdriver.com>
References: <20110830191437.GC2660@tuxdriver.com>
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
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/core.c |    2 +-
 net/wireless/core.h |    2 --
 net/wireless/reg.c  |   17 +++++++++++++++--
 net/wireless/reg.h  |    2 ++
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c148651..220f3bd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -582,7 +582,7 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	/* set up regulatory info */
-	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
+	regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8672e02..796a4bd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -279,8 +279,6 @@ extern int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			       char *newname);
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
-void wiphy_update_regulatory(struct wiphy *wiphy,
-			     enum nl80211_reg_initiator setby);
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 02751db..c50016e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -103,6 +103,9 @@ struct reg_beacon {
 	struct ieee80211_channel chan;
 };
 
+static void wiphy_update_regulatory(struct wiphy *wiphy,
+				    enum nl80211_reg_initiator initiator);
+
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
@@ -1119,11 +1122,13 @@ static void reg_process_ht_flags(struct wiphy *wiphy)
 
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
 		return;
 
@@ -1138,6 +1143,14 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
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
1.7.4.1

