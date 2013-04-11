Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4960 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/15] brcmfmac: add support for dongle ARM CR4 core
Date: Thu, 11 Apr 2013 13:28:51 +0200
Message-ID: <1365679740-25679-7-git-send-email-arend@broadcom.com> (sfid-20130411_133113_790728_58A25347)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Newer WiFi chip use ARM CR4 core to achieve higher performance. Add necessary
code for host driver in order to support CR4 core.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  150 +++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    6 +-
 include/linux/bcma/bcma.h                          |    1 +
 include/linux/bcma/bcma_regs.h                     |    1 +
 5 files changed, 148 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3147960..d24eb66 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2652,7 +2652,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	shaddr = bus->ramsize - 4;
+	shaddr = bus->ci->rambase + bus->ramsize - 4;
 
 	/*
 	 * Read last word in socram to determine
@@ -3030,10 +3030,11 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_sdio *bus)
 
 static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 {
-	int offset = 0;
+	int offset;
 	uint len;
 	u8 *memblock = NULL, *memptr;
 	int ret;
+	u8 idx;
 
 	brcmf_dbg(INFO, "Enter\n");
 
@@ -3054,9 +3055,14 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 		memptr += (BRCMF_SDALIGN -
 			   ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
 
+	offset = bus->ci->rambase;
+
 	/* Download image */
-	while ((len =
-		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
+	len = brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus);
+	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_ARM_CR4);
+	if (BRCMF_MAX_CORENUM != idx)
+		memcpy(&bus->ci->rst_vec, memptr, sizeof(bus->ci->rst_vec));
+	while (len) {
 		ret = brcmf_sdio_ramrw(bus->sdiodev, true, offset, memptr, len);
 		if (ret) {
 			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
@@ -3065,6 +3071,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 		}
 
 		offset += MEMBLOCK;
+		len = brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus);
 	}
 
 err:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 9818598..5db985c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -52,6 +52,9 @@
 #define CIB_REV_MASK		0xff000000
 #define CIB_REV_SHIFT		24
 
+/* ARM CR4 core specific control flag bits */
+#define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
+
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
@@ -149,7 +152,7 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid)
+			  struct chip_info *ci, u16 coreid, u32 core_bits)
 {
 	u32 regdata, base;
 	u8 idx;
@@ -235,7 +238,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid)
+			  struct chip_info *ci, u16 coreid, u32 core_bits)
 {
 	u8 idx;
 	u32 regdata;
@@ -249,19 +252,36 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
-	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL, 0, NULL);
-	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+	/* ensure no pending backplane operation
+	 * 300uc should be sufficient for backplane ops to be finish
+	 * extra 10ms is taken into account for firmware load stage
+	 * after 10300us carry on disabling the core anyway
+	 */
+	SPINWAIT(brcmf_sdio_regrl(sdiodev,
+				  ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
+				  NULL), 10300);
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
 				   NULL);
-	udelay(10);
+	if (regdata)
+		brcmf_err("disabling core 0x%x with reset status %x\n",
+			  coreid, regdata);
 
 	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
 			 BCMA_RESET_CTL_RESET, NULL);
 	udelay(1);
+
+	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+			 core_bits, NULL);
+	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
+				   NULL);
+	usleep_range(10, 20);
+
 }
 
 static void
 brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid)
+			struct chip_info *ci, u16 coreid, u32 core_bits)
 {
 	u32 regdata;
 	u8 idx;
@@ -272,7 +292,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid);
+	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid, 0);
 
 	/*
 	 * Now do the initialization sequence.
@@ -325,7 +345,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid)
+			struct chip_info *ci, u16 coreid, u32 core_bits)
 {
 	u8 idx;
 	u32 regdata;
@@ -333,28 +353,67 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	/* must disable first to work for arbitrary current core state */
-	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid);
+	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, core_bits);
 
 	/* now do initialization sequence */
 	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			 BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
+			 core_bits | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
 	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
 			 0, NULL);
+	regdata = brcmf_sdio_regrl(sdiodev,
+				   ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+				   NULL);
 	udelay(1);
 
 	brcmf_sdio_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			 BCMA_IOCTL_CLK, NULL);
+			 core_bits | BCMA_IOCTL_CLK, NULL);
 	regdata = brcmf_sdio_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
 				   NULL);
 	udelay(1);
 }
 
