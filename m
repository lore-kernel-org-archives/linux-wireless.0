Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58289 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab1LETQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 14:16:00 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Remove WARN_ON in apply-ht-override logic.
Date: Mon,  5 Dec 2011 11:15:55 -0800
Message-Id: <1323112555-2765-1-git-send-email-greearb@candelatech.com> (sfid-20111205_201605_295961_FDCD7E53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

AP interfaces routinely call this logic, so just silently
return when this happens instead of splatting the kernel
logs.

Reported-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 d3eafae... b5d85e7... M	net/mac80211/ht.c
 net/mac80211/ht.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index d3eafae..b5d85e7 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -47,7 +47,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	int i;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
-		WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
+		/* AP interfaces call this code when adding new stations,
+		 * so just silently ignore non station interfaces.
+		 */
 		return;
 	}
 
-- 
1.7.3.4

