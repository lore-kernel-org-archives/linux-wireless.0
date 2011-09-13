Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2993 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/17] staging: brcm80211: added clarification on
 softmac dma alignment
Date: Tue, 13 Sep 2011 09:49:49 +0200
Message-ID: <1315900197-7260-10-git-send-email-rvossen@broadcom.com> (sfid-20110913_095057_596784_0AE808D8)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Descriptor ring can only start at 8KB alignment, this requirement
is dictated by DMA hardware.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 6c9b1fe..06990b3 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -24,8 +24,8 @@
 #include "dma.h"
 
 /*
- * Each descriptor ring must be 8kB aligned, and fit within a
- * contiguous 8kB physical address.
+ * DMA hardware requires each descriptor ring to be 8kB aligned, and fit within
+ * a contiguous 8kB physical address.
  */
 #define D64RINGALIGN_BITS	13
 #define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
@@ -440,6 +440,10 @@ static bool _dma_descriptor_align(struct dma_info *di)
 	return true;
 }
 
+/*
+ * Descriptor table must start at the DMA hardware dictated alignment, so
+ * allocated memory must be large enough to support this requirement.
+ */
 static void *dma_alloc_consistent(struct pci_dev *pdev, uint size,
 				  u16 align_bits, uint *alloced,
 				  dma_addr_t *pap)
-- 
1.7.4.1