+#ifdef DEBUG
+/* safety check for chipinfo */
+static int brcmf_sdio_chip_cichk(struct chip_info *ci)
+{
+	u8 core_idx;
+
+	/* check RAM core presence for ARM CM3 core */
+	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+	if (BRCMF_MAX_CORENUM != core_idx) {
+		core_idx = brcmf_sdio_chip_getinfidx(ci,
+						     BCMA_CORE_INTERNAL_MEM);
+		if (BRCMF_MAX_CORENUM == core_idx) {
+			brcmf_err("RAM core not provided with ARM CM3 core\n");
+			return -ENODEV;
+		}
+	}
+
+	/* check RAM base for ARM CR4 core */
+	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CR4);
+	if (BRCMF_MAX_CORENUM != core_idx) {
+		if (ci->rambase == 0) {
+			brcmf_err("RAM base not provided with ARM CR4 core\n");
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+#else	/* DEBUG */
+static inline int brcmf_sdio_chip_cichk(struct chip_info *ci)
+{
+	return 0;
+}
+#endif
+
 static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 				       struct chip_info *ci, u32 regs)
 {
 	u32 regdata;
+	int ret;
 
 	/* Get CC core rev
 	 * Chipid is assume to be at offset 0 from regs arg
@@ -439,6 +498,10 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		return -ENODEV;
 	}
 
+	ret = brcmf_sdio_chip_cichk(ci);
+	if (ret)
+		return ret;
+
 	switch (ci->socitype) {
 	case SOCI_SB:
 		ci->iscoreup = brcmf_sdio_sb_iscoreup;
@@ -538,7 +601,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3);
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
@@ -701,7 +764,7 @@ static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
 	u32 token;
 	__le32 token_le;
 
-	nvram_addr = (ci->ramsize - 4) - nvram_sz;
+	nvram_addr = (ci->ramsize - 4) - nvram_sz + ci->rambase;
 
 	/* Write the vars list */
 	err = brcmf_sdio_ramrw(sdiodev, true, nvram_addr, nvram_dat, nvram_sz);
@@ -728,7 +791,7 @@ static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
 		  nvram_addr, nvram_sz, token);
 
 	/* Write the length token to the last word */
-	if (brcmf_sdio_ramrw(sdiodev, true, (ci->ramsize - 4),
+	if (brcmf_sdio_ramrw(sdiodev, true, (ci->ramsize - 4 + ci->rambase),
 			     (u8 *)&token_le, 4))
 		return false;
 
@@ -741,8 +804,8 @@ brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 {
 	u32 zeros = 0;
 
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3);
-	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM);
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0);
 
 	/* clear length token */
 	brcmf_sdio_ramrw(sdiodev, true, ci->ramsize - 4, (u8 *)&zeros, 4);
@@ -769,7 +832,41 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
 	brcmf_sdio_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
+
+	return true;
+}
+
+static inline void
+brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
+			    struct chip_info *ci)
+{
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4,
+		      ARMCR4_BCMA_IOCTL_CPUHALT);
+}
+
+static bool
+brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+			   char *nvram_dat, uint nvram_sz)
+{
+	u8 core_idx;
+	u32 reg_addr;
+
+	if (!brcmf_sdio_chip_writenvram(sdiodev, ci, nvram_dat, nvram_sz))
+		return false;
+
+	/* clear all interrupts */
+	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
+	reg_addr = ci->c_inf[core_idx].base;
+	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
+	brcmf_sdio_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+
+	/* Write reset vector to address 0 */
+	brcmf_sdio_ramrw(sdiodev, true, 0, (void *)&ci->rst_vec,
+			 sizeof(ci->rst_vec));
+
+	/* restore ARM */
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, 0);
 
 	return true;
 }
@@ -777,12 +874,27 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 				    struct chip_info *ci)
 {
-	brcmf_sdio_chip_cm3_enterdl(sdiodev, ci);
+	u8 arm_core_idx;
+
+	arm_core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+	if (BRCMF_MAX_CORENUM != arm_core_idx) {
+		brcmf_sdio_chip_cm3_enterdl(sdiodev, ci);
+		return;
+	}
+
+	brcmf_sdio_chip_cr4_enterdl(sdiodev, ci);
 }
 
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
 				   struct chip_info *ci, char *nvram_dat,
 				   uint nvram_sz)
 {
-	return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci, nvram_dat, nvram_sz);
+	u8 arm_core_idx;
+
+	arm_core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
+	if (BRCMF_MAX_CORENUM != arm_core_idx)
+		return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci, nvram_dat,
+						  nvram_sz);
+
+	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci, nvram_dat, nvram_sz);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 2123ea7..83c041f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -73,15 +73,17 @@ struct chip_info {
 	u32 pmurev;
 	u32 pmucaps;
 	u32 ramsize;
+	u32 rambase;
+	u32 rst_vec;	/* reset vertor for ARM CR4 core */
 
 	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 			 u16 coreid);
 	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 			 u16 coreid);
 	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid);
+			struct chip_info *ci, u16 coreid, u32 core_bits);
 	void (*resetcore)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid);
+			struct chip_info *ci, u16 coreid, u32 core_bits);
 };
 
 struct sbconfig {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0ab6712..f14a98a 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -134,6 +134,7 @@ struct bcma_host_ops {
 #define BCMA_CORE_I2S			0x834
 #define BCMA_CORE_SDR_DDR1_MEM_CTL	0x835	/* SDR/DDR1 memory controller core */
 #define BCMA_CORE_SHIM			0x837	/* SHIM component in ubus/6362 */
+#define BCMA_CORE_ARM_CR4		0x83e
 #define BCMA_CORE_DEFAULT		0xFFF
 
 #define BCMA_MAX_NR_CORES		16
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 7e8104b..917dcd7 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -37,6 +37,7 @@
 #define  BCMA_IOST_BIST_DONE		0x8000
 #define BCMA_RESET_CTL			0x0800
 #define  BCMA_RESET_CTL_RESET		0x0001
+#define BCMA_RESET_ST			0x0804
 
 /* BCMA PCI config space registers. */
 #define BCMA_PCI_PMCSR			0x44
-- 
1.7.10.4


