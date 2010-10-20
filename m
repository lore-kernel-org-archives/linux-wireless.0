Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14864 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab0JTXHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH 5/6] ath: add a ATH_DBG_WARN()
Date: Wed, 20 Oct 2010 16:07:07 -0700
Message-ID: <1287616028-12547-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be used to throw out warnings only for developers.
This can be used by some corner cases that developers
already know can be hit but developers want to address
so to avoid spewing out a warning this can only be
enabled with CONFIG_ATH_DEBUG enabled.

Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/debug.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index 64e4af2..15fc8ff 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -70,11 +70,13 @@ enum ATH_DEBUG {
 #ifdef CONFIG_ATH_DEBUG
 void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
+#define ATH_DBG_WARN(foo, arg...) WARN(foo, arg)
 #else
 static inline void __attribute__ ((format (printf, 3, 4)))
 ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 {
 }
+#define ATH_DBG_WARN(foo)
 #endif /* CONFIG_ATH_DEBUG */
 
 /** Returns string describing opmode, or NULL if unknown mode. */
-- 
1.7.0.4

