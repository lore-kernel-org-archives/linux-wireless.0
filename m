Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33552 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754103AbdASRxY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 12:53:24 -0500
Received: by mail-oi0-f67.google.com with SMTP id j15so3775912oih.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 09:53:24 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 1/3] rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA
Date: Thu, 19 Jan 2017 11:25:19 -0600
Message-Id: <20170119172521.32643-2-Larry.Finger@lwfinger.net> (sfid-20170119_185508_851139_8AF3A454)
In-Reply-To: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
References: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two debugging formss implement debugging using rather complicated
macro constructions. These are replaced with compiled code that is easier
to understand.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - No changes.
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 42 ++++++++++++++++++++++++----
 drivers/net/wireless/realtek/rtlwifi/debug.h | 33 ++++++++++------------
 2 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 33905bb..cd2efac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL_GPL(rtl_dbgp_flag_init);
 
 #ifdef CONFIG_RTLWIFI_DEBUG
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
-		    const char *modname, const char *fmt, ...)
+		    const char *fmt, ...)
 {
 	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
 		     (level <= rtlpriv->dbg.global_debuglevel))) {
@@ -63,13 +63,45 @@ void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_DEBUG "%s:%ps:<%lx-%x> %pV",
-		       modname, __builtin_return_address(0),
-		       in_interrupt(), in_atomic(),
-		       &vaf);
+		pr_debug(":<%lx> %pV", in_interrupt(), &vaf);
 
 		va_end(args);
 	}
 }
 EXPORT_SYMBOL_GPL(_rtl_dbg_trace);
+
+void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
+		    const char *fmt, ...)
+{
+	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
+		     (level <= rtlpriv->dbg.global_debuglevel))) {
+		struct va_format vaf;
+		va_list args;
+
+		va_start(args, fmt);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		pr_debug("%pV", &vaf);
+
+		va_end(args);
+	}
+}
+EXPORT_SYMBOL_GPL(_rtl_dbg_print);
+
+void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
+			 const char *titlestring,
+			 const void *hexdata, int hexdatalen)
+{
+	if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) &&
+		     ((level) <= rtlpriv->dbg.global_debuglevel))) {
+		pr_debug("In process \"%s\" (pid %i): %s\n",
+			 current->comm, current->pid, titlestring);
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
+				     hexdata, hexdatalen);
+	}
+}
+EXPORT_SYMBOL_GPL(_rtl_dbg_print_data);
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index a6cc3ca..90c670b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -168,34 +168,29 @@ enum dbgp_flag_e {
 
 struct rtl_priv;
 
-__printf(5, 6)
+__printf(4, 5)
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
-		    const char *modname, const char *fmt, ...);
+		    const char *fmt, ...);
+
+__printf(4, 5)
+void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
+		    const char *fmt, ...);
+
+void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
+			 const char *titlestring,
+			 const void *hexdata, int hexdatalen);
 
 #define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
 	_rtl_dbg_trace(rtlpriv, comp, level,				\
-		       KBUILD_MODNAME, fmt, ##__VA_ARGS__)
+		       fmt, ##__VA_ARGS__)
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, fmt, ...)			\
-do {									\
-	if (unlikely(rtlpriv->dbg.dbgp_type[dbgtype] & dbgflag)) {	\
-		printk(KERN_DEBUG KBUILD_MODNAME ": " fmt,		\
-		       ##__VA_ARGS__);					\
-	}								\
-} while (0)
+	_rtl_dbg_print(rtlpriv, dbgtype, dbgflag, fmt, ##__VA_ARGS__)
 
 #define RT_PRINT_DATA(rtlpriv, _comp, _level, _titlestring, _hexdata,	\
 		      _hexdatalen)					\
-do {									\
-	if (unlikely(((_comp) & rtlpriv->dbg.global_debugcomponents) &&	\
-		     (_level <= rtlpriv->dbg.global_debuglevel))) {	\
-		printk(KERN_DEBUG "%s: In process \"%s\" (pid %i): %s\n", \
-		       KBUILD_MODNAME, current->comm, current->pid,	\
-		       _titlestring);					\
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE,		\
-				     _hexdata, _hexdatalen);		\
-	}								\
-} while (0)
+	_rtl_dbg_print_data(rtlpriv, _comp, _level,			\
+			    _titlestring, _hexdata, _hexdatalen)
 
 #else
 
-- 
2.10.2
