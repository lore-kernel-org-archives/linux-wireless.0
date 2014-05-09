Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:35008 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaEIIjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:39:00 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so2355235eek.18
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 01:38:59 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] crda: add AUTO-BW rule flag support
Date: Fri,  9 May 2014 10:38:43 +0200
Message-Id: <1399624723-9167-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_103913_158212_919592E5)
In-Reply-To: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 regdb.h  |    1 +
 reglib.c |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/regdb.h b/regdb.h
index 20f29e9..3ffb781 100644
--- a/regdb.h
+++ b/regdb.h
@@ -81,6 +81,7 @@ enum reg_rule_flags {
 					 * Point links */
 	RRF_NO_IR		= 1<<7, /* do not initiate radiation */
 	__RRF_NO_IBSS		= 1<<8, /* old no-IBSS rule, maps to no-ir */
+	RRF_AUTO_BW		= 1<<11, /* Auto BW calculations */
 };
 
 #define RRF_NO_IR_ALL	(RRF_NO_IR | __RRF_NO_IBSS)
diff --git a/reglib.c b/reglib.c
index 1e57634..3deca4a 100644
--- a/reglib.c
+++ b/reglib.c
@@ -750,6 +750,8 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 		printf(", PTMP-ONLY");
 	if (rule->flags & RRF_NO_IR_ALL)
 		printf(", NO-IR");
+	if (rule->flags & RRF_AUTO_BW)
+		printf(", AUTO-BW");
 
 	printf("\n");
 }
@@ -793,6 +795,8 @@ static uint32_t reglib_parse_rule_flag(char *flag_s)
 		return RRF_PTMP_ONLY;
 	if (strncmp(flag_s, "NO-IR", 5) == 0)
 		return RRF_NO_IR;
+	if (strncmp(flag_s, "AUTO-BW", 7) == 0)
+		return RRF_AUTO_BW;
 
 	return 0;
 }
-- 
1.7.9.5

