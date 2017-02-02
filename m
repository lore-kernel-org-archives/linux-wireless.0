Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33315 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBBVdi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:38 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so50119lff.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:38 -0800 (PST)
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
Subject: [PATCH V3 2/9] brcmfmac: switch to C function (__brcmf_err) for printing errors
Date: Thu,  2 Feb 2017 22:33:14 +0100
Message-Id: <20170202213321.11591-2-zajec5@gmail.com> (sfid-20170202_223358_096347_4E876275)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This will allow extending code and using more detailed messages e.g.
with the help of dev_err.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V3: Keep IS_ENABLED check in the macro as suggested by Felix
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.c    | 16 ++++++++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h |  6 +++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index f7c8c2e80349..33b133f7e63a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -218,6 +218,22 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	return err;
 }
 
+#ifndef CONFIG_BRCM_TRACING
+void __brcmf_err(const char *func, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
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
index 1fe4aa973a92..441a6661eac0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -45,6 +45,8 @@
 #undef pr_fmt
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
+__printf(2, 3)
+void __brcmf_err(const char *func, const char *fmt, ...);
 #ifndef CONFIG_BRCM_TRACING
 /* Macro for error messages. net_ratelimit() is used when driver
  * debugging is not selected. When debugging the driver error
@@ -53,11 +55,9 @@
 #define brcmf_err(fmt, ...)						\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
-			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
+			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
 	} while (0)
 #else
-__printf(2, 3)
-void __brcmf_err(const char *func, const char *fmt, ...);
 #define brcmf_err(fmt, ...) \
 	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
 #endif
-- 
2.11.0
