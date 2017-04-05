Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36132 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbdDESdj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 14:33:39 -0400
Received: by mail-wr0-f193.google.com with SMTP id k6so5037487wre.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Apr 2017 11:33:39 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] brcmfmac: properly align buffers on certain platforms with 64
 bit DMA
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Helmut Klein <hgkr.klein@gmail.com>
Message-ID: <7120e0d6-8687-2622-7432-cb78dae3e122@gmail.com> (sfid-20170405_203525_232417_10A79917)
Date: Wed, 5 Apr 2017 20:33:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Systems with 64 bit DMA at least partially require buffers to be used
for DMA to be 8-byte-aligned. One example is Amlogic Meson GX.
Switching the MMC/SDIO driver for this platform to SG DMA mode
resulted in problems due to unaligned buffers.

Fortunately the brcmfmac driver has a global define for the alignment.
Changing it to 8 fixed the issues with Meson GX.

Suggested-by: Helmut Klein <hgkr.klein@gmail.com>
Tested-by: Helmut Klein <hgkr.klein@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a999f950..fc64b891 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -540,7 +540,11 @@ static int qcount[NUMPRIO];
 /* Limit on rounding up frames */
 static const uint max_roundup = 512;
 
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#define ALIGNMENT  8
+#else
 #define ALIGNMENT  4
+#endif
 
 enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_NORMAL,
-- 
2.12.1
