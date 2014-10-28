Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:40498 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJ1N7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:59:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/16] brcmfmac: (clean) Move tracepoint related function.
Date: Tue, 28 Oct 2014 14:56:12 +0100
Message-ID: <1414504579-12562-10-git-send-email-arend@broadcom.com> (sfid-20141028_145941_384035_2F714F6F)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

__brcmf_err is a tracepoint specific function. Move it to
tracepoint.c.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c | 15 ---------------
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 6028fc4..98bc222 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -201,21 +201,6 @@ done:
 	return err;
 }
 
-#ifdef CONFIG_BRCM_TRACING
-void __brcmf_err(const char *func, const char *fmt, ...)
-{
-	struct va_format vaf = {
-		.fmt = fmt,
-	};
-	va_list args;
-
-	va_start(args, fmt);
-	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
-	trace_brcmf_err(func, &vaf);
-	va_end(args);
-}
-#endif
 #if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
 void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
index b505db4..b4cdccd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
@@ -19,4 +19,20 @@
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
 #include "tracepoint.h"
+
+void __brcmf_err(const char *func, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	pr_err("%s: %pV", func, &vaf);
+	trace_brcmf_err(func, &vaf);
+	va_end(args);
+}
+
 #endif
+
-- 
1.9.1

