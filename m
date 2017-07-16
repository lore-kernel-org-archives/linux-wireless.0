Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46236 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:43:11 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 16/21] brcmfmac: rename axi functions for clarity
Date: Sun, 16 Jul 2017 12:21:24 +0100
Message-Id: <20170716112129.10206-17-ian@mnementh.co.uk> (sfid-20170716_134314_935230_A3C80A41)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index b3b28e78c49d..1485463794ff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -239,7 +239,7 @@ static bool brcmf_chip_sb_iscoreup(struct brcmf_core *core)
 	return SSB_TMSLOW_CLOCK == regdata;
 }
 
-static bool brcmf_chip_ai_iscoreup(struct brcmf_core *core)
+static bool brcmf_chip_axi_iscoreup(struct brcmf_core *core)
 {
 	struct brcmf_chip *ci = core->chip;
 	u32 regdata;
@@ -340,7 +340,7 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 	udelay(1);
 }
 
-static void brcmf_chip_ai_coredisable(struct brcmf_core *core,
+static void brcmf_chip_axi_coredisable(struct brcmf_core *core,
 				      u32 prereset, u32 reset)
 {
 	struct brcmf_chip *ci = core->chip;
@@ -432,14 +432,14 @@ static void brcmf_chip_sb_resetcore(struct brcmf_core *core, u32 prereset,
 	udelay(1);
 }
 
-static void brcmf_chip_ai_resetcore(struct brcmf_core *core, u32 prereset,
+static void brcmf_chip_axi_resetcore(struct brcmf_core *core, u32 prereset,
 				    u32 reset, u32 postreset)
 {
 	struct brcmf_chip *ci = core->chip;
 	int count;
 
 	/* must disable first to work for arbitrary current core state */
-	brcmf_chip_ai_coredisable(core, prereset, reset);
+	brcmf_chip_axi_coredisable(core, prereset, reset);
 
 	count = 0;
 
@@ -1007,9 +1007,9 @@ static int brcmf_chip_probe(struct brcmf_chip *ci)
 		if (brcmf_chip_dmp_erom_scan(ci))
 			return -ENODEV;
 
-		ci->iscoreup = brcmf_chip_ai_iscoreup;
-		ci->coredisable = brcmf_chip_ai_coredisable;
-		ci->resetcore = brcmf_chip_ai_resetcore;
+		ci->iscoreup = brcmf_chip_axi_iscoreup;
+		ci->coredisable = brcmf_chip_axi_coredisable;
+		ci->resetcore = brcmf_chip_axi_resetcore;
 
 		break;
 	default:
-- 
2.11.0
