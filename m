Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:2021 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaFFVyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 17:54:44 -0400
From: Arend van Spriel <arend@broadcom.com>
To: <stable@vger.kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to BCMA_IOCTL
Date: Fri, 6 Jun 2014 23:54:31 +0200
Message-ID: <1402091675-6515-1-git-send-email-arend@broadcom.com> (sfid-20140606_235448_913210_2D5D4C19)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

brcmfmac has been broken on my cubietruck with a BCM43362:

brcmfmac: brcmf_chip_recognition: found AXI chip: BCM43362, rev=1
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
        Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d

since commit 53036261033: "brcmfmac: update core reset and disable routines".

The problem is that since this commit brcmf_chip_ai_resetcore no longer sets
BCMA_IOCTL itself before bringing the core out of reset, instead relying on
brcmf_chip_ai_coredisable to do so. But brcmf_chip_ai_coredisable is a nop
of the chip is already in reset. This patch modifies brcmf_chip_ai_coredisable
to always set BCMA_IOCTL even if the core is already in reset.

This fixes brcmfmac hanging in firmware loading on my board.

upstream: 75691d9e4f4e156f71f3eaee69a5bd27b7b10384

Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[arend@broadcom.com: rebase patch on linux-3.14.y branch]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 82bf3c5..2de2736 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -300,10 +300,10 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 	wrapbase = ci->c_inf[idx].wrapbase;
 
-	/* if core is already in reset, just return */
+	/* if core is already in reset, skip reset */
 	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
-		return;
+		goto post_reset_config;
 
 	/* configure reset */
 	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
@@ -319,6 +319,7 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	SPINWAIT(brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL) !=
 		 BCMA_RESET_CTL_RESET, 300);
 
+post_reset_config:
 	/* post reset configure */
 	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
 			  BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
-- 
1.9.1

