Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49990 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQQrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:47:36 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 22/29] brcmfmac: Rename axi functions for clarity.
Date: Mon, 17 Jul 2017 17:16:30 +0100
Message-Id: <20170717161637.4652-23-ian@mnementh.co.uk> (sfid-20170717_184739_680514_2677969C)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are poorly named. for the sake of one character,
correct this.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
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
