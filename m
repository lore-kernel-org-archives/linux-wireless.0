Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4812 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/13] staging: brcm80211: bugfix for 32 bit power pc
 platform
Date: Fri, 26 Aug 2011 15:19:36 +0200
Message-ID: <1314364780-9462-10-git-send-email-rvossen@broadcom.com> (sfid-20110826_152023_346123_2F3815BD)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms resource_size_t == 64 but but unsigned long is only 32-bits.
In this particular problem, reported and fixed by Tony Breeds, a physical
address was truncated as a result.

Reported-by: Tony Breeds <tony@bakeyournoodle.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 2370171..9b787e6 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -752,12 +752,11 @@ static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
  * is called in brcms_pci_probe() context, therefore no locking required.
  */
 static struct brcms_info *brcms_attach(u16 vendor, u16 device,
-				       unsigned long regs,
+				       resource_size_t regs,
 				       struct pci_dev *btparam, uint irq)
 {
 	struct brcms_info *wl = NULL;
 	int unit, err;
-	unsigned long base_addr;
 	struct ieee80211_hw *hw;
 	u8 perm[ETH_ALEN];
 
@@ -780,11 +779,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	/* setup the bottom half handler */
 	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
 
-
-
-	base_addr = regs;
-
-	wl->regsva = ioremap_nocache(base_addr, PCI_BAR0_WINSZ);
+	wl->regsva = ioremap_nocache(regs, PCI_BAR0_WINSZ);
 	if (wl->regsva == NULL) {
 		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
 		goto fail;
-- 
1.7.4.1


