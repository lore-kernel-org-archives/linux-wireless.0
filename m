Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaBSPqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:46:49 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v4 5/5] cfg80211: Enable GO operation on indoor channels
Date: Wed, 19 Feb 2014 17:48:58 +0200
Message-Id: <1392824938-18439-1-git-send-email-ilan.peer@intel.com> (sfid-20140219_164712_900072_185C91C8)
In-Reply-To: <1392824377-18254-6-git-send-email-ilan.peer@intel.com>
References: <1392824377-18254-6-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
iff there is a user hint indicating that the platform is operating in
an indoor environment, i.e., the platform is a printer or media center
device.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/chan.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 1d8c990..b18367d 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -611,6 +611,8 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
  * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
  * associated to an AP on the same channel or on the same UNII band
  * (assuming that the AP is an authorized master).
+ * In addition allow the GO to operate on a channel on which indoor operation is
+ * allowed, iff we are currently operating in an indoor environment.
  */
 static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 					struct ieee80211_channel *chan)
@@ -621,8 +623,14 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 	ASSERT_RTNL();
 
 	if (!config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
-	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR) ||
-	    !(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
+	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
+		return false;
+
+	if (regulatory_indoor_allowed() &&
+	    (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
+		return true;
+
+	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
 		return false;
 
 	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
-- 
1.7.10.4

