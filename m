Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:53209 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0DNGpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 02:45:10 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi
Subject: [RFC PATCH 2/2] cfg80211: Remove default dynamic PS timeout value
Date: Wed, 14 Apr 2010 09:41:04 +0300
Message-Id: <1271227264-26868-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1271227264-26868-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1271227264-26868-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
network latency configuration, configure a default value of -1 as the dynamic
ps timeout in cfg80211. This value allows the mac80211 to determine the value
to be used.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/mlme.c |    2 +-
 net/wireless/core.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 22860bd..6c5c034 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -514,7 +514,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		if (timeout < 0) {
 			if (latency <= 50000)
 				timeout = 300;
-			else if (latency <= 2000000)
+			else if (latency <= 2000000000)
 				timeout = 100;
 			else
 				timeout = 0;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6ac70c1..37d0e0a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -705,7 +705,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			wdev->ps = true;
 		else
 			wdev->ps = false;
-		wdev->ps_timeout = 100;
+		/* allow mac80211 to determine the timeout */
+		wdev->ps_timeout = -1;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
 						      wdev->ps,
-- 
1.6.3.3

