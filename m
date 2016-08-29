Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34921 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbcH2Mj4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 08:39:56 -0400
Received: by mail-pf0-f173.google.com with SMTP id x72so51902351pfd.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2016 05:39:55 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn
Subject: [PATCH v4] brcmfmac: add missing header dependencies
Date: Mon, 29 Aug 2016 20:39:35 +0800
Message-Id: <1472474375-29910-1-git-send-email-baoyou.xie@linaro.org> (sfid-20160829_144015_674829_0A5785F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get 1 warning when build kernel with W=1:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6: warning: no previous prototype for '__brcmf_err' [-Wmissing-prototypes]

In fact, this function is declared in brcmfmac/debug.h, so this patch
add missing header dependencies.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
index a10f35c..fe67559 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -19,6 +19,7 @@
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
 #include "tracepoint.h"
+#include "debug.h"
 
 void __brcmf_err(const char *func, const char *fmt, ...)
 {
-- 
2.7.4
