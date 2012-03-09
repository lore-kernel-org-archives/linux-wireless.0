Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2CHXEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 18:04:05 -0500
Received: by iagz16 with SMTP id z16so1333682iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 15:04:05 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: remove unused definitions for regulatory domain
Date: Thu,  8 Mar 2012 19:06:50 -0500
Message-Id: <1331251610-9280-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120309_000427_933843_D5CA3D19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ipw2200 driver does not use these defines, it uses geo struct instead.
Therefore remove them from its header.

Note: we keep them in the ipw2100 driver's header, because the driver
still uses them.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 66e84ec..570d6fb 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -1997,18 +1997,6 @@ struct ipw_cmd_log {
 #define CFG_SYS_ANTENNA_B               0x03	/* force antenna B */
 #define CFG_SYS_ANTENNA_SLOW_DIV        0x02	/* consider background noise */
 
-/*
- * The definitions below were lifted off the ipw2100 driver, which only
- * supports 'b' mode, so I'm sure these are not exactly correct.
- *
- * Somebody fix these!!
- */
-#define REG_MIN_CHANNEL             0
-#define REG_MAX_CHANNEL             14
-
-#define REG_CHANNEL_MASK            0x00003FFF
-#define IPW_IBSS_11B_DEFAULT_MASK   0x87ff
-
 #define IPW_MAX_CONFIG_RETRIES 10
 
 #endif				/* __ipw2200_h__ */
-- 
1.7.2.5

