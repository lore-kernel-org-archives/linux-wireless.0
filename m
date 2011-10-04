Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2405 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/26] staging: brcm80211: fixed checkpatch warnings
Date: Tue, 4 Oct 2011 23:18:56 +0200
Message-ID: <1317763152-17607-11-git-send-email-arend@broadcom.com> (sfid-20111004_232024_207050_145351A7)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   14 ++++++--------
 drivers/staging/brcm80211/brcmsmac/main.c    |    3 +--
 drivers/staging/brcm80211/brcmsmac/nicpci.c  |    3 +--
 drivers/staging/brcm80211/brcmsmac/srom.c    |    3 +--
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 0b3ba6a..8d4024e 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1054,9 +1054,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	cc = (struct chipcregs __iomem *) regs;
 
 	/* bus/core/clk setup for register access */
-	if (!ai_buscore_prep(sii)) {
+	if (!ai_buscore_prep(sii))
 		return NULL;
-	}
 
 	/*
 	 * ChipID recognition.
@@ -1084,19 +1083,18 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		return NULL;
 	}
 	/* no cores found, bail out */
-	if (sii->numcores == 0) {
+	if (sii->numcores == 0)
 		return NULL;
-	}
+
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
-	if (!ai_buscore_setup(sii, savewin, &origidx)) {
+	if (!ai_buscore_setup(sii, savewin, &origidx))
 		goto exit;
-	}
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init(&sii->pub, cc, vars, varsz)) {
+	if (srom_var_init(&sii->pub, cc, vars, varsz))
 		goto exit;
-	}
+
 	pvars = vars ? *vars : NULL;
 	ai_nvram_process(sii, pvars);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 39b91d6..db05521 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5995,9 +5995,8 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	 * If we are switching to gmode == GMODE_LEGACY_B,
 	 * clean up rate info that may refer to OFDM rates.
 	 */
-	if ((gmode == GMODE_LEGACY_B) && (band->gmode != GMODE_LEGACY_B)) {
+	if ((gmode == GMODE_LEGACY_B) && (band->gmode != GMODE_LEGACY_B))
 		band->gmode = gmode;
-	}
 
 	band->gmode = gmode;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index e3cce29..460b105 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -394,9 +394,8 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 		i++;
 	}
 
-	if (i >= pcie_serdes_spinwait) {
+	if (i >= pcie_serdes_spinwait)
 		return false;
-	}
 
 	return true;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 6f3b12c..13d17eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1175,8 +1175,7 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
 			if (sromrev == 0x10)
 				sromrev = 1;
 		}
-	}
-	else {
+	} else {
 		/* Use OTP if SPROM not available */
 		err = otp_read_pci(sih, srom, SROM_MAX);
 		if (err == 0)
-- 
1.7.4.1


