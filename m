Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4294 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1GEUGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 15/21] staging: brcm80211: got rid of redundant
 member 'regs' of struct dhd_bus
Date: Tue, 5 Jul 2011 22:06:11 +0200
Message-ID: <1309896377-4425-16-git-send-email-arend@broadcom.com> (sfid-20110705_220643_299335_0151F039)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Decreases amd64 compiler warnings.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9ac256e..9bc47a4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -552,8 +552,6 @@ struct brcmf_bus {
 	uint varsz;		/* Size of variables buffer */
 	u32 sbaddr;		/* Current SB window pointer (-1, invalid) */
 
-	/* SDIO core, 32 bit address on the backplane bus: */
-	struct sdpcmd_regs *regs;
 	uint sdpcmrev;		/* SDIO core revision */
 	uint armrev;		/* CPU core revision */
 	uint ramrev;		/* SOCRAM core revision */
@@ -2725,7 +2723,7 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 
 			sd_ptr = (struct brcmf_sdreg *) params;
 
-			addr = (unsigned long)bus->regs + sd_ptr->offset;
+			addr = bus->ci->buscorebase + sd_ptr->offset;
 			size = sd_ptr->func;
 			int_val = (s32) brcmf_sdcard_reg_read(bus->card, addr,
 							      size);
@@ -2742,7 +2740,7 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 
 			sd_ptr = (struct brcmf_sdreg *) params;
 
-			addr = (unsigned long)bus->regs + sd_ptr->offset;
+			addr = bus->ci->buscorebase + sd_ptr->offset;
 			size = sd_ptr->func;
 			brcmf_sdcard_reg_write(bus->card, addr, size,
 					       sd_ptr->value);
@@ -5610,10 +5608,10 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, void *regsva,
 			   bus->ramsize, bus->orig_ramsize));
 	}
 
-	bus->regs = (void *)bus->ci->buscorebase;
-
 	/* Set core control so an SDIO reset does a backplane reset */
-	OR_REG((u32)&bus->regs->corecontrol, CC_BPRESEN, u32);
+	OR_REG(bus->ci->buscorebase + offsetof(struct sdpcmd_regs,
+						       corecontrol),
+	       CC_BPRESEN, u32);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
-- 
1.7.4.1


