Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34398 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBBVdg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:36 -0500
Received: by mail-lf0-f66.google.com with SMTP id q89so46565lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:36 -0800 (PST)
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
Subject: [PATCH V3 1/9] brcmfmac: merge two brcmf_err macros into one
Date: Thu,  2 Feb 2017 22:33:13 +0100
Message-Id: <20170202213321.11591-1-zajec5@gmail.com> (sfid-20170202_223357_807426_63BBE980)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This allows simplifying the code by adding a simple IS_ENABLED check for
CONFIG_BRCMDB symbol.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V3: Re-add this patch (it was initially submited as RFC)
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 6687812770cc..1fe4aa973a92 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -45,20 +45,16 @@
 #undef pr_fmt
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
+#ifndef CONFIG_BRCM_TRACING
 /* Macro for error messages. net_ratelimit() is used when driver
  * debugging is not selected. When debugging the driver error
  * messages are as important as other tracing or even more so.
  */
-#ifndef CONFIG_BRCM_TRACING
-#ifdef CONFIG_BRCMDBG
-#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
-#else
 #define brcmf_err(fmt, ...)						\
 	do {								\
-		if (net_ratelimit())					\
+		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
 			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
 	} while (0)
-#endif
 #else
 __printf(2, 3)
 void __brcmf_err(const char *func, const char *fmt, ...);
-- 
2.11.0
