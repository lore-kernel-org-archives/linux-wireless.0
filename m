Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33675 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754878AbdAABHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Dec 2016 20:07:17 -0500
Received: by mail-oi0-f65.google.com with SMTP id f201so62677934oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2016 17:07:17 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 3/3] rtlwifi: Enable debug mask to be set from sysfs
Date: Sat, 31 Dec 2016 19:07:06 -0600
Message-Id: <20170101010706.13234-4-Larry.Finger@lwfinger.net> (sfid-20170101_020727_779779_BDB223D1)
In-Reply-To: <20170101010706.13234-1-Larry.Finger@lwfinger.net>
References: <20170101010706.13234-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous commit changes the debug system to use a mask to select
which components are to be debugged. Now, we add the necessary code
to change the mask from sysfs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c  | 43 +++++++++++++++++++++++-----
 drivers/net/wireless/realtek/rtlwifi/debug.c |  6 ++--
 drivers/net/wireless/realtek/rtlwifi/debug.h |  6 ++--
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index fa27d29..c275166 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2107,12 +2107,40 @@ static ssize_t rtl_store_debug_level(struct device *d,
 
 	ret = kstrtoul(buf, 0, &val);
 	if (ret) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
-			 "%s is not in hex or decimal form.\n", buf);
+		pr_err("%s is not in hex or decimal form.\n", buf);
 	} else {
 		rtlpriv->dbg.global_debuglevel = val;
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
-			 "debuglevel:%x\n",
+		pr_debug("debuglevel:%x\n",
+			 rtlpriv->dbg.global_debuglevel);
+	}
+
+	return strnlen(buf, count);
+}
+
+static ssize_t rtl_show_debug_mask(struct device *d,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ieee80211_hw *hw = dev_get_drvdata(d);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	return sprintf(buf, "0x%x\n",rtlpriv->dbg.global_debuglevel);
+}
+
+static ssize_t rtl_store_debug_mask(struct device *d,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct ieee80211_hw *hw = dev_get_drvdata(d);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u64 val;
+	int ret;
+
+	ret = kstrtou64(buf, 0, &val);
+	if (ret) {
+		pr_err("%s is not in hex or decimal form.\n", buf);
+	} else {
+		rtlpriv->dbg.global_debuglevel = val;
+		pr_debug("debuglevel:%x\n",
 			 rtlpriv->dbg.global_debuglevel);
 	}
 
@@ -2121,16 +2149,17 @@ static ssize_t rtl_store_debug_level(struct device *d,
 
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   rtl_show_debug_level, rtl_store_debug_level);
+static DEVICE_ATTR(debug_mask, S_IWUSR | S_IRUGO,
+		   rtl_show_debug_mask, rtl_store_debug_mask);
 
 static struct attribute *rtl_sysfs_entries[] = {
-
 	&dev_attr_debug_level.attr,
-
+	&dev_attr_debug_mask.attr,
 	NULL
 };
 
 /*
- * "name" is folder name witch will be
+ * "name" is folder name which will be
  * put in device directory like :
  * sys/devices/pci0000:00/0000:00:1c.4/
  * 0000:06:00.0/rtl_sysfs
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 23a54be..55c91ee 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL_GPL(rtl_dbgp_flag_init);
 
 #ifdef CONFIG_RTLWIFI_DEBUG
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
-		    const char *fmt, ...)
+		    const char *func, const char *fmt, ...)
 {
 	if (unlikely((comp & rtlpriv->dbg.global_debug_mask) &&
 		     (level <= rtlpriv->dbg.global_debuglevel))) {
@@ -52,7 +52,7 @@ void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		pr_debug(":<%lx> %pV", in_interrupt(), &vaf);
+		pr_debug("%s %pV", func, &vaf);
 
 		va_end(args);
 	}
@@ -85,7 +85,7 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 {
 	if (unlikely(((comp) & rtlpriv->dbg.global_debug_mask) &&
 		     ((level) <= rtlpriv->dbg.global_debuglevel))) {
-		pr_debug("In process \"%s\" (pid %i): %s\n",
+		pr_info("In process \"%s\" (pid %i): %s\n",
 			 current->comm, current->pid, titlestring);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
 				     hexdata, hexdatalen);
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 90c670b..dc0b9c3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -168,9 +168,9 @@ enum dbgp_flag_e {
 
 struct rtl_priv;
 
-__printf(4, 5)
+__printf(5, 6)
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
-		    const char *fmt, ...);
+		    const char *func, const char *fmt, ...);
 
 __printf(4, 5)
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
@@ -182,7 +182,7 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 
 #define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
 	_rtl_dbg_trace(rtlpriv, comp, level,				\
-		       fmt, ##__VA_ARGS__)
+		       __func__, fmt, ##__VA_ARGS__)
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, fmt, ...)			\
 	_rtl_dbg_print(rtlpriv, dbgtype, dbgflag, fmt, ##__VA_ARGS__)
-- 
2.10.2
