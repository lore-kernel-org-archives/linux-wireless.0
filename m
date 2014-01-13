Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:46553 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaAMVUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: rework firmware download code
Date: Mon, 13 Jan 2014 22:20:25 +0100
Message-ID: <1389648029-23560-5-git-send-email-arend@broadcom.com> (sfid-20140113_222053_288441_FFC35D9E)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware download code has been restructured so the reset vector
does not need to be stored in a structure, but keep it on the stack
to be passed to exit download function.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   87 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   11 +--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    2 +-
 3 files changed, 40 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1905789..b9d5f73 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3192,30 +3192,6 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static bool brcmf_sdio_download_state(struct brcmf_sdio *bus, bool enter)
-{
-	struct chip_info *ci = bus->ci;
-
-	/* To enter download state, disable ARM and reset SOCRAM.
-	 * To exit download state, simply reset ARM (default is RAM boot).
-	 */
-	if (enter) {
-		bus->alp_only = true;
-
-		brcmf_sdio_chip_enter_download(bus->sdiodev, ci);
-	} else {
-		if (!brcmf_sdio_chip_exit_download(bus->sdiodev, ci))
-			return false;
-
-		/* Allow HT Clock now that the ARM is running. */
-		bus->alp_only = false;
-
-		bus->sdiodev->bus_if->state = BRCMF_BUS_LOAD;
-	}
-
-	return true;
-}
-
 #ifdef DEBUG
 static bool
 brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
@@ -3270,9 +3246,9 @@ brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
 }
 #endif	/* DEBUG */
 
-static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
+					 const struct firmware *fw)
 {
-	const struct firmware *fw;
 	int err;
 	int offset;
 	int address;
@@ -3280,14 +3256,6 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
-	if (fw == NULL)
-		return -ENOENT;
-
-	if (brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_ARM_CR4) !=
-	    BRCMF_MAX_CORENUM)
-		memcpy(&bus->ci->rst_vec, fw->data, sizeof(bus->ci->rst_vec));
-
 	err = 0;
 	offset = 0;
 	address = bus->ci->rambase;
@@ -3299,7 +3267,7 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 		if (err) {
 			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
 				  err, len, address);
-			goto failure;
+			return err;
 		}
 		offset += len;
 		address += len;
@@ -3309,15 +3277,12 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus)
 					     (u8 *)fw->data, fw->size))
 			err = -EIO;
 
-failure:
-	release_firmware(fw);
-
 	return err;
 }
 
-static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus)
+static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
+				     const struct firmware *nv)
 {
-	const struct firmware *nv;
 	void *vars;
 	u32 varsz;
 	int address;
@@ -3325,12 +3290,7 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	nv = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
-	if (nv == NULL)
-		return -ENOENT;
-
 	vars = brcmf_nvram_strip(nv, &varsz);
-	release_firmware(nv);
 
 	if (vars == NULL)
 		return -EINVAL;
@@ -3351,33 +3311,52 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus)
 static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 {
 	int bcmerror = -EFAULT;
-
+	const struct firmware *fw;
+	u32 rstvec;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	/* Keep arm in reset */
-	if (!brcmf_sdio_download_state(bus, true)) {
-		brcmf_err("error placing ARM core in reset\n");
+	brcmf_sdio_chip_enter_download(bus->sdiodev, bus->ci);
+
+	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
+	if (fw == NULL) {
+		bcmerror = -ENOENT;
 		goto err;
 	}
 
-	if (brcmf_sdio_download_code_file(bus)) {
+	rstvec = get_unaligned_le32(fw->data);
+	brcmf_dbg(SDIO, "firmware rstvec: %x\n", rstvec);
+
+	bcmerror = brcmf_sdio_download_code_file(bus, fw);
+	release_firmware(fw);
+	if (bcmerror) {
 		brcmf_err("dongle image file download failed\n");
 		goto err;
 	}
 
-	if (brcmf_sdio_download_nvram(bus)) {
+	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_NVRAM);
+	if (fw == NULL) {
+		bcmerror = -ENOENT;
+		goto err;
+	}
+
+	bcmerror = brcmf_sdio_download_nvram(bus, fw);
+	release_firmware(fw);
+	if (bcmerror) {
 		brcmf_err("dongle nvram file download failed\n");
 		goto err;
 	}
 
 	/* Take arm out of reset */
-	if (!brcmf_sdio_download_state(bus, false)) {
+	if (!brcmf_sdio_chip_exit_download(bus->sdiodev, bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
 		goto err;
 	}
 
+	/* Allow HT Clock now that the ARM is running. */
+	bus->sdiodev->bus_if->state = BRCMF_BUS_LOAD;
 	bcmerror = 0;
 
 err:
@@ -3566,9 +3545,11 @@ static int brcmf_sdio_bus_init(struct device *dev)
 
 	/* try to download image and nvram to the dongle */
 	if (bus_if->state == BRCMF_BUS_DOWN) {
+		bus->alp_only = true;
 		err = brcmf_sdio_download_firmware(bus);
 		if (err)
 			return err;
+		bus->alp_only = false;
 	}
 
 	if (!bus->sdiodev->bus_if->drvr)
@@ -3778,8 +3759,6 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	u32 reg_val;
 	u32 drivestrength;
 
-	bus->alp_only = true;
-
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
@@ -4088,7 +4067,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 			 * essentially resets all necessary cores
 			 */
 			msleep(20);
-			brcmf_sdio_download_state(bus, true);
+			brcmf_sdio_chip_enter_download(bus->sdiodev, bus->ci);
 			brcmf_sdio_clkctl(bus, CLK_NONE, false);
 			sdio_release_host(bus->sdiodev->func[1]);
 			brcmf_sdio_chip_detach(&bus->ci);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index a002af9..909d720 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -917,7 +917,8 @@ brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 }
 
 static bool
-brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
+brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+			   u32 rstvec)
 {
 	u8 core_idx;
 	u32 reg_addr;
@@ -929,8 +930,8 @@ brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
 	/* Write reset vector to address 0 */
-	brcmf_sdiod_ramrw(sdiodev, true, 0, (void *)&ci->rst_vec,
-			  sizeof(ci->rst_vec));
+	brcmf_sdiod_ramrw(sdiodev, true, 0, (void *)&rstvec,
+			  sizeof(rstvec));
 
 	/* restore ARM */
 	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, BCMA_IOCTL_ARMCR4_HALT,
@@ -954,7 +955,7 @@ void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 }
 
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci)
+				   struct chip_info *ci, u32 rstvec)
 {
 	u8 arm_core_idx;
 
@@ -962,5 +963,5 @@ bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
 	if (BRCMF_MAX_CORENUM != arm_core_idx)
 		return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci);
 
-	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci);
+	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci, rstvec);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 91c61cb..9a72b71 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -226,6 +226,6 @@ u8 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid);
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 				    struct chip_info *ci);
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci);
+				   struct chip_info *ci, u32 rstvec);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.10.4

