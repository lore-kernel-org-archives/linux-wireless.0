Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59253 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2LERkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:40:18 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  Fix ethtool stats and other ops.
Date: Wed,  5 Dec 2012 09:39:52 -0800
Message-Id: <1354729192-22945-1-git-send-email-greearb@candelatech.com> (sfid-20121205_184022_116114_5736073D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

net/core/dev.c now assigns a default ethtool ops, so
the net/wireless/core.c check for existing ops is always true
so the wireless ops would never be assigned.

Simply remove the check for existing ops and always assign
the wireless ops.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4e6fe62..6309699 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -863,8 +863,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout = -1;
 
-		if (!dev->ethtool_ops)
-			dev->ethtool_ops = &cfg80211_ethtool_ops;
+		dev->ethtool_ops = &cfg80211_ethtool_ops;
 
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
-- 
1.7.3.4

