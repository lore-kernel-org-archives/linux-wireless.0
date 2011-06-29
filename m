Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1913 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab1F2Xst (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:49 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 112/119] staging: brcm80211: removed last amd64 compiler
 warnings
Date: Wed, 29 Jun 2011 16:48:16 -0700
Message-ID: <1309391303-22741-113-git-send-email-frankyl@broadcom.com> (sfid-20110630_015047_201008_1406EF80)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Warnings were due to pointer declarations being used for an
address that does not reside on the CPU bus.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    4 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    6 +++---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   20 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    6 +++---
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 84d1bcd..cecb291 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -67,7 +67,7 @@ struct brcmf_sdio_card {
 static struct brcmf_sdio_card *l_card;
 
 struct brcmf_sdio_card*
-brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
+brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
 {
 	struct brcmf_sdio_card *card;
 
@@ -88,7 +88,7 @@ brcmf_sdcard_attach(void *cfghdl, void **regsva, uint irq)
 
 	card->init_success = true;
 
-	*regsva = (u32 *) SI_ENUM_BASE;
+	*regsva = SI_ENUM_BASE;
 
 	/* Report the BAR, to fix if needed */
 	card->sbwad = SI_ENUM_BASE;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 45fb76e..ec7d79d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(brcmf_sdio_remove);
 int brcmf_sdio_probe(struct device *dev)
 {
 	struct sdio_hc *sdhc = NULL;
-	unsigned long regs = 0;
+	u32 regs = 0;
 	struct brcmf_sdio_card *card = NULL;
 	int irq = 0;
 	u32 vendevid;
@@ -82,7 +82,7 @@ int brcmf_sdio_probe(struct device *dev)
 	}
 	sdhc->dev = (void *)dev;
 
-	card = brcmf_sdcard_attach((void *)0, (void **)&regs, irq);
+	card = brcmf_sdcard_attach((void *)0, &regs, irq);
 	if (!card) {
 		SDLX_MSG(("%s: attach failed\n", __func__));
 		goto err;
@@ -101,7 +101,7 @@ int brcmf_sdio_probe(struct device *dev)
 
 	/* try to attach to the target device */
 	sdhc->ch = drvinfo.attach((vendevid >> 16), (vendevid & 0xFFFF),
-				  0, 0, 0, 0, (void *)regs, card);
+				  0, 0, 0, 0, regs, card);
 	if (!sdhc->ch) {
 		SDLX_MSG(("%s: device attach failed\n", __func__));
 		goto err;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1b55e56..4c0a031 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -694,7 +694,7 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 		 * is supposed to give
 		 * us something we can work with.
 		 */
-		ASSERT(((u32) (pkt->data) & DMA_ALIGN_MASK) == 0);
+		ASSERT(((ulong) (pkt->data) & DMA_ALIGN_MASK) == 0);
 
 		if ((write) && (!fifo)) {
 			err_ret = sdio_memcpy_toio(gInstance->func[func], addr,
@@ -789,7 +789,7 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 			memcpy(buffer, mypkt->data, buflen_u);
 
 		brcmu_pkt_buf_free_skb(mypkt);
-	} else if (((u32) (pkt->data) & DMA_ALIGN_MASK) != 0) {
+	} else if (((ulong) (pkt->data) & DMA_ALIGN_MASK) != 0) {
 		/* Case 2: We have a packet, but it is unaligned. */
 
 		/* In this case, we cannot have a chain. */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9bc47a4..cdc57f9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -884,7 +884,7 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_disconnect(void *ptr);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
 static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card,
-				 void *regsva, u16 devid);
+				      u32 regsva, u16 devid);
 static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card);
 static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card);
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus);
@@ -908,7 +908,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus);
 static void
 brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase);
 
-static int brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, void *regs);
+static int brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs);
 
 static void
 brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase);
@@ -5343,7 +5343,7 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 }
 
 static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
-			   u16 slot, u16 func, uint bustype, void *regsva,
+			   u16 slot, u16 func, uint bustype, u32 regsva,
 			   void *card)
 {
 	int ret;
@@ -5374,7 +5374,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	DHD_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
 
 	/* We make assumptions about address window mappings */
-	ASSERT((unsigned long)regsva == SI_ENUM_BASE);
+	ASSERT(regsva == SI_ENUM_BASE);
 
 	/* SDIO car passes venid and devid based on CIS parsing -- but
 	 * low-power start
@@ -5540,7 +5540,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, void *regsva,
+brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 			  u16 devid)
 {
 	u8 clkctl = 0;
@@ -6097,8 +6097,8 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 
 			/* Attempt to re-attach & download */
 			if (brcmf_sdbrcm_probe_attach(bus, bus->card,
-						 (u32 *) SI_ENUM_BASE,
-						 bus->cl_devid)) {
+						      SI_ENUM_BASE,
+						      bus->cl_devid)) {
 				/* Attempt to download binary to the dongle */
 				if (brcmf_sdbrcm_probe_init(bus, bus->card)) {
 					/* Re-init bus, enable F2 transfer */
@@ -6126,7 +6126,7 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 
 static int
 brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
-			      struct chip_info *ci, void *regs)
+			      struct chip_info *ci, u32 regs)
 {
 	u32 regdata;
 
@@ -6136,7 +6136,7 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_card *card,
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
 	 * other ways of recognition should be added here.
 	 */
-	ci->cccorebase = (u32)regs;
+	ci->cccorebase = regs;
 	regdata = brcmf_sdcard_reg_read(card,
 				CORE_CC_REG(ci->cccorebase, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
@@ -6263,7 +6263,7 @@ brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase)
 }
 
 static int
-brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, void *regs)
+brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 {
 	struct chip_info *ci;
 	int err;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 68a2a64..9b3c149 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -52,8 +52,8 @@ struct brcmf_sdio_card;
  *    implementation may maintain a single "default" handle (e.g. the first or
  *    most recent one) to enable single-instance implementations to pass NULL.
  */
-extern struct brcmf_sdio_card *brcmf_sdcard_attach(void *cfghdl, void **regsva,
-					  uint irq);
+extern struct brcmf_sdio_card*
+brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq);
 
 /* Detach - freeup resources allocated in attach */
 extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
@@ -174,7 +174,7 @@ extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 struct brcmf_sdioh_driver {
 	/* attach to device */
 	void *(*attach) (u16 vend_id, u16 dev_id, u16 bus, u16 slot,
-			 u16 func, uint bustype, void *regsva, void *param);
+			 u16 func, uint bustype, u32 regsva, void *param);
 	/* detach from device */
 	void (*detach) (void *ch);
 };
-- 
1.7.1


