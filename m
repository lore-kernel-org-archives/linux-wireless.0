Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56107 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764865AbYBOVAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:00:17 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 3/3] WDEV: ath5k, typecheck on nonDEBUG
Date: Fri, 15 Feb 2008 21:58:53 +0100
Message-Id: <1203109133-32217-3-git-send-email-jirislaby@gmail.com> (sfid-20080215_210036_689967_CAA7BA4A)
In-Reply-To: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/debug.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index c4fd8c4..44324c3 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -171,7 +171,9 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc,
 
 #else /* no debugging */
 
-#define ATH5K_TRACE(_sc) /* empty */
+#include <linux/compiler.h>
+
+#define ATH5K_TRACE(_sc) typecheck(struct ath5k_softc *, (_sc))
 
 static inline void __attribute__ ((format (printf, 3, 4)))
 ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
-- 
1.5.3.8

