Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2362 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbCKPLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: assure device is ready for download after brcmf_chip_attach()
Date: Wed, 11 Mar 2015 16:11:30 +0100
Message-ID: <1426086693-13876-5-git-send-email-arend@broadcom.com> (sfid-20150311_161146_798361_B017B893)
In-Reply-To: <1426086693-13876-1-git-send-email-arend@broadcom.com>
References: <1426086693-13876-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the brcmf_chip_attach() function responsible for putting the
device in a state where it is accessible for firmware download.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 8 ++------
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 2 --
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 3 ---
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index d68e37d..c11137e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -786,12 +786,6 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 	if (chip->ops->setup)
 		ret = chip->ops->setup(chip->ctx, pub);
 
-	/*
-	 * Make sure any on-chip ARM is off (in case strapping is wrong),
-	 * or downloaded code was already running.
-	 */
-	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CM3);
-	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CR4);
 	return ret;
 }
 
@@ -833,6 +827,8 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 	if (err < 0)
 		goto fail;
 
+	/* assure chip is passive for download */
+	brcmf_chip_set_passive(&chip->pub);
 	return &chip->pub;
 
 fail:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 81e544f..aa7a4df 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -509,8 +509,6 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_enter_download_state(struct brcmf_pciedev_info *devinfo)
 {
-	brcmf_chip_set_passive(devinfo->ci);
-
 	if (devinfo->ci->chip == BRCM_CC_43602_CHIP_ID) {
 		brcmf_pcie_select_core(devinfo, BCMA_CORE_ARM_CR4);
 		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_ARMCR4REG_BANKIDX,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index fff3b26..c783c25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -3356,9 +3356,6 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	sdio_claim_host(bus->sdiodev->func[1]);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
-	/* Keep arm in reset */
-	brcmf_chip_set_passive(bus->ci);
-
 	rstvec = get_unaligned_le32(fw->data);
 	brcmf_dbg(SDIO, "firmware rstvec: %x\n", rstvec);
 
-- 
1.9.1

