Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46515 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3EaCLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:42 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so1378576pbb.24
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:41 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 27/40] crda: rename is_world_regdom() to reglib_is_world_regdom()
Date: Thu, 30 May 2013 19:09:16 -0700
Message-Id: <1369966169-23640-28-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042939_164859_2FF68AD3)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    2 +-
 reglib.h    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/intersect.c b/intersect.c
index 22b3225..bc1e63e 100644
--- a/intersect.c
+++ b/intersect.c
@@ -24,7 +24,7 @@ int main(int argc, char **argv)
 
 	/* We intersect only when we have to rd structures ready */
 	reglib_for_each_country(rd, idx, argv[1]) {
-		if (is_world_regdom((const char *) rd->alpha2)) {
+		if (reglib_is_world_regdom((const char *) rd->alpha2)) {
 			free((struct ieee80211_regdomain *) rd);
 			continue;
 		}
diff --git a/reglib.h b/reglib.h
index 4c0ec6d..98aadcc 100644
--- a/reglib.h
+++ b/reglib.h
@@ -31,7 +31,7 @@ struct ieee80211_regdomain {
 	struct ieee80211_reg_rule reg_rules[];
 };
 
-static inline int is_world_regdom(const char *alpha2)
+static inline int reglib_is_world_regdom(const char *alpha2)
 {
 	if (alpha2[0] == '0' && alpha2[1] == '0')
 		return 1;
@@ -54,7 +54,7 @@ static inline int is_alpha2(const char *alpha2)
 
 static inline int is_valid_regdom(const char *alpha2)
 {
-	if (!is_alpha2(alpha2) && !is_world_regdom(alpha2))
+	if (!is_alpha2(alpha2) && !reglib_is_world_regdom(alpha2))
 		return 0;
 
 	return 1;
-- 
1.7.10.4

