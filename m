Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4954 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab1HXWag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 18:30:36 -0400
Date: Wed, 24 Aug 2011 15:28:01 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824222801.GA5280@broadcom.com> (sfid-20110825_003039_378819_FA5E4138)
References: <20110707002034.GA17885@broadcom.com>
MIME-Version: 1.0
In-Reply-To: <20110707002034.GA17885@broadcom.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the latest series of cleanup patches merged in by Greg KH, I'd like to
once again propose moving brcm80211 out of staging and into mainline.

I've put together a patch to add a copy of the current sources from
staging-next into wireless-testing:drivers/net/wireless/brcm80211.

The patch is somewhat large, so I've posted the patch at:

http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch

Changes from the previous version:

V2:
- Resolve checkpatch issues
- Fix issues on big-endian platforms (MIPS BE, PPC, and SPARC)
- Cleanup architecture-specific code
- Fix power save, locking, and scan issues in brcmfmac
- Elimimnate 'void *' casts in brcmsmac
- Fix entry for brcm80211 drivers in drivers/net/wireless/Kconfig
- Use cordic and crc8 kernel library functions
- General code cleanup, restructuring, and dead code removal

The only difference between these sources and the ones in staging-next are:
	- necessary Kconfig and Makefile adjustments for the new driver location
	- one cleanup of a checkpatch warning (as indicated below)

The brcmsmac driver has been verified to work on x86 (both 32- and 64-bit), PPC
(64-bit), SPARC, MIPS BE, and ARM.  The brcmfmac driver has been verified to
work on x86 32-bit and ARM (additional testing is in progress, but getting a
working sdio controller on some of the other platforms has been challenging).

The drivers compile cleanly for x86 (32- and 64-bit), PPC (32- and 64-bit),
SPAR, MIPS BE, MIPS LE, and ARM.

Thanks,
---
Henry Ptasinski
henryp@broadcom.com


diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm8021
index 05dad9f..73e5841 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -815,7 +815,7 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
                tail = head;
                while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
                        tail->next = p;
-                       pkt_len = min(resid, (int)di->rxbufsize);
+                       pkt_len = min_t(int, resid, (int)di->rxbufsize);
                        __skb_trim(p, pkt_len);
 
                        tail = p;


