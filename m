Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2372 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3DKL3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/15] brcmfmac: move chip download state code to
 sdio_chip.c
Date: Thu, 11 Apr 2013 13:28:48 +0200
Message-ID: <1365679740-25679-4-git-send-email-arend@broadcom.com> (sfid-20130411_132937_932522_E97541CF)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

enter/exit download state routine is going to diverge with new ARM core
introduced. Move corresponding code to sdio_chip.c for new ARM core support.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  205 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  140 ++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   95 ++++++++-
 3 files changed, 241 insertions(+), 199 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 26e34b6..3147960 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -336,95 +336,6 @@ static uint prio2prec(u32 prio)
 	       (prio^2) : prio;
 }
 
-/* core registers */
-struct sdpcmd_regs {
-	u32 corecontrol;		/* 0x00, rev8 */
-	u32 corestatus;			/* rev8 */
-	u32 PAD[1];
-	u32 biststatus;			/* rev8 */
-
-	/* PCMCIA access */
-	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
-	u16 PAD[1];
-	u16 pcmciamesportalmask;	/* rev8 */
-	u16 PAD[1];
-	u16 pcmciawrframebc;		/* rev8 */
-	u16 PAD[1];
-	u16 pcmciaunderflowtimer;	/* rev8 */
-	u16 PAD[1];
-
-	/* interrupt */
-	u32 intstatus;			/* 0x020, rev8 */
-	u32 hostintmask;		/* rev8 */
-	u32 intmask;			/* rev8 */
-	u32 sbintstatus;		/* rev8 */
-	u32 sbintmask;			/* rev8 */
-	u32 funcintmask;		/* rev4 */
-	u32 PAD[2];
-	u32 tosbmailbox;		/* 0x040, rev8 */
-	u32 tohostmailbox;		/* rev8 */
-	u32 tosbmailboxdata;		/* rev8 */
-	u32 tohostmailboxdata;		/* rev8 */
-
-	/* synchronized access to registers in SDIO clock domain */
-	u32 sdioaccess;			/* 0x050, rev8 */
-	u32 PAD[3];
-
-	/* PCMCIA frame control */
-	u8 pcmciaframectrl;		/* 0x060, rev8 */
-	u8 PAD[3];
-	u8 pcmciawatermark;		/* rev8 */
-	u8 PAD[155];
-
-	/* interrupt batching control */
-	u32 intrcvlazy;			/* 0x100, rev8 */
-	u32 PAD[3];
-
-	/* counters */
-	u32 cmd52rd;			/* 0x110, rev8 */
-	u32 cmd52wr;			/* rev8 */
-	u32 cmd53rd;			/* rev8 */
-	u32 cmd53wr;			/* rev8 */
-	u32 abort;			/* rev8 */
-	u32 datacrcerror;		/* rev8 */
-	u32 rdoutofsync;		/* rev8 */
-	u32 wroutofsync;		/* rev8 */
-	u32 writebusy;			/* rev8 */
-	u32 readwait;			/* rev8 */
-	u32 readterm;			/* rev8 */
-	u32 writeterm;			/* rev8 */
-	u32 PAD[40];
-	u32 clockctlstatus;		/* rev8 */
-	u32 PAD[7];
-
-	u32 PAD[128];			/* DMA engines */
-
-	/* SDIO/PCMCIA CIS region */
-	char cis[512];			/* 0x400-0x5ff, rev6 */
-
-	/* PCMCIA function control registers */
-	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
-	u16 PAD[55];
-
-	/* PCMCIA backplane access */
-	u16 backplanecsr;		/* 0x76E, rev6 */
-	u16 backplaneaddr0;		/* rev6 */
-	u16 backplaneaddr1;		/* rev6 */
-	u16 backplaneaddr2;		/* rev6 */
-	u16 backplaneaddr3;		/* rev6 */
-	u16 backplanedata0;		/* rev6 */
-	u16 backplanedata1;		/* rev6 */
-	u16 backplanedata2;		/* rev6 */
-	u16 backplanedata3;		/* rev6 */
-	u16 PAD[31];
-
-	/* sprom "size" & "blank" info */
-	u16 spromstatus;		/* 0x7BE, rev2 */
-	u32 PAD[464];
-
-	u16 PAD[0x80];
-};
-
 #ifdef DEBUG
 /* Device console log buffer state */
 struct brcmf_console {
@@ -3082,84 +2993,8 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
+static bool brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 {
-	int bcmerror = 0;
-	u32 varaddr;
-	u32 varsizew;
-	__le32 varsizew_le;
-#ifdef DEBUG
-	char *nvram_ularray;
-#endif				/* DEBUG */
-
-	/* Even if there are no vars are to be written, we still
-		 need to set the ramsize. */
-	varaddr = (bus->ramsize - 4) - bus->varsz;
-
-	if (bus->vars) {
-		/* Write the vars list */
-		bcmerror = brcmf_sdio_ramrw(bus->sdiodev, true, varaddr,
-					    bus->vars, bus->varsz);
-#ifdef DEBUG
-		/* Verify NVRAM bytes */
-		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n",
-			  bus->varsz);
-		nvram_ularray = kmalloc(bus->varsz, GFP_ATOMIC);
-		if (!nvram_ularray)
-			return -ENOMEM;
-
-		/* Upload image to verify downloaded contents. */
-		memset(nvram_ularray, 0xaa, bus->varsz);
-
-		/* Read the vars list to temp buffer for comparison */
-		bcmerror = brcmf_sdio_ramrw(bus->sdiodev, false, varaddr,
-					    nvram_ularray, bus->varsz);
-		if (bcmerror) {
-			brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
-				  bcmerror, bus->varsz, varaddr);
-		}
-		/* Compare the org NVRAM with the one read from RAM */
-		if (memcmp(bus->vars, nvram_ularray, bus->varsz))
-			brcmf_err("Downloaded NVRAM image is corrupted\n");
-		else
-			brcmf_err("Download/Upload/Compare of NVRAM ok\n");
-
-		kfree(nvram_ularray);
-#endif				/* DEBUG */
-	}
-
-	/* adjust to the user specified RAM */
-	brcmf_dbg(INFO, "Physical memory size: %d\n", bus->ramsize);
-	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
-		  varaddr, bus->varsz);
-
-	/*
-	 * Determine the length token:
-	 * Varsize, converted to words, in lower 16-bits, checksum
-	 * in upper 16-bits.
-	 */
-	if (bcmerror) {
-		varsizew = 0;
-		varsizew_le = cpu_to_le32(0);
-	} else {
-		varsizew = bus->varsz / 4;
-		varsizew = (~varsizew << 16) | (varsizew & 0x0000FFFF);
-		varsizew_le = cpu_to_le32(varsizew);
-	}
-
-	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
-		  bus->varsz, varsizew);
-
-	/* Write the length token to the last word */
-	bcmerror = brcmf_sdio_ramrw(bus->sdiodev, true, (bus->ramsize - 4),
-				    (u8 *)&varsizew_le, 4);
-
-	return bcmerror;
-}
-
-static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
-{
-	int bcmerror = 0;
 	struct chip_info *ci = bus->ci;
 
 	/* To enter download state, disable ARM and reset SOCRAM.
@@ -3168,41 +3003,19 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		ci->coredisable(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
-
-		ci->resetcore(bus->sdiodev, ci, BCMA_CORE_INTERNAL_MEM);
-
-		/* Clear the top bit of memory */
-		if (bus->ramsize) {
-			u32 zeros = 0;
-			brcmf_sdio_ramrw(bus->sdiodev, true, bus->ramsize - 4,
-					 (u8 *)&zeros, 4);
-		}
+		brcmf_sdio_chip_enter_download(bus->sdiodev, ci);
 	} else {
-		if (!ci->iscoreup(bus->sdiodev, ci, BCMA_CORE_INTERNAL_MEM)) {
-			brcmf_err("SOCRAM core is down after reset?\n");
-			bcmerror = -EBADE;
-			goto fail;
-		}
-
-		bcmerror = brcmf_sdbrcm_write_vars(bus);
-		if (bcmerror) {
-			brcmf_err("no vars written to RAM\n");
-			bcmerror = 0;
-		}
-
-		w_sdreg32(bus, 0xFFFFFFFF,
-			  offsetof(struct sdpcmd_regs, intstatus));
-
-		ci->resetcore(bus->sdiodev, ci, BCMA_CORE_ARM_CM3);
+		if (!brcmf_sdio_chip_exit_download(bus->sdiodev, ci, bus->vars,
+						   bus->varsz))
+			return false;
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
 
 		bus->sdiodev->bus_if->state = BRCMF_BUS_LOAD;
 	}
