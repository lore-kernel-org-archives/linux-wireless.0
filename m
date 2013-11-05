Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39558 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3KERRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:51 -0500
Received: by mail-bk0-f51.google.com with SMTP id my12so1759926bkb.38
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:50 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 19/19] cfg80211: rename __set_regdom() to reg_set_rd_country_ie()
Date: Tue,  5 Nov 2013 09:18:17 -0800
Message-Id: <1383671897-7746-20-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181757_850936_D68BC3CE)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reflects that case is now completely separated.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2ecb0c7..fb9a44d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2288,9 +2288,8 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 	return 0;
 }
 
-/* Takes ownership of rd only if it doesn't fail */
-static int __set_regdom(const struct ieee80211_regdomain *rd,
-			struct regulatory_request *lr)
+static int reg_set_rd_country_ie(const struct ieee80211_regdomain *rd,
+				 struct regulatory_request *country_ie_request)
 {
 	struct wiphy *request_wiphy;
 
@@ -2310,13 +2309,13 @@ static int __set_regdom(const struct ieee80211_regdomain *rd,
 		return -EINVAL;
 	}
 
-	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
+	request_wiphy = wiphy_idx_to_wiphy(country_ie_request->wiphy_idx);
 	if (!request_wiphy) {
 		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 
-	if (lr->intersect)
+	if (country_ie_request->intersect)
 		return -EINVAL;
 
 	reset_regdomains(false, rd);
@@ -2352,7 +2351,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 		r = reg_set_rd_driver(rd, lr);
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		r = __set_regdom(rd, lr);
+		r = reg_set_rd_country_ie(rd, lr);
 		break;
 	}
 
-- 
1.8.4.rc3

