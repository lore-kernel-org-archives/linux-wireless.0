Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58341 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbbLIKW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/13] brcmfmac: Add support for PCIE 4350 revision 5 device.
Date: Wed, 9 Dec 2015 11:22:45 +0100
Message-ID: <1449656572-16158-7-git-send-email-arend@broadcom.com> (sfid-20151209_112321_470416_54E8B2B4)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: I72b519ec6a7ff0d36f076df06d042f0c5894142c
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5513
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index b5a4247..4ebc53c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -46,6 +46,7 @@ enum brcmf_pcie_state {
 
 BRCMF_FW_NVRAM_DEF(43602, "brcmfmac43602-pcie.bin", "brcmfmac43602-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4350, "brcmfmac4350-pcie.bin", "brcmfmac4350-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4350C, "brcmfmac4350c2-pcie.bin", "brcmfmac4350c2-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-pcie.bin", "brcmfmac4356-pcie.txt");
 BRCMF_FW_NVRAM_DEF(43570, "brcmfmac43570-pcie.bin", "brcmfmac43570-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4358, "brcmfmac4358-pcie.bin", "brcmfmac4358-pcie.txt");
@@ -56,7 +57,8 @@ BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
 
 static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFFFF, 4350),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43567_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
-- 
1.9.1

