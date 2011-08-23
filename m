Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1815 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/8] staging: brcm80211: bugfix for fifo problem on 64
 bits platforms.
Date: Tue, 23 Aug 2011 14:13:59 +0200
Message-ID: <1314101640-4229-8-git-send-email-arend@broadcom.com> (sfid-20110823_141429_031291_48F2B958)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Message 'receive fifo overflow' appeared in the log. Root cause was an
invalid physical address being programmed into the DMA engine. This was
caused by an invalid pointer cast in the dma code. Issue was observed on
a Sparc (Sun Fire V120) machine but could theoretically also pop up
on other architectures.

Driver was tested to scan and ping on aforementioned machine.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 2ef416a..05dad9f 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -600,13 +600,18 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
 			       uint *alloced, unsigned long *pap)
 {
+	void *rc;
+	dma_addr_t dma_addr;
+
 	if (align_bits) {
 		u16 align = (1 << align_bits);
 		if (!IS_ALIGNED(PAGE_SIZE, align))
 			size += align;
 		*alloced = size;
 	}
-	return pci_alloc_consistent(pdev, size, (dma_addr_t *) pap);
+	rc = pci_alloc_consistent(pdev, size, &dma_addr);
+	*pap = dma_addr;
+	return rc;
 }
 
 /* !! may be called with core in reset */
-- 
1.7.4.1


