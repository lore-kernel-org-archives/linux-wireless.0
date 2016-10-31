Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:33970 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943052AbcJaNlO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 09:41:14 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH v7 1/2] nl80211: multicast_to_unicast can be changed while IFF_UP
Date: Mon, 31 Oct 2016 14:40:59 +0100
Message-Id: <1477921260-24556-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161031_144120_261402_FBC24B8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to prevent toggling multicast_to_unicast while
interface is already up. This change simplifies reconfiguration
from hostapd.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/wireless/nl80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5349c63..7554400 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11006,9 +11006,6 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	const struct nlattr *nla;
 	bool enabled;
 
-	if (netif_running(dev))
-		return -EBUSY;
-
 	if (!rdev->ops->set_multicast_to_unicast)
 		return -EOPNOTSUPP;
 
-- 
2.1.4
