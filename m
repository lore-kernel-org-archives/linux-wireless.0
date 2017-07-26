Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48230 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbdGZUpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:45:19 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 18/34] brcmfmac: Rename SOC_AI to SOC_AXI
Date: Wed, 26 Jul 2017 21:25:41 +0100
Message-Id: <20170726202557.15632-19-ian@mnementh.co.uk> (sfid-20170726_224524_662965_89774CBF)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This #define is poorly named. Correct it.

At the same time, convert the if..elseif...else it is used in to a switch
for clarity.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 05f22ff81d60..7b8ba7192e1a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -30,7 +30,7 @@
 
 /* SOC Interconnect types (aka chip types) */
 #define SOCI_SB		0
-#define SOCI_AI		1
+#define SOCI_AXI	1
 
 /* PL-368 DMP definitions */
 #define DMP_DESC_TYPE_MSK	0x0000000F
@@ -927,7 +927,8 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name,
 		  ci->pub.chiprev);
 
-	if (socitype == SOCI_SB) {
+	switch(socitype) {
+		case SOCI_SB:
 		if (ci->pub.chip != BRCM_CC_4329_CHIP_ID) {
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
@@ -951,13 +952,15 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
 		brcmf_chip_sb_corerev(ci, core);
-	} else if (socitype == SOCI_AI) {
+		break;
+	case SOCI_AXI:
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
 		ci->coredisable = brcmf_chip_ai_coredisable;
 		ci->resetcore = brcmf_chip_ai_resetcore;
 
 		brcmf_chip_dmp_erom_scan(ci);
-	} else {
+		break;
+	default:
 		brcmf_err("chip backplane type %u is not supported\n",
 			  socitype);
 		return -ENODEV;
-- 
2.11.0
