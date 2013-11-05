Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59518 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:45 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so2747080bkz.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:44 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 16/19] cfg80211: set core regulatory updates on its own
Date: Tue,  5 Nov 2013 09:18:14 -0800
Message-Id: <1383671897-7746-17-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181753_187711_9054956A)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits up the core regulatory update to be
set on its own helper. This should make it easier
to read exactly what type of requests should be
expected there. In this case its clear that
NL80211_REGDOM_SET_BY_CORE is only used by the
core for updating the world regulatory domain.
This is consistant with the nl80211.h documentation.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dc99f3e..cb20ccc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2188,6 +2188,14 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 	print_rd_rules(rd);
 }
 
+static int reg_set_rd_core(const struct ieee80211_regdomain *rd)
+{
+	if (!is_world_regdom(rd->alpha2))
+		return -EINVAL;
+	update_world_regdomain(rd);
+	return 0;
+}
+
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd,
 			struct regulatory_request *lr)
@@ -2196,18 +2204,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd,
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct wiphy *request_wiphy;
 
-	/* Some basic sanity checks first */
-
-	if (!reg_is_valid_request(rd->alpha2))
-		return -EINVAL;
-
-	if (is_world_regdom(rd->alpha2)) {
-		if (lr->initiator != NL80211_REGDOM_SET_BY_CORE)
-			return -EINVAL;
-		update_world_regdomain(rd);
-		return 0;
-	}
-
 	if (!is_alpha2_set(rd->alpha2) && !is_an_alpha2(rd->alpha2) &&
 	    !is_unknown_alpha2(rd->alpha2))
 		return -EINVAL;
@@ -2317,10 +2313,25 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	struct regulatory_request *lr;
 	int r;
 
+	if (!reg_is_valid_request(rd->alpha2)) {
+		kfree(rd);
+		return -EINVAL;
+	}
+
 	lr = get_last_request();
 
 	/* Note that this doesn't update the wiphys, this is done below */
-	r = __set_regdom(rd, lr);
+	switch (lr->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		r = reg_set_rd_core(rd);
+		break;
+	case NL80211_REGDOM_SET_BY_USER:
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		r = __set_regdom(rd, lr);
+		break;
+	}
+
 	if (r) {
 		if (r == -EALREADY)
 			reg_set_request_processed();
-- 
1.8.4.rc3

