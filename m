Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25022 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752204AbdKWP5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 10:57:09 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] brcmfmac: Avoid build error with make W=1
Date: Thu, 23 Nov 2017 17:57:04 +0200
Message-Id: <20171123155704.44878-1-andriy.shevchenko@linux.intel.com> (sfid-20171123_165718_644768_5FA8B558)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I run make W=1 on gcc (Debian 7.2.0-16) 7.2.0 I got an error for
the first run, all next ones are okay.

  CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o
drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:2078: error: Cannot parse struct or union!
scripts/Makefile.build:310: recipe for target 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.o' failed

Seems like something happened with W=1 and wrong kernel doc format.
As a quick fix remove dubious /** in the code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e3495ea95553..870e00cea29c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2070,7 +2070,7 @@ static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 	return head_pad;
 }
 
-/**
+/*
  * struct brcmf_skbuff_cb reserves first two bytes in sk_buff::cb for
  * bus layer usage.
  */
-- 
2.15.0
