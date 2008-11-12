Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13738 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYKLWWM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 05/10] cfg80211: expect different rd in cfg80211 when intersecting
Date: Wed, 12 Nov 2008 14:21:59 -0800
Message-ID: <1226528524-32678-6-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232219_053041_D5EE941C)
In-Reply-To: <1226528524-32678-5-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-3-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When intersecting it is possible that set_regdom() was called
with a regulatory domain which we'll only use as an aid to
build a final regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
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

