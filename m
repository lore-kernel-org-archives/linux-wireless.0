Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60870 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYH01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 02:26:27 -0500
Received: by mail-ee0-f48.google.com with SMTP id c13so937465eek.35
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 23:26:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@do-not-panic.com, linville@tuxdriver.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] crda: add AUTO-BW rule flag support
Date: Tue, 25 Feb 2014 08:26:03 +0100
Message-Id: <1393313163-9568-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140225_082631_240215_A80364D5)
In-Reply-To: <1393313163-9568-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1393313163-9568-1-git-send-email-janusz.dziedzic@tieto.com>
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

