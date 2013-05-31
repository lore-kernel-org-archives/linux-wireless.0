Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33138 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3EaCLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:51 -0400
Received: by mail-pd0-f175.google.com with SMTP id 6so1379541pdd.34
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 29/40] crda: rename is_alpha2() to reglib_is_alpha2()
Date: Thu, 30 May 2013 19:09:18 -0700
Message-Id: <1369966169-23640-30-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_764649_BD09CD00)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/reglib.h b/reglib.h
index 41827cd..b7c5d08 100644
--- a/reglib.h
+++ b/reglib.h
@@ -45,7 +45,7 @@ static inline int reglib_isalpha_upper(char letter)
 	return 0;
 }
 
-static inline int is_alpha2(const char *alpha2)
+static inline int reglib_is_alpha2(const char *alpha2)
 {
 	if (reglib_isalpha_upper(alpha2[0]) && reglib_isalpha_upper(alpha2[1]))
 		return 1;
@@ -54,7 +54,7 @@ static inline int is_alpha2(const char *alpha2)
 
 static inline int is_valid_regdom(const char *alpha2)
 {
-	if (!is_alpha2(alpha2) && !reglib_is_world_regdom(alpha2))
+	if (!reglib_is_alpha2(alpha2) && !reglib_is_world_regdom(alpha2))
 		return 0;
 
 	return 1;
-- 
1.7.10.4

