Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34364 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbcLBBsv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:51 -0500
Received: by mail-oi0-f66.google.com with SMTP id m75so25564833oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:50 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 03/14] rtlwifi: extend debug_comp to u64
Date: Thu,  1 Dec 2016 19:48:23 -0600
Message-Id: <20161202014833.6856-5-Larry.Finger@lwfinger.net> (sfid-20161202_024907_968591_18ABCDBE)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of debugging conditions will exceed the capabilities of a
32-bit word.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 33905bb..3e75ebc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -50,7 +50,7 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 EXPORT_SYMBOL_GPL(rtl_dbgp_flag_init);
 
 #ifdef CONFIG_RTLWIFI_DEBUG
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
+void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *modname, const char *fmt, ...)
 {
 	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 6156a79..9c77ddaf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -178,7 +178,7 @@ do {									\
 struct rtl_priv;
 
 __printf(5, 6)
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
+void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *modname, const char *fmt, ...);
 
 #define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
@@ -217,7 +217,7 @@ static inline void RT_ASSERT(int exp, const char *fmt, ...)
 
 __printf(4, 5)
 static inline void RT_TRACE(struct rtl_priv *rtlpriv,
-			    int comp, int level,
+			    u64 comp, int level,
 			    const char *fmt, ...)
 {
 }
@@ -230,7 +230,7 @@ static inline void RTPRINT(struct rtl_priv *rtlpriv,
 }
 
 static inline void RT_PRINT_DATA(struct rtl_priv *rtlpriv,
-				 int comp, int level,
+				 u64 comp, int level,
 				 const char *titlestring,
 				 const void *hexdata, size_t hexdatalen)
 {
-- 
2.10.2
