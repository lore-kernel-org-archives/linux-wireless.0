Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3703 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/16] brcm80211: fmac: disable dongle arm core in bus
 core setup function
Date: Fri, 4 Nov 2011 22:23:32 +0100
Message-ID: <1320441822-4615-7-git-send-email-arend@broadcom.com> (sfid-20111104_222411_744423_B139487B)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This will provide a better code flow that fits the logic

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 ------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index af0d5c9..c98986f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3885,12 +3885,6 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	if (err)
 		goto fail;
 
-	/*
-	 * Make sure any on-chip ARM is off (in case strapping is wrong),
-	 * or downloaded code was already running.
-	 */
-	brcmf_sdio_chip_coredisable(bus->sdiodev, ci->armcorebase);
-
 	brcmf_sdcard_reg_write(bus->sdiodev,
 		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
 	brcmf_sdcard_reg_write(bus->sdiodev,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index f198a48..486f145 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -243,6 +243,12 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
 		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
+
+	/*
+	 * Make sure any on-chip ARM is off (in case strapping is wrong),
+	 * or downloaded code was already running.
+	 */
+	brcmf_sdio_chip_coredisable(sdiodev, ci->armcorebase);
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.4.1


