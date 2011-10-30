Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56146 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1J3GsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 02:48:00 -0400
Received: by faan17 with SMTP id n17so4693010faa.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2011 23:47:58 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] ipw2x00: remove unused function libipw_ratelimit_debug.
Date: Sun, 30 Oct 2011 02:47:50 -0400
Message-Id: <1319957270-1406-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20111030_074826_797310_DFF3FC9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like no one uses it.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/libipw.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 70f5586..3d5821e 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -66,16 +66,8 @@ extern u32 libipw_debug_level;
 do { if (libipw_debug_level & (level)) \
   printk(KERN_DEBUG "libipw: %c %s " fmt, \
          in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
-static inline bool libipw_ratelimit_debug(u32 level)
-{
-	return (libipw_debug_level & level) && net_ratelimit();
-}
 #else
 #define LIBIPW_DEBUG(level, fmt, args...) do {} while (0)
-static inline bool libipw_ratelimit_debug(u32 level)
-{
-	return false;
-}
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
 /*
-- 
1.7.2.5

