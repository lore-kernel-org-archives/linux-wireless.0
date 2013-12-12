Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:6952 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3LLK7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:15 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/18] brcmfmac: remove regs parameter from sdio probe functions
Date: Thu, 12 Dec 2013 11:58:55 +0100
Message-ID: <1386845946-9859-8-git-send-email-arend@broadcom.com> (sfid-20131212_122501_014560_5BAEE994)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip recognition requires a base address that was provided
to it during the probe. However, the address is a fixed define
value so it is unnecessary to pass through the probe functions.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c    |    5 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |   11 ++++-------
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c |    8 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h |    2 +-
 5 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8ba1b77..a56a779 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -992,17 +992,14 @@ static int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev)
 
 static int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 {
-	u32 regs = 0;
 	int ret = 0;
 
 	ret = brcmf_sdioh_attach(sdiodev);
 	if (ret)
 		goto out;
 
-	regs = SI_ENUM_BASE;
-
 	/* try to attach to the target device */
-	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
+	sdiodev->bus = brcmf_sdbrcm_probe(sdiodev);
 	if (!sdiodev->bus) {
 		brcmf_err("device attach failed\n");
 		ret = -ENODEV;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a70feb5..24d69f4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3803,7 +3803,7 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
+brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -3835,7 +3835,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		goto fail;
 	}
 
-	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci, regsva)) {
+	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci)) {
 		brcmf_err("brcmf_sdio_chip_attach failed!\n");
 		goto fail;
 	}
@@ -4037,16 +4037,13 @@ static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.gettxq = brcmf_sdbrcm_bus_gettxq,
 };
 
-void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
+void *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* We make an assumption about address window mappings:
-	 * regsva == SI_ENUM_BASE*/
-
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
 	if (!bus)
@@ -4080,7 +4077,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* attempt to attach to the dongle */
-	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
+	if (!(brcmf_sdbrcm_probe_attach(bus))) {
 		brcmf_err("brcmf_sdbrcm_probe_attach failed\n");
 		goto fail;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 2096a14..b612808d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -438,7 +438,7 @@ static inline int brcmf_sdio_chip_cichk(struct chip_info *ci)
 #endif
 
 static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
-				       struct chip_info *ci, u32 regs)
+				       struct chip_info *ci)
 {
 	u32 regdata;
 	int ret;
@@ -449,7 +449,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	 * other ways of recognition should be added here.
 	 */
 	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
-	ci->c_inf[0].base = regs;
+	ci->c_inf[0].base = SI_ENUM_BASE;
 	regdata = brcmf_sdio_regrl(sdiodev,
 				   CORE_CC_REG(ci->c_inf[0].base, chipid),
 				   NULL);
@@ -681,7 +681,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct chip_info **ci_ptr, u32 regs)
+			   struct chip_info **ci_ptr)
 {
 	int ret;
 	struct chip_info *ci;
@@ -697,7 +697,7 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	if (ret != 0)
 		goto err;
 
-	ret = brcmf_sdio_chip_recognition(sdiodev, ci, regs);
+	ret = brcmf_sdio_chip_recognition(sdiodev, ci);
 	if (ret != 0)
 		goto err;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 507c61c..d0f4b45 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -224,7 +224,7 @@ struct sdpcmd_regs {
 };
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct chip_info **ci_ptr, u32 regs);
+			   struct chip_info **ci_ptr);
 void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
 void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 				       struct chip_info *ci, u32 drivestrength);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index a1e5f72..d98b4bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -239,7 +239,7 @@ int brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 /* Issue an abort to the specified function */
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
 
-void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev);
+void *brcmf_sdbrcm_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdbrcm_disconnect(void *ptr);
 void brcmf_sdbrcm_isr(void *arg);
 
-- 
1.7.10.4

