Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35844 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbeCVP5u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 11:57:50 -0400
Received: by mail-pl0-f68.google.com with SMTP id 61-v6so5581181plf.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2018 08:57:49 -0700 (PDT)
From: Dan Haab <riproute@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Double Lo <double.lo@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dhaab@luxul.com>,
        Dan Haab <dan.haab@luxul.com>
Subject: [PATCH] brcmfmac: add support for BCM4366E chipset
Date: Thu, 22 Mar 2018 09:58:06 -0600
Message-Id: <1521734286-16293-1-git-send-email-dan.haab@luxul.com> (sfid-20180322_165812_342956_6795DCA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Haab <dhaab@luxul.com>

BCM4366E is a wireless chipset with a BCM43664 ChipCommon. It's
supported by the same firmware as 4366c0.

Signed-off-by: Dan Haab <dan.haab@luxul.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 2 ++
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index f7b30ce..271dadb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -689,6 +689,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43525_CHIP_ID:
 	case BRCM_CC_4365_CHIP_ID:
 	case BRCM_CC_4366_CHIP_ID:
+	case BRCM_CC_43664_CHIP_ID:
 		return 0x200000;
 	case CY_CC_4373_CHIP_ID:
 		return 0x160000;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a7d827c..b4d3832 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -57,6 +57,7 @@ enum brcmf_pcie_state {
 BRCMF_FW_NVRAM_DEF(4365C, "brcmfmac4365c-pcie.bin", "brcmfmac4365c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4366B, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4366E, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
 
 static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
@@ -75,6 +76,7 @@ enum brcmf_pcie_state {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366C),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43664_CHIP_ID, 0xFFFFFFF0, 4366E),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 57544a3..686f7a8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -57,6 +57,7 @@
 #define BRCM_CC_43602_CHIP_ID		43602
 #define BRCM_CC_4365_CHIP_ID		0x4365
 #define BRCM_CC_4366_CHIP_ID		0x4366
+#define BRCM_CC_43664_CHIP_ID		43664
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define CY_CC_4373_CHIP_ID		0x4373
 
-- 
1.9.1
