Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44422 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754041AbaEILWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:22:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri,  9 May 2014 14:21:56 +0300
Message-Id: <1399634516-13089-1-git-send-email-luca@coelho.fi> (sfid-20140509_132212_674110_CD90A686)
Subject: [PATCH] cfg80211: fix compilation error in cfg80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Commit 0be035a2 (mac80211: handle failed restart/resume better) broke
compilation:

net/wireless/core.c: In function 'cfg80211_shutdown_all_interfaces':
net/wireless/core.c:215:9: error: implicit declaration of function 'wiphy_to_dev' [-Werror=implicit-function-declaration]
  struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
         ^

This is due to the function name change from wiphy_to_dev() to
wiphy_to_rdev().

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

Feel free to squash this into your last commit, if you prefer to
rebase your mac80211-next/master branch.

 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c95fddf..3978871 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -212,7 +212,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 
 void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct wireless_dev *wdev;
 
 	ASSERT_RTNL();
-- 
2.0.0.rc0

