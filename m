Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63135 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab0DPJTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 05:19:20 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G9IpVP031812
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 12:19:17 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G9I0II010544
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 12:18:02 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv3 2/2] cfg80211: Remove default dynamic PS timeout value
Date: Fri, 16 Apr 2010 12:14:34 +0300
Message-Id: <1271409274-17162-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
network latency configuration, configure a default value of -1 as the dynamic
ps timeout in cfg80211. This value allows the mac80211 to determine the value
to be used.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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

