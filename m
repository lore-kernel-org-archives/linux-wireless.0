Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45419 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbbCKPLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: remove duplication of ramsize info
Date: Wed, 11 Mar 2015 16:11:27 +0100
Message-ID: <1426086693-13876-2-git-send-email-arend@broadcom.com> (sfid-20150311_161144_502391_36FB0FF9)
In-Reply-To: <1426086693-13876-1-git-send-email-arend@broadcom.com>
References: <1426086693-13876-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing the ramsize from the brcmf_sdio structure to avoid
duplication. The information is available in brcmf_chip
structure.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 973fa2a..9df16c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -432,8 +432,6 @@ struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct brcmf_chip *ci;	/* Chip info struct */
 
-	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
-
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	atomic_t intstatus;	/* Intstatus bits (events) pending */
 	atomic_t fcstate;	/* State of dongle flow-control */
@@ -1075,7 +1073,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	shaddr = bus->ci->rambase + bus->ramsize - 4;
+	shaddr = bus->ci->rambase + bus->ci->ramsize - 4;
 
 	/*
 	 * Read last word in socram to determine
@@ -3871,13 +3869,6 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		drivestrength = DEFAULT_SDIO_DRIVE_STRENGTH;
 	brcmf_sdio_drivestrengthinit(bus->sdiodev, bus->ci, drivestrength);
 
-	/* Get info on the SOCRAM cores... */
-	bus->ramsize = bus->ci->ramsize;
-	if (!(bus->ramsize)) {
-		brcmf_err("failed to find SOCRAM memory!\n");
-		goto fail;
-	}
-
 	/* Set card control so an SDIO card reset does a WLAN backplane reset */
 	reg_val = brcmf_sdiod_regrb(bus->sdiodev,
 				    SDIO_CCCR_BRCM_CARDCTRL, &err);
-- 
1.9.1

