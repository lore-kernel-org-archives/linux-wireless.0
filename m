Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24316 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaA2Ocd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:33 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/14] brcmfmac: CR4 takes precedence over CM3 in brcmf_chip_enter_download()
Date: Wed, 29 Jan 2014 15:32:24 +0100
Message-ID: <1391005944-3220-15-git-send-email-arend@broadcom.com> (sfid-20140129_153238_840428_9A7AC3D9)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the enter and exit download sequence the chip core info was checked
for presence of CM3 ARM core. If found it would enter download state for
the CM3. However, on devices that have a CM3 and CR4 this is not correct
and the CR4 should be used to enter download state. This patch changes
the ARM core lookup giving CR4 precedence.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index b04ea95..18fc20e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -967,13 +967,13 @@ void brcmf_chip_enter_download(struct brcmf_chip *pub)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	chip = container_of(pub, struct brcmf_chip_priv, pub);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CR4);
 	if (arm) {
-		brcmf_chip_cm3_enterdl(chip);
+		brcmf_chip_cr4_enterdl(chip);
 		return;
 	}
 
-	brcmf_chip_cr4_enterdl(chip);
+	brcmf_chip_cm3_enterdl(chip);
 }
 
 bool brcmf_chip_exit_download(struct brcmf_chip *pub, u32 rstvec)
@@ -984,11 +984,11 @@ bool brcmf_chip_exit_download(struct brcmf_chip *pub, u32 rstvec)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	chip = container_of(pub, struct brcmf_chip_priv, pub);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CR4);
 	if (arm)
-		return brcmf_chip_cm3_exitdl(chip);
+		return brcmf_chip_cr4_exitdl(chip, rstvec);
 
-	return brcmf_chip_cr4_exitdl(chip, rstvec);
+	return brcmf_chip_cm3_exitdl(chip);
 }
 
 bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
-- 
1.7.10.4

