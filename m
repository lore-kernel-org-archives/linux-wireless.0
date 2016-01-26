Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34940 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966867AbcAZQ5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:36 -0500
Received: by mail-lf0-f42.google.com with SMTP id c192so109093818lfe.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] brcmfmac: access PMU registers using standalone PMU core if available
Date: Tue, 26 Jan 2016 17:57:04 +0100
Message-Id: <1453827425-16455-5-git-send-email-zajec5@gmail.com> (sfid-20160126_175744_640445_99A36532)
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On recent Broadcom chipsets PMU is present as separated core and it
can't be accessed using ChipCommon anymore as it fails with e.g.:
[   18.198412] Unhandled fault: imprecise external abort (0x1406) at 0xb6da200f

Add a new helper function that will return a proper core that should be
used for accessing PMU registers.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 30 ++++++++++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  9 +++----
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index f4a4d00..0e8f2a0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1014,6 +1014,7 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 {
 	struct brcmf_chip *pub;
 	struct brcmf_core_priv *cc;
+	struct brcmf_core *pmu;
 	u32 base;
 	u32 val;
 	int ret = 0;
@@ -1030,9 +1031,10 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 							 capabilities_ext));
 
 	/* get pmu caps & rev */
+	pmu = brcmf_chip_get_pmu(pub); /* after reading cc_caps_ext */
 	if (pub->cc_caps & CC_CAP_PMU) {
 		val = chip->ops->read32(chip->ctx,
-					CORE_CC_REG(base, pmucapabilities));
+					CORE_CC_REG(pmu->base, pmucapabilities));
 		pub->pmurev = val & PCAP_REV_MASK;
 		pub->pmucaps = val;
 	}
@@ -1131,6 +1133,23 @@ struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *pub)
 	return &cc->pub;
 }
 
+struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *pub)
+{
+	struct brcmf_core *cc = brcmf_chip_get_chipcommon(pub);
+	struct brcmf_core *pmu;
+
+	/* See if there is separated PMU core available */
+	if (cc->rev >= 35 &&
+	    pub->cc_caps_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
+		pmu = brcmf_chip_get_core(pub, BCMA_CORE_PMU);
+		if (pmu)
+			return pmu;
+	}
+
+	/* Fallback to ChipCommon core for older hardware */
+	return cc;
+}
+
 bool brcmf_chip_iscoreup(struct brcmf_core *pub)
 {
 	struct brcmf_core_priv *core;
@@ -1301,6 +1320,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 {
 	u32 base, addr, reg, pmu_cc3_mask = ~0;
 	struct brcmf_chip_priv *chip;
+	struct brcmf_core *pmu = brcmf_chip_get_pmu(pub);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -1320,9 +1340,9 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 	case BRCM_CC_4335_CHIP_ID:
 	case BRCM_CC_4339_CHIP_ID:
 		/* read PMU chipcontrol register 3 */
-		addr = CORE_CC_REG(base, chipcontrol_addr);
+		addr = CORE_CC_REG(pmu->base, chipcontrol_addr);
 		chip->ops->write32(chip->ctx, addr, 3);
-		addr = CORE_CC_REG(base, chipcontrol_data);
+		addr = CORE_CC_REG(pmu->base, chipcontrol_data);
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & pmu_cc3_mask) != 0;
 	case BRCM_CC_43430_CHIP_ID:
@@ -1330,12 +1350,12 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		reg = chip->ops->read32(chip->ctx, addr);
 		return reg != 0;
 	default:
-		addr = CORE_CC_REG(base, pmucapabilities_ext);
+		addr = CORE_CC_REG(pmu->base, pmucapabilities_ext);
 		reg = chip->ops->read32(chip->ctx, addr);
 		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
 			return false;
 
-		addr = CORE_CC_REG(base, retention_ctl);
+		addr = CORE_CC_REG(pmu->base, retention_ctl);
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
 			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index cb9145f..dd0ec3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -85,6 +85,7 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 void brcmf_chip_detach(struct brcmf_chip *chip);
 struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *chip, u16 coreid);
 struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *chip);
+struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *pub);
 bool brcmf_chip_iscoreup(struct brcmf_core *core);
 void brcmf_chip_coredisable(struct brcmf_core *core, u32 prereset, u32 reset);
 void brcmf_chip_resetcore(struct brcmf_core *core, u32 prereset, u32 reset,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index dd66143..80b5d47 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3615,7 +3615,6 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	const struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask;
 	u32 str_shift;
-	u32 base;
 	u32 i;
 	u32 drivestrength_sel = 0;
 	u32 cc_data_temp;
@@ -3658,14 +3657,15 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	}
 
 	if (str_tab != NULL) {
+		struct brcmf_core *pmu = brcmf_chip_get_pmu(ci);
+
 		for (i = 0; str_tab[i].strength != 0; i++) {
 			if (drivestrength >= str_tab[i].strength) {
 				drivestrength_sel = str_tab[i].sel;
 				break;
 			}
 		}
-		base = brcmf_chip_get_chipcommon(ci)->base;
-		addr = CORE_CC_REG(base, chipcontrol_addr);
+		addr = CORE_CC_REG(pmu->base, chipcontrol_addr);
 		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
 		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
 		cc_data_temp &= ~str_mask;
@@ -3835,8 +3835,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		goto fail;
 
 	/* set PMUControl so a backplane reset does PMU state reload */
-	reg_addr = CORE_CC_REG(brcmf_chip_get_chipcommon(bus->ci)->base,
-			       pmucontrol);
+	reg_addr = CORE_CC_REG(brcmf_chip_get_pmu(bus->ci)->base, pmucontrol);
 	reg_val = brcmf_sdiod_regrl(bus->sdiodev, reg_addr, &err);
 	if (err)
 		goto fail;
-- 
1.8.4.5

