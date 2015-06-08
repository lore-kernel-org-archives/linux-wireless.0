Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34842 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbFHMil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:38:41 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/4] brcmfmac: remove watchdog reset from brcmf_pcie_buscoreprep()
Date: Mon, 8 Jun 2015 14:38:34 +0200
Message-ID: <1433767115-8136-4-git-send-email-arend@broadcom.com> (sfid-20150608_143850_317965_6B92958F)
In-Reply-To: <1433767115-8136-1-git-send-email-arend@broadcom.com>
References: <1433767115-8136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog reset as done in brcmf_pcie_buscoreprep() is not
sufficient. It needs to modify PCIe core registers as well
which is properly done by brcmf_pcie_reset_device() after the
chip recognition is done. So the faulty watchdog reset can be
removed as it was causing driver reload to fail and hang the
system requiring a power-cycle. Instead the call to to the
brcmf_pcie_reset_device() function is done twice in the unload.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 37a2624..3a98c43 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -1629,20 +1629,7 @@ static void brcmf_pcie_buscore_write32(void *ctx, u32 addr, u32 value)
 
 static int brcmf_pcie_buscoreprep(void *ctx)
 {
-	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)ctx;
-	int err;
-
-	err = brcmf_pcie_get_resource(devinfo);
-	if (err == 0) {
-		/* Set CC watchdog to reset all the cores on the chip to bring
-		 * back dongle to a sane state.
-		 */
-		brcmf_pcie_buscore_write32(ctx, CORE_CC_REG(SI_ENUM_BASE,
-							    watchdog), 4);
-		msleep(100);
-	}
-
-	return err;
+	return brcmf_pcie_get_resource(ctx);
 }
 
 
@@ -1824,6 +1811,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 		brcmf_pcie_intr_disable(devinfo);
 
 	brcmf_detach(&pdev->dev);
+	brcmf_pcie_reset_device(devinfo);
 
 	kfree(bus->bus_priv.pcie);
 	kfree(bus->msgbuf->flowrings);
-- 
1.9.1

