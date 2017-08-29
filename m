Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:55935
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751236AbdH2MRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:07 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/5] qtnfmac: drop -D__CHECK_ENDIAN from cflags
Date: Tue, 29 Aug 2017 15:16:19 +0300
Message-Id: <20170829121623.24761-2-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141715_924177_A686CEB2)
In-Reply-To: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag -D__CHECK_ENDIAN was wrong: it should be -D__CHECK_ENDIAN__ instead.
However now this flag is enabled by default, so it can be removed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
index 0d618e5e5f5b..f236b7dc2be3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -25,7 +25,3 @@ qtnfmac_pearl_pcie-objs += \
 	pearl/pcie.o
 
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) += debug.o
-
-#
-
-ccflags-y += -D__CHECK_ENDIAN
-- 
2.11.0