-fail:
-	return bcmerror;
+
+	return true;
 }
 
 static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_sdio *bus)
@@ -3359,7 +3172,7 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	int bcmerror = -1;
 
 	/* Keep arm in reset */
-	if (brcmf_sdbrcm_download_state(bus, true)) {
+	if (!brcmf_sdbrcm_download_state(bus, true)) {
 		brcmf_err("error placing ARM core in reset\n");
 		goto err;
 	}
@@ -3375,7 +3188,7 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	}
 
 	/* Take arm out of reset */
-	if (brcmf_sdbrcm_download_state(bus, false)) {
+	if (!brcmf_sdbrcm_download_state(bus, false)) {
 		brcmf_err("error getting out of ARM core reset\n");
 		goto err;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 14be2d5..9818598 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -356,8 +356,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 {
 	u32 regdata;
 
-	/*
-	 * Get CC core rev
+	/* Get CC core rev
 	 * Chipid is assume to be at offset 0 from regs arg
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
 	 * other ways of recognition should be added here.
@@ -650,3 +649,140 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			  drivestrength, cc_data_temp);
 	}
 }
+
+#ifdef DEBUG
+static bool
+brcmf_sdio_chip_verifynvram(struct brcmf_sdio_dev *sdiodev, u32 nvram_addr,
+			    char *nvram_dat, uint nvram_sz)
+{
+	char *nvram_ularray;
+	int err;
+	bool ret = true;
+
+	/* read back and verify */
+	brcmf_dbg(INFO, "Compare NVRAM dl & ul; size=%d\n", nvram_sz);
+	nvram_ularray = kmalloc(nvram_sz, GFP_KERNEL);
+	/* do not proceed while no memory but  */
+	if (!nvram_ularray)
+		return true;
+
+	/* Upload image to verify downloaded contents. */
+	memset(nvram_ularray, 0xaa, nvram_sz);
+
+	/* Read the vars list to temp buffer for comparison */
+	err = brcmf_sdio_ramrw(sdiodev, false, nvram_addr, nvram_ularray,
+			       nvram_sz);
+	if (err) {
+		brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
+			  err, nvram_sz, nvram_addr);
+	} else if (memcmp(nvram_dat, nvram_ularray, nvram_sz)) {
+		brcmf_err("Downloaded NVRAM image is corrupted\n");
+		ret = false;
+	}
+	kfree(nvram_ularray);
+
+	return ret;
+}
+#else	/* DEBUG */
+static inline bool
+brcmf_sdio_chip_verifynvram(struct brcmf_sdio_dev *sdiodev, u32 nvram_addr,
+			    char *nvram_dat, uint nvram_sz)
+{
+	return true;
+}
+#endif	/* DEBUG */
+
+static bool brcmf_sdio_chip_writenvram(struct brcmf_sdio_dev *sdiodev,
+				       struct chip_info *ci,
+				       char *nvram_dat, uint nvram_sz)
+{
+	int err;
+	u32 nvram_addr;
+	u32 token;
+	__le32 token_le;
+
+	nvram_addr = (ci->ramsize - 4) - nvram_sz;
+
+	/* Write the vars list */
+	err = brcmf_sdio_ramrw(sdiodev, true, nvram_addr, nvram_dat, nvram_sz);
+	if (err) {
+		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
+			  err, nvram_sz, nvram_addr);
+		return false;
+	}
+
+	if (!brcmf_sdio_chip_verifynvram(sdiodev, nvram_addr,
+					 nvram_dat, nvram_sz))
+		return false;
+
+	/* generate token:
+	 * nvram size, converted to words, in lower 16-bits, checksum
+	 * in upper 16-bits.
+	 */
+	token = nvram_sz / 4;
+	token = (~token << 16) | (token & 0x0000FFFF);
+	token_le = cpu_to_le32(token);
+
+	brcmf_dbg(INFO, "RAM size: %d\n", ci->ramsize);
+	brcmf_dbg(INFO, "nvram is placed at %d, size %d, token=0x%08x\n",
+		  nvram_addr, nvram_sz, token);
+
+	/* Write the length token to the last word */
+	if (brcmf_sdio_ramrw(sdiodev, true, (ci->ramsize - 4),
+			     (u8 *)&token_le, 4))
+		return false;
+
+	return true;
+}
+
+static void
+brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
+			    struct chip_info *ci)
+{
+	u32 zeros = 0;
+
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM);
+
+	/* clear length token */
+	brcmf_sdio_ramrw(sdiodev, true, ci->ramsize - 4, (u8 *)&zeros, 4);
+}
+
+static bool
+brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+			   char *nvram_dat, uint nvram_sz)
+{
+	u8 core_idx;
+	u32 reg_addr;
+
+	if (!ci->iscoreup(sdiodev, ci, BCMA_CORE_INTERNAL_MEM)) {
+		brcmf_err("SOCRAM core is down after reset?\n");
+		return false;
+	}
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
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3);
+
+	return true;
+}
+
+void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
+				    struct chip_info *ci)
+{
+	brcmf_sdio_chip_cm3_enterdl(sdiodev, ci);
+}
+
+bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
+				   struct chip_info *ci, char *nvram_dat,
+				   uint nvram_sz)
+{
+	return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci, nvram_dat, nvram_sz);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index ce974d7..2123ea7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -124,6 +124,95 @@ struct sbconfig {
 	u32 sbidhigh;	/* identification */
 };
 
