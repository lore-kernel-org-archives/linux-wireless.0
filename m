Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:46118 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1H3VtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 17:49:10 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-wireless@vger.kernel.org
Cc: Sven Neumann <s.neumann@raumfeld.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Daniel Mack <daniel@zonque.org>
Subject: [PATCH 2/2] cfg80211: reorder code to obsolete forward declaration
Date: Tue, 30 Aug 2011 23:38:54 +0200
Message-Id: <1314740334-10341-2-git-send-email-s.neumann@raumfeld.com> (sfid-20110830_234914_505935_2E25B747)
In-Reply-To: <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com>
References: <20110830191437.GC2660@tuxdriver.com>
 <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder functions to remove the need for a forward declaration
introduced by the last commit.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/reg.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c50016e..c77928b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -103,9 +103,6 @@ struct reg_beacon {
 	struct ieee80211_channel chan;
 };
 
-static void wiphy_update_regulatory(struct wiphy *wiphy,
-				    enum nl80211_reg_initiator initiator);
-
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
@@ -915,14 +912,6 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	return false;
 }
 
-static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
-{
-	struct cfg80211_registered_device *rdev;
-
-	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
-		wiphy_update_regulatory(&rdev->wiphy, initiator);
-}
-
 static void handle_reg_beacon(struct wiphy *wiphy,
 			      unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
@@ -1151,6 +1140,14 @@ void regulatory_update(struct wiphy *wiphy,
 	mutex_unlock(&reg_mutex);
 }
 
+static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
+{
+	struct cfg80211_registered_device *rdev;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+		wiphy_update_regulatory(&rdev->wiphy, initiator);
+}
+
 static void handle_channel_custom(struct wiphy *wiphy,
 				  enum ieee80211_band band,
 				  unsigned int chan_idx,
-- 
1.7.4.1

