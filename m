Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52804 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab0JUTKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 15:10:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 12:10:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH v2 5/6] ath: add a ATH_DBG_WARN()
Date: Thu, 21 Oct 2010 12:10:11 -0700
Message-ID: <1287688211-9998-1-git-send-email-lrodriguez@atheros.com>
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

Fixed compile issue with CONFIG_ATH_DEBUG disabled.

 drivers/net/wireless/ath/debug.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index 64e4af2..f207007 100644
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
+#define ATH_DBG_WARN(foo, arg)
 #endif /* CONFIG_ATH_DEBUG */
 
 /** Returns string describing opmode, or NULL if unknown mode. */
-- 
1.7.1

