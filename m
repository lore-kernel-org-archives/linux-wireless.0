Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19380 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbZAMT6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] cfg80211: split wiphy_update_regulatory() in two
Date: Tue, 13 Jan 2009 11:57:47 -0800
Message-ID: <1231876675-20518-5-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205833_363625_2D6FD4B7)
In-Reply-To: <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits up wiphy_update_regulatory() in two parts, the
first can be used by other internal cfg80211 regulatory routines
to avoid calling the reg_notifier() if not needed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 49c9c25..127bec2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -963,13 +963,18 @@ static void update_all_wiphy_regulatory(enum reg_set_by setby)
 			wiphy_update_regulatory(&drv->wiphy, setby);
 }
 
-void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
+static void regd_update_regulatory(struct wiphy *wiphy)
 {
 	enum ieee80211_band band;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band);
 	}
+}
+
+void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
+{
+	regd_update_regulatory(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, setby);
 }
-- 
1.6.1.rc3.51.g5832d

