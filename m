Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:16135
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161118AbcBQK13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:29 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/21] brcmfmac: add support for the PCIE 4366c0 chip
Date: Wed, 17 Feb 2016 11:26:59 +0100
Message-Id: <1455704830-10088-11-git-send-email-arend@broadcom.com> (sfid-20160217_112751_213147_B073E971)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

A newer version of the 4366 PCIE chip has been released. Add
support for this version of the chip.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3fd4e3b..3cb32b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -53,6 +53,7 @@ BRCMF_FW_NVRAM_DEF(4358, "brcmfmac4358-pcie.bin", "brcmfmac4358-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4359, "brcmfmac4359-pcie.bin", "brcmfmac4359-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4365B, "brcmfmac4365b-pcie.bin", "brcmfmac4365b-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4366B, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
 
 static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
@@ -66,7 +67,8 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFFF, 4365B),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFFF, 4366B),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 };
 
-- 
1.9.1

