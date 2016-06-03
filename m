Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63245 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbcFCVbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:17 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: add support for the PCIE devices 43525 and 43465
Date: Fri,  3 Jun 2016 23:31:10 +0200
Message-Id: <1464989472-29684-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233122_507117_B34A25C5)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

This patch adds support for the new PCIE devices 43525 and 43465.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 6 +++++-
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index d3fd6b1..05f22ff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -685,6 +685,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43602_CHIP_ID:
 	case BRCM_CC_4371_CHIP_ID:
 		return 0x180000;
+	case BRCM_CC_43465_CHIP_ID:
+	case BRCM_CC_43525_CHIP_ID:
 	case BRCM_CC_4365_CHIP_ID:
 	case BRCM_CC_4366_CHIP_ID:
 		return 0x200000;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 0af8db8..3deba90 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -54,21 +54,25 @@ BRCMF_FW_NVRAM_DEF(43570, "brcmfmac43570-pcie.bin", "brcmfmac43570-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4358, "brcmfmac4358-pcie.bin", "brcmfmac4358-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4359, "brcmfmac4359-pcie.bin", "brcmfmac4359-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4365B, "brcmfmac4365b-pcie.bin", "brcmfmac4365b-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4365C, "brcmfmac4365c-pcie.bin", "brcmfmac4365c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4366B, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
 
 static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43525_CHIP_ID, 0xFFFFFFF0, 4365C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43567_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFFF, 4365B),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 699f2c2..3cc42be 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -40,7 +40,9 @@
 #define BRCM_CC_4339_CHIP_ID		0x4339
 #define BRCM_CC_43430_CHIP_ID		43430
 #define BRCM_CC_4345_CHIP_ID		0x4345
+#define BRCM_CC_43465_CHIP_ID		43465
 #define BRCM_CC_4350_CHIP_ID		0x4350
+#define BRCM_CC_43525_CHIP_ID		43525
 #define BRCM_CC_4354_CHIP_ID		0x4354
 #define BRCM_CC_4356_CHIP_ID		0x4356
 #define BRCM_CC_43566_CHIP_ID		43566
-- 
1.9.1

