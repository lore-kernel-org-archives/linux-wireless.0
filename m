Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39812 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbYH2RSD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:18:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] cfg80211: move alpha2 helpers on reg.c for use by others
Date: Fri, 29 Aug 2008 10:17:55 -0700
Message-ID: <1220030278-6088-2-git-send-email-lrodriguez@atheros.com> (sfid-20080829_191809_076316_892DF1D3)
In-Reply-To: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com>
References: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   74 ++++++++++++++++++++++++++--------------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2acd665..f825b6d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -59,6 +59,43 @@ static int is_world_regdom(char *alpha2)
 	return 0;
 }
 
+static int is_alpha2_set(char *alpha2)
+{
+	if (alpha2[0] != 0 && alpha2[1] != 0)
+		return 1;
+	return 0;
+}
+
+static int is_alpha_upper(char letter)
+{
+	/* ASCII A - Z */
+	if (letter >= 65 && letter <= 90)
+		return 1;
+	return 0;
+}
+
+static int is_an_alpha2(char *alpha2)
+{
+	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
+		return 1;
+	return 0;
+}
+
+static int alpha2_equal(char *alpha2_x, char *alpha2_y)
+{
+	if (alpha2_x[0] == alpha2_y[0] &&
+		alpha2_x[1] == alpha2_y[1])
+		return 1;
+	return 0;
+}
+
+static int regdom_changed(char *alpha2)
+{
+	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		return 0;
+	return 1;
+}
+
 /* This lets us keep regulatory code, which is updated on a regulatory
  * basis to userspace. */
 static int call_crda(const char *alpha2)
@@ -140,43 +177,6 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2,
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-static int is_alpha2_set(char *alpha2)
-{
-	if (alpha2[0] != 0 && alpha2[1] != 0)
-		return 1;
-	return 0;
-}
-
-static int is_alpha_upper(char letter)
-{
-	/* ASCII A - Z */
-	if (letter >= 65 && letter <= 90)
-		return 1;
-	return 0;
-}
-
-static int is_an_alpha2(char *alpha2)
-{
-	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
-		return 1;
-	return 0;
-}
-
-static int alpha2_equal(char *alpha2_x, char *alpha2_y)
-{
-	if (alpha2_x[0] == alpha2_y[0] &&
-		alpha2_x[1] == alpha2_y[1])
-		return 1;
-	return 0;
-}
-
-static int regdom_changed(char *alpha2)
-{
-	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
-		return 0;
-	return 1;
-}
-
 /* caller must lock cfg80211_reg_mutex */
 static int __reg_is_valid_request(char *alpha2,
 	struct regulatory_request **request)
-- 
1.5.6.4

