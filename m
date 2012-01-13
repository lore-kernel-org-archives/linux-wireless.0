Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2AMNSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 08:18:02 -0500
Subject: [PATCH 3.3] mac80211: fix no-op authorized transitions
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jan 2012 14:17:59 +0100
Message-ID: <1326460679.3378.3.camel@jlt3.sipsolutions.net> (sfid-20120113_141812_552072_3756F73D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When userspace attempts to authorize a station
that is already authorized, nothing happens as
you'd expect. Similarly, when it unauthorizes
a station that is associated, nothing happens.

However, when it unauthorizes a station that
isn't even associated yet, we erroneously try
to move the station to associated. This seems
to happen occasionally as a result of a race
when wpa_supplicant attempts to unauthorize
the port in managed mode. Particularly with my
new patches to keep stations, it can then move
a station into ASSOCIATED state before we have
really associated, which is really confusing.

I introduced this bug in
"mac80211: refactor station state transitions"

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/cfg.c	2012-01-13 14:09:53.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-01-13 14:13:24.000000000 +0100
@@ -791,7 +791,7 @@ static int sta_apply_parameters(struct i
 		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
 			ret = sta_info_move_state_checked(sta,
 					IEEE80211_STA_AUTHORIZED);
-		else
+		else if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 			ret = sta_info_move_state_checked(sta,
 					IEEE80211_STA_ASSOC);
 		if (ret)


