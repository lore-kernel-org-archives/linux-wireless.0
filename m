Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42518 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759765AbZAVXGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] cfg80211: ignore consecutive equal regulatory hints
Date: Thu, 22 Jan 2009 15:05:48 -0800
Message-ID: <1232665554-26132-7-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000705_569364_BD222846)
In-Reply-To: <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We ignore regulatory hints for the same alpha2 if we already
have processed the same alpha2 on the current regulatory domain.
For a driver regulatory_hint() this means we copy onto its
wiphy->regd the previously procesed regulatory domain from CRDA
without having to call CRDA again.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ff1a05..421c5b3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1088,8 +1088,13 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		}
 		return REG_INTERSECT;
 	case REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == REGDOM_SET_BY_CORE)
-			return 0;
+		if (last_request->initiator == REGDOM_SET_BY_CORE) {
+			if (is_old_static_regdom(cfg80211_regdomain))
+				return 0;
+			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+				return 0;
+			return -EALREADY;
+		}
 		return REG_INTERSECT;
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
@@ -1109,6 +1114,10 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				return -EAGAIN;
 		}
 
+		if (!is_old_static_regdom(cfg80211_regdomain) &&
+		    alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			return -EALREADY;
+
 		return 0;
 	}
 
-- 
1.6.1.rc3.51.g5832d

