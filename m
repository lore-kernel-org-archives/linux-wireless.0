Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59522 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaCKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:25 -0400
Received: by mail-pb0-f50.google.com with SMTP id wy17so1384818pbc.9
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/40] crda: do not double count on reglib_for_each_country()
Date: Thu, 30 May 2013 19:08:58 -0700
Message-Id: <1369966169-23640-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041027_902681_EE7DAA0A)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Commit ebcbfcf4 introduced reglib_for_each_country() used
by regdbump and later intersect. This helper however only
increased the index count after we requestd getting a new
regulatory domain, this is incorrect and causes us to iterate
over the same element twice in the beginning. This means
intersection and regdb printing was going over the first
element twice. This has been present since v1.1.

This also requires an adjustment on intersect due to the
way things were being handled before.

mcgrof@frijol ~/devel/crda (git::master)$ git describe --contains ebcbfcf4
v1.1.3~9

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   10 +++-------
 reglib.h    |    3 +--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/intersect.c b/intersect.c
index 5cb7d7c..dea9145 100644
--- a/intersect.c
+++ b/intersect.c
@@ -79,16 +79,12 @@ int main(int argc, char **argv)
 		return -EINVAL;
 	}
 
-	if (idx == 1) {
-		world = (struct ieee80211_regdomain *) rd;
-		rd = NULL;
-	}
-
-
 	if (intersected > 1)
 		printf("%d regulatory domains intersected\n", intersected);
-	else
+	else {
+		world = prev_world;
 		printf("Only one intersection completed\n");
+	}
 
 	/* Tada! */
 	printf("== World regulatory domain: ==\n");
diff --git a/reglib.h b/reglib.h
index b52d717..8bd9e03 100644
--- a/reglib.h
+++ b/reglib.h
@@ -79,8 +79,7 @@ reglib_get_rd_idx(unsigned int idx, const char *file);
 #define reglib_for_each_country(__rd, __idx, __file)			\
 	for (__rd = reglib_get_rd_idx(__idx, __file);		\
 	     __rd != NULL;						\
-	     __rd = reglib_get_rd_idx(__idx, __file),		\
-	     __idx++)
+	     __rd = reglib_get_rd_idx(++__idx, __file))		\
 
 const struct ieee80211_regdomain *
 reglib_get_rd_alpha2(const char *alpha2, const char *file);
-- 
1.7.10.4

