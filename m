Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:42258 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbbBKWvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 17:51:20 -0500
Received: by labgf13 with SMTP id gf13so6561334lab.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 14:51:16 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iwl4965: Enable checking of format strings
Date: Wed, 11 Feb 2015 23:51:08 +0100
Message-Id: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk> (sfid-20150211_235132_289178_CD5E9867)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since these fmt_* variables are just const char*, and not const
char[], gcc (and smatch) doesn't to type checking of the arguments to
the printf functions. Since the linker knows perfectly well to merge
identical string constants, there's no point in having three static
pointers waste memory and give an extra level of indirection.

This removes over 100 "non-constant format argument" warnings from
smatch, accounting for about 20% of all such warnings in an
allmodconfig.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wireless/iwlegacy/4965-debug.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index e0597bfdddb8..18855325cc1c 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -28,10 +28,9 @@
 #include "common.h"
 #include "4965.h"
 
-static const char *fmt_value = "  %-30s %10u\n";
-static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
-static const char *fmt_header =
-    "%-32s    current  cumulative       delta         max\n";
+#define fmt_value "  %-30s %10u\n"
+#define fmt_table "  %-30s %10u  %10u  %10u  %10u\n"
+#define fmt_header "%-32s    current  cumulative       delta         max\n"
 
 static int
 il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
-- 
2.1.3

