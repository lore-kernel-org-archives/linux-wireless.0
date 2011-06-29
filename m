Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4455 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab1F2Xsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:39 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 009/119] staging: brcm80211: remove unused files from
 fullmac
Date: Wed, 29 Jun 2011 16:46:33 -0700
Message-ID: <1309391303-22741-10-git-send-email-frankyl@broadcom.com> (sfid-20110630_014857_160099_249B410C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

aiutils.c and pcicfg.h are no longer needed by fullmac

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/aiutils.c |    1 -
 drivers/staging/brcm80211/brcmfmac/pcicfg.h  |   50 --------------------------
 2 files changed, 0 insertions(+), 51 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/aiutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/pcicfg.h

diff --git a/drivers/staging/brcm80211/brcmfmac/aiutils.c b/drivers/staging/brcm80211/brcmfmac/aiutils.c
deleted file mode 100644
index e648086..0000000
--- a/drivers/staging/brcm80211/brcmfmac/aiutils.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../util/aiutils.c"
diff --git a/drivers/staging/brcm80211/brcmfmac/pcicfg.h b/drivers/staging/brcm80211/brcmfmac/pcicfg.h
deleted file mode 100644
index 3258449..0000000
--- a/drivers/staging/brcm80211/brcmfmac/pcicfg.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef	_h_pcicfg_
-#define	_h_pcicfg_
-
-#include <linux/pci_regs.h>
-
-/* PCI configuration address space size */
-#define PCI_SZPCR		256
-
-/* Everything below is Broadcom specific */
-
-/* Brcm PCI configuration registers */
-#define PCI_BAR0_WIN		0x80	/* backplane address space accessed by BAR0 */
-#define PCI_SPROM_CONTROL	0x88	/* sprom property control */
-#define PCI_INT_MASK		0x94	/* mask of PCI and other cores interrupts */
-#define  PCI_SBIM_SHIFT		8	/* backplane core interrupt mask bits offset */
-#define PCI_BAR0_WIN2		0xac	/* backplane address space accessed by second 4KB of BAR0 */
-#define PCI_GPIO_IN		0xb0	/* pci config space gpio input (>=rev3) */
-#define PCI_GPIO_OUT		0xb4	/* pci config space gpio output (>=rev3) */
-#define PCI_GPIO_OUTEN		0xb8	/* pci config space gpio output enable (>=rev3) */
-
-#define PCI_BAR0_SPROM_OFFSET	(4 * 1024)	/* bar0 + 4K accesses external sprom */
-#define PCI_BAR0_PCIREGS_OFFSET	(6 * 1024)	/* bar0 + 6K accesses pci core registers */
-#define PCI_BAR0_PCISBR_OFFSET	(4 * 1024)	/* pci core SB registers are at the end of the
-						 * 8KB window, so their address is the "regular"
-						 * address plus 4K
-						 */
-#define PCI_BAR0_WINSZ		(16 * 1024)	/* bar0 window size Match with corerev 13 */
-/* On pci corerev >= 13 and all pcie, the bar0 is now 16KB and it maps: */
-#define PCI_16KB0_PCIREGS_OFFSET (8 * 1024)	/* bar0 + 8K accesses pci/pcie core registers */
-#define PCI_16KB0_CCREGS_OFFSET	(12 * 1024)	/* bar0 + 12K accesses chipc core registers */
-
-#define PCI_SBIM_STATUS_SERR	0x4	/* backplane SBErr interrupt status */
-
-#endif				/* _h_pcicfg_ */
-- 
1.7.1


