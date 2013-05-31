Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53328 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3EaCLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:55 -0400
Received: by mail-pb0-f43.google.com with SMTP id ma3so1394503pbc.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:55 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 30/40] crda: rename is_valid_regdom() to reglib_is_valid_regdom()
Date: Thu, 30 May 2013 19:09:19 -0700
Message-Id: <1369966169-23640-31-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_546749_2B19ED2A)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 crda.c   |    2 +-
 reglib.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crda.c b/crda.c
index fc7a25f..2a601eb 100644
--- a/crda.c
+++ b/crda.c
@@ -170,7 +170,7 @@ int main(int argc, char **argv)
 		return -EINVAL;
 	}
 
-	if (!is_valid_regdom(env_country)) {
+	if (!reglib_is_valid_regdom(env_country)) {
 		fprintf(stderr, "COUNTRY environment variable must be an "
 			"ISO ISO 3166-1-alpha-2 (uppercase) or 00\n");
 		return -EINVAL;
diff --git a/reglib.h b/reglib.h
index b7c5d08..8ed94d9 100644
--- a/reglib.h
+++ b/reglib.h
@@ -52,7 +52,7 @@ static inline int reglib_is_alpha2(const char *alpha2)
 	return 0;
 }
 
-static inline int is_valid_regdom(const char *alpha2)
+static inline int reglib_is_valid_regdom(const char *alpha2)
 {
 	if (!reglib_is_alpha2(alpha2) && !reglib_is_world_regdom(alpha2))
 		return 0;
-- 
1.7.10.4

