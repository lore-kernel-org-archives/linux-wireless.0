Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaA0KU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 05:20:27 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 5/6] cfg80211: Enable GO operation on indoor channels
Date: Mon, 27 Jan 2014 12:21:57 +0200
Message-Id: <1390818118-27261-6-git-send-email-ilan.peer@intel.com> (sfid-20140127_112049_281610_BFF6F9B6)
In-Reply-To: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
iff there is a user hint indicating that the platform is operating in
an indoor environment, i.e., the platform is a printer or media center
device.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/chan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 87a9d0e..4ae3cd0 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -611,14 +611,20 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
  * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
  * associated to an AP on the same channel or on the same UNII band
  * (assuming that the AP is an authorized master).
+ * In addition allow the GO to operate on a channel on which indoor operation is
+ * allowed, iff we are currently operating in an indoor environment.
  */
 static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 					struct ieee80211_channel *chan)
 {
 	struct wireless_dev *wdev_iter;
+	struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
 
 	ASSERT_RTNL();
 
+	if (regulatory_ir_allowed(wiphy, chan))
+		return true;
+
 	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
 		return false;
 
-- 
1.7.10.4

