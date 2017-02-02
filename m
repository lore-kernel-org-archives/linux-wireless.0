Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34896 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdBBMRQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 07:17:16 -0500
Received: by mail-lf0-f67.google.com with SMTP id v186so1226146lfa.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 04:17:15 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/7] brcmfmac: switch to C function (__brcmf_err) for printing errors
Date: Thu,  2 Feb 2017 13:16:53 +0100
Message-Id: <20170202121659.21130-1-zajec5@gmail.com> (sfid-20170202_131729_017000_FFCC1AFB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This will allow extending code and using more detailed messages e.g.
with the help of dev_err. Note that *two separated* brcmf_err macros
were replaced thanks to using a simple CONFIG_BRCMDBG symbol check in
the body.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.c | 19 +++++++++++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 16 ----------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index f7c8c2e80349..05fb778ddd0f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -218,6 +218,25 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	return err;
 }
 
+#ifndef CONFIG_BRCM_TRACING
+void __brcmf_err(const char *func, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if (!net_ratelimit() && !IS_ENABLED(CONFIG_BRCMDBG))
+		return;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("%s: %pV", func, &vaf);
+
+	va_end(args);
+}
+#endif
+
 #if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
 void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 6687812770cc..5fef79473c87 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -45,26 +45,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
-/* Macro for error messages. net_ratelimit() is used when driver
- * debugging is not selected. When debugging the driver error
- * messages are as important as other tracing or even more so.
- */
-#ifndef CONFIG_BRCM_TRACING
-#ifdef CONFIG_BRCMDBG
-#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
-#else
-#define brcmf_err(fmt, ...)						\
-	do {								\
-		if (net_ratelimit())					\
-			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
-	} while (0)
-#endif
-#else
 __printf(2, 3)
 void __brcmf_err(const char *func, const char *fmt, ...);
 #define brcmf_err(fmt, ...) \
 	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
-#endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 __printf(3, 4)
-- 
2.11.0
