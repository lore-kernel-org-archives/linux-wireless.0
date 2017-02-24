Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36853 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdBXMgX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 07:36:23 -0500
Received: by mail-lf0-f67.google.com with SMTP id p197so1377325lfp.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 04:36:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.12 2/2] brcmfmac: use more accurate PCIe chip names in fw table
Date: Fri, 24 Feb 2017 13:27:39 +0100
Message-Id: <20170224122739.1778-2-zajec5@gmail.com> (sfid-20170224_133742_482061_91D7EB4E)
In-Reply-To: <20170224122739.1778-1-zajec5@gmail.com>
References: <20170224122739.1778-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Many chips have few variants/versions, e.g. BCM4366 can be 4366b1 or
4366c0. Cutting name at the letter isn't a good idea as sometimes we may
have e.g. a0 and a1.

This is just a cosmetic change, a trivial cleanup. It obviously doesn't
change fw filenames as we don't want to break user space.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 2a171479b42b..7039f7f09653 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -46,7 +46,7 @@ enum brcmf_pcie_state {
 	BRCMFMAC_PCIE_STATE_UP
 };
 
-BRCMF_FW_NVRAM_DEF(43602, "brcmfmac43602-pcie.bin", "brcmfmac43602-pcie.txt");
+BRCMF_FW_NVRAM_DEF(43602a1, "brcmfmac43602-pcie.bin", "brcmfmac43602-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4350, "brcmfmac4350-pcie.bin", "brcmfmac4350-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4350C, "brcmfmac4350c2-pcie.bin", "brcmfmac4350c2-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-pcie.bin", "brcmfmac4356-pcie.txt");
@@ -55,13 +55,13 @@ BRCMF_FW_NVRAM_DEF(4358, "brcmfmac4358-pcie.bin", "brcmfmac4358-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4359, "brcmfmac4359-pcie.bin", "brcmfmac4359-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4365B, "brcmfmac4365b-pcie.bin", "brcmfmac4365b-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4365C, "brcmfmac4365c-pcie.bin", "brcmfmac4365c-pcie.txt");
-BRCMF_FW_NVRAM_DEF(4366B, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
-BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4366b1, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
+BRCMF_FW_NVRAM_DEF(4366c0, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
 BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
 
 static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFE, 43602),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFE, 43602a1),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366c0),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43525_CHIP_ID, 0xFFFFFFF0, 4365C),
@@ -73,8 +73,8 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366C),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366b1),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366c0),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 };
 
-- 
2.11.0
