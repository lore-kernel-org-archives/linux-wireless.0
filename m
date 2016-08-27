Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34684 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbcH0GOJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 02:14:09 -0400
Received: by mail-pf0-f170.google.com with SMTP id p64so35132181pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2016 23:14:08 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org
Cc: baoyou.xie@linaro.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@linaro.org,
        xie.baoyou@zte.com.cn
Subject: [PATCH v2] fix:brcmfmac: add missing header dependencies
Date: Sat, 27 Aug 2016 14:08:23 +0800
Message-Id: <1472278103-28320-1-git-send-email-baoyou.xie@linaro.org> (sfid-20160827_081436_583793_923234D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get 1 warning when biuld kernel with W=1:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:23:6: warning: no previous prototype for '__brcmf_err' [-Wmissing-
prototypes]

In fact, this function is declared in brcmfmac/debug.h, so this patch
add missing header dependencies

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
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