+/* sdio core registers */
+struct sdpcmd_regs {
+	u32 corecontrol;		/* 0x00, rev8 */
+	u32 corestatus;			/* rev8 */
+	u32 PAD[1];
+	u32 biststatus;			/* rev8 */
+
+	/* PCMCIA access */
+	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
+	u16 PAD[1];
+	u16 pcmciamesportalmask;	/* rev8 */
+	u16 PAD[1];
+	u16 pcmciawrframebc;		/* rev8 */
+	u16 PAD[1];
+	u16 pcmciaunderflowtimer;	/* rev8 */
+	u16 PAD[1];
+
+	/* interrupt */
+	u32 intstatus;			/* 0x020, rev8 */
+	u32 hostintmask;		/* rev8 */
+	u32 intmask;			/* rev8 */
+	u32 sbintstatus;		/* rev8 */
+	u32 sbintmask;			/* rev8 */
+	u32 funcintmask;		/* rev4 */
+	u32 PAD[2];
+	u32 tosbmailbox;		/* 0x040, rev8 */
+	u32 tohostmailbox;		/* rev8 */
+	u32 tosbmailboxdata;		/* rev8 */
+	u32 tohostmailboxdata;		/* rev8 */
+
+	/* synchronized access to registers in SDIO clock domain */
+	u32 sdioaccess;			/* 0x050, rev8 */
+	u32 PAD[3];
+
+	/* PCMCIA frame control */
+	u8 pcmciaframectrl;		/* 0x060, rev8 */
+	u8 PAD[3];
+	u8 pcmciawatermark;		/* rev8 */
+	u8 PAD[155];
+
+	/* interrupt batching control */
+	u32 intrcvlazy;			/* 0x100, rev8 */
+	u32 PAD[3];
+
+	/* counters */
+	u32 cmd52rd;			/* 0x110, rev8 */
+	u32 cmd52wr;			/* rev8 */
+	u32 cmd53rd;			/* rev8 */
+	u32 cmd53wr;			/* rev8 */
+	u32 abort;			/* rev8 */
+	u32 datacrcerror;		/* rev8 */
+	u32 rdoutofsync;		/* rev8 */
+	u32 wroutofsync;		/* rev8 */
+	u32 writebusy;			/* rev8 */
+	u32 readwait;			/* rev8 */
+	u32 readterm;			/* rev8 */
+	u32 writeterm;			/* rev8 */
+	u32 PAD[40];
+	u32 clockctlstatus;		/* rev8 */
+	u32 PAD[7];
+
+	u32 PAD[128];			/* DMA engines */
+
+	/* SDIO/PCMCIA CIS region */
+	char cis[512];			/* 0x400-0x5ff, rev6 */
+
+	/* PCMCIA function control registers */
+	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
+	u16 PAD[55];
+
+	/* PCMCIA backplane access */
+	u16 backplanecsr;		/* 0x76E, rev6 */
+	u16 backplaneaddr0;		/* rev6 */
+	u16 backplaneaddr1;		/* rev6 */
+	u16 backplaneaddr2;		/* rev6 */
+	u16 backplaneaddr3;		/* rev6 */
+	u16 backplanedata0;		/* rev6 */
+	u16 backplanedata1;		/* rev6 */
+	u16 backplanedata2;		/* rev6 */
+	u16 backplanedata3;		/* rev6 */
+	u16 PAD[31];
+
+	/* sprom "size" & "blank" info */
+	u16 spromstatus;		/* 0x7BE, rev2 */
+	u32 PAD[464];
+
+	u16 PAD[0x80];
+};
+
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info **ci_ptr, u32 regs);
 extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
@@ -131,6 +220,10 @@ extern void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 					      struct chip_info *ci,
 					      u32 drivestrength);
 extern u8 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid);
-
+extern void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
+					   struct chip_info *ci);
+extern bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
+					  struct chip_info *ci, char *nvram_dat,
+					  uint nvram_sz);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.10.4


