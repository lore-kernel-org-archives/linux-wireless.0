Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40053 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EaCJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:09:50 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so1376731pbc.25
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:09:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 03/40] crda: remove verbose errors out of regdom_intersect()
Date: Thu, 30 May 2013 19:08:52 -0700
Message-Id: <1369966169-23640-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_040953_513783_9D406B0B)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

We want to move this to reglib so nuke all that fluff.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/intersect.c b/intersect.c
index e35f2cc..bd2976f 100644
--- a/intersect.c
+++ b/intersect.c
@@ -110,10 +110,8 @@ static struct ieee80211_regdomain *regdom_intersect(
 
 	memset(intersected_rule, 0, sizeof(struct ieee80211_reg_rule));
 
-	if (!rd1 || !rd2) {
-		fprintf(stderr, "rd1 or or rd2 is null\n");
+	if (!rd1 || !rd2)
 		return NULL;
-	}
 
 	/* First we get a count of the rules we'll need, then we actually
 	 * build them. This is to so we can malloc() and free() a
@@ -133,19 +131,15 @@ static struct ieee80211_regdomain *regdom_intersect(
 		}
 	}
 
-	if (!num_rules) {
-		fprintf(stderr, "error: num_rules == 0\n");
+	if (!num_rules)
 		return NULL;
-	}
 
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
 		((num_rules + 1) * sizeof(struct ieee80211_reg_rule));
 
 	rd = malloc(size_of_regd);
-	if (!rd) {
-		fprintf(stderr, "no memory left\n");
+	if (!rd)
 		return NULL;
-	}
 
 	memset(rd, 0, size_of_regd);
 
@@ -166,7 +160,6 @@ static struct ieee80211_regdomain *regdom_intersect(
 	}
 
 	if (rule_idx != num_rules) {
-		fprintf(stderr, "Error while doing regdom interesection :(\n");
 		free(rd);
 		return NULL;
 	}
-- 
1.7.10.4

