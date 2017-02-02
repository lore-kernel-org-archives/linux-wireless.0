Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34410 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBBVdk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:40 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so46661lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:39 -0800 (PST)
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
Subject: [PATCH V3 3/9] brcmfmac: merge two remaining brcmf_err macros
Date: Thu,  2 Feb 2017 22:33:15 +0100
Message-Id: <20170202213321.11591-3-zajec5@gmail.com> (sfid-20170202_223358_399752_F7D50B2E)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Now we always have __brcmf_err function we can do perfectly fine with
just one macro.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V3: Add this (new) patch
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 441a6661eac0..066126123e96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -47,20 +47,16 @@
 
 __printf(2, 3)
 void __brcmf_err(const char *func, const char *fmt, ...);
-#ifndef CONFIG_BRCM_TRACING
-/* Macro for error messages. net_ratelimit() is used when driver
- * debugging is not selected. When debugging the driver error
- * messages are as important as other tracing or even more so.
+/* Macro for error messages. When debugging / tracing the driver all error
+ * messages are important to us.
  */
 #define brcmf_err(fmt, ...)						\
 	do {								\
-		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
+		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
+		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
+		    net_ratelimit())					\
 			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
 	} while (0)
-#else
-#define brcmf_err(fmt, ...) \
-	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
-#endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 __printf(3, 4)
-- 
2.11.0
