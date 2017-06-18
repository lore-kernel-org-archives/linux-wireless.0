Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34510 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753185AbdFRQM7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:12:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id w127so7233946oiw.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:12:59 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/11] rtlwifi: extend debug_comp to u64
Date: Sun, 18 Jun 2017 11:12:43 -0500
Message-Id: <20170618161249.6146-6-Larry.Finger@lwfinger.net> (sfid-20170618_181311_029435_4B97DA1F)
In-Reply-To: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The number of debugging conditions now exceeds the capabilities of a
32-bit word.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 7ecac6116d5d..38fef6dbb44b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -27,7 +27,7 @@
 #include <linux/moduleparam.h>
 
 #ifdef CONFIG_RTLWIFI_DEBUG
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
+void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...)
 {
 	if (unlikely((comp & rtlpriv->cfg->mod_params->debug_mask) &&
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index bf5339f1c1bc..a4006104ee8a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -169,7 +169,7 @@ enum dbgp_flag_e {
 struct rtl_priv;
 
 __printf(4, 5)
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
+void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...);
 
 __printf(4, 5)
@@ -198,7 +198,7 @@ struct rtl_priv;
 
 __printf(4, 5)
 static inline void RT_TRACE(struct rtl_priv *rtlpriv,
-			    int comp, int level,
+			    u64 comp, int level,
 			    const char *fmt, ...)
 {
 }
@@ -211,7 +211,7 @@ static inline void RTPRINT(struct rtl_priv *rtlpriv,
 }
 
 static inline void RT_PRINT_DATA(struct rtl_priv *rtlpriv,
-				 int comp, int level,
+				 u64 comp, int level,
 				 const char *titlestring,
 				 const void *hexdata, size_t hexdatalen)
 {
-- 
2.12.3
