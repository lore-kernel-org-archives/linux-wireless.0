Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35665 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391AbaCSJEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 05:04:47 -0400
Received: by mail-pb0-f51.google.com with SMTP id uo5so8630019pbc.38
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 02:04:47 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/3] cfg80211: remove unnecessary check
Date: Wed, 19 Mar 2014 17:04:35 +0800
Message-Id: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100452_933448_8E2678EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RCU pointer bss->pub.beacon_ies is checked before in previous
statement:

if (rcu_access_pointer(bss->pub.beacon_ies))
	continue;

There is no need to check it twice(and in the wrong way :) ).

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/scan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d1ed4ae..7297d18 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -659,9 +659,6 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 			continue;
 		if (ssidlen && ie[1] != ssidlen)
 			continue;
-		/* that would be odd ... */
-		if (bss->pub.beacon_ies)
-			continue;
 		if (WARN_ON_ONCE(bss->pub.hidden_beacon_bss))
 			continue;
 		if (WARN_ON_ONCE(!list_empty(&bss->hidden_list)))
-- 
1.8.5.3

