Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934239AbYCDXaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:30:35 -0500
Message-Id: <200803042326.m24NQGtr003314@imap1.linux-foundation.org> (sfid-20080304_233043_616380_25A4B8B8)
Subject: [patch 10/10] WDEV: ath5k, typecheck on nonDEBUG
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:15 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>

At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/debug.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/ath5k/debug.h~wdev-ath5k-typecheck-on-nondebug drivers/net/wireless/ath5k/debug.h
--- a/drivers/net/wireless/ath5k/debug.h~wdev-ath5k-typecheck-on-nondebug
+++ a/drivers/net/wireless/ath5k/debug.h
@@ -171,7 +171,9 @@ ath5k_debug_printtxbuf(struct ath5k_soft
 
 #else /* no debugging */
 
-#define ATH5K_TRACE(_sc) /* empty */
+#include <linux/compiler.h>
+
+#define ATH5K_TRACE(_sc) typecheck(struct ath5k_softc *, (_sc))
 
 static inline void __attribute__ ((format (printf, 3, 4)))
 ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
_
