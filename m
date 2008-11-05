Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbYKECuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] cfg80211: expect different rd in cfg80211 when intersecting
Date: Tue, 4 Nov 2008 18:50:04 -0800
Message-ID: <1225853406-16322-6-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035024_895318_AEDD9B8D)
In-Reply-To: <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When intersecting it is possible that set_regdom() was called
with a regulatory domain which we'll only use as an aid to
build a final regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 845e2d3..f062b8b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -880,12 +880,13 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	/* This would make this whole thing pointless */
-	BUG_ON(rd != cfg80211_regdomain);
+	if (!last_request->intersect)
+		BUG_ON(rd != cfg80211_regdomain);
 
 	/* update all wiphys now with the new established regulatory domain */
 	update_all_wiphy_regulatory(last_request->initiator);
 
-	print_regdomain(rd);
+	print_regdomain(cfg80211_regdomain);
 
 	return r;
 }
-- 
1.5.6.3

