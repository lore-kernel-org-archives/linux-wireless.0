Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59146 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3EaCLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:46 -0400
Received: by mail-pd0-f174.google.com with SMTP id 3so1378740pdj.5
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:46 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 28/40] crda: rename isalpha_upper() to reglib_isalpha_upper()
Date: Thu, 30 May 2013 19:09:17 -0700
Message-Id: <1369966169-23640-29-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_767797_7C59334B)
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
index 98aadcc..41827cd 100644
--- a/reglib.h
+++ b/reglib.h
@@ -38,7 +38,7 @@ static inline int reglib_is_world_regdom(const char *alpha2)
 	return 0;
 }
 
-static inline int isalpha_upper(char letter)
+static inline int reglib_isalpha_upper(char letter)
 {
 	if (letter >= 'A' && letter <= 'Z')
 		return 1;
@@ -47,7 +47,7 @@ static inline int isalpha_upper(char letter)
 
 static inline int is_alpha2(const char *alpha2)
 {
-	if (isalpha_upper(alpha2[0]) && isalpha_upper(alpha2[1]))
+	if (reglib_isalpha_upper(alpha2[0]) && reglib_isalpha_upper(alpha2[1]))
 		return 1;
 	return 0;
 }
-- 
1.7.10.4

