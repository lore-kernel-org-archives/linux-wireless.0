Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58684 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1GSJ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 05:56:38 -0400
Received: by wwe5 with SMTP id 5so4017368wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 02:56:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: enter psm when working as p2p_cli
Date: Tue, 19 Jul 2011 12:57:13 +0300
Message-Id: <1311069433-17524-1-git-send-email-eliad@wizery.com> (sfid-20110719_115641_198378_CDD11D2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_netdev_notifier_call() is configuring psm in case
of NL80211_IFTYPE_STATION interface type (on NETDEV_UP).
do the same for NL80211_IFTYPE_P2P_CLIENT interface type.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f6b359f..41f1598 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -922,7 +922,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 		 * Configure power management to the driver here so that its
 		 * correctly set also after interface type changes etc.
 		 */
-		if (wdev->iftype == NL80211_IFTYPE_STATION &&
+		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 		    rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
 						      wdev->ps,
-- 
1.7.0.4

