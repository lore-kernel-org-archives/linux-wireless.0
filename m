Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbaDWKVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 06:21:09 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>,
	stable@vger.kernel.org.#.v3.14
Subject: [PATCH] brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to BCMA_IOCTL
Date: Wed, 23 Apr 2014 12:20:55 +0200
Message-Id: <1398248455-16175-1-git-send-email-hdegoede@redhat.com> (sfid-20140423_122117_346135_4EDD58B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index df130ef..c7c9f15 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -303,10 +303,10 @@ static void brcmf_chip_ai_coredisable(struct brcmf_core_priv *core,
 
 	ci = core->chip;
 
-	/* if core is already in reset, just return */
+	/* if core is already in reset, skip reset */
 	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
-		return;
+		goto in_reset_configure;
 
 	/* configure reset */
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
@@ -322,6 +322,7 @@ static void brcmf_chip_ai_coredisable(struct brcmf_core_priv *core,
 	SPINWAIT(ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) !=
 		 BCMA_RESET_CTL_RESET, 300);
 
+in_reset_configure:
 	/* in-reset configure */
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
 			 reset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
-- 
1.9.0

