Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36140 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcLBBs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:56 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so25526025oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:55 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Date: Thu,  1 Dec 2016 19:48:29 -0600
Message-Id: <20161202014833.6856-11-Larry.Finger@lwfinger.net> (sfid-20161202_024901_498407_F2154A91)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add a new debugging function.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 23 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/debug.h       | 14 +++++++++++++
 2 files changed, 37 insertions(+)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -27,6 +27,29 @@
 
 #include	"../wifi.h"
 
+#ifdef CONFIG_RTLWIFI_DEBUG
+
+#define BTC_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
+#define BTC_TRACE(fmt)						\
+do {								\
+	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
+	if (!rtlpriv)					\
+		break;						\
+	RT_TRACE_STRING(rtlpriv, COMP_COEX, DBG_LOUD, fmt);	\
+} while (0)
+
+#else
+
+static inline void BTC_SPRINTF(char *ptr, ...)
+{
+}
+
+static inline void BTC_TRACE(const char *ptr)
+{
+}
+
+#endif
+
 #define		NORMAL_EXEC				false
 #define		FORCE_EXEC				true
 
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/debug.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -194,6 +194,15 @@ do {									\
 	}								\
 } while (0)
 
+#define RT_TRACE_STRING(__priv, comp, level, string)			\
+do {									\
+	if (unlikely(((comp) & __priv->dbg.global_debugcomponents) &&	\
+		     ((level) <= __priv->dbg.global_debuglevel))) {	\
+		printk(KBUILD_MODNAME ":%s():<%lx> %s",			\
+		       __func__, in_interrupt(), string);		\
+	}								\
+} while (0)
+
 #define RT_PRINT_DATA(rtlpriv, _comp, _level, _titlestring, _hexdata,	\
 		      _hexdatalen)					\
 do {									\
@@ -230,6 +239,11 @@ static inline void RTPRINT(struct rtl_pr
 {
 }
 
+static inline void RT_TRACE_STRING(struct rtl_priv *rtlpriv,
+				   u64 comp, int level, const char *string)
+{
+}
+
 static inline void RT_PRINT_DATA(struct rtl_priv *rtlpriv,
 				 u64 comp, int level,
 				 const char *titlestring,
