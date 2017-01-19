Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34635 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdASJvf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 04:51:35 -0500
Received: by mail-lf0-f67.google.com with SMTP id q89so4684611lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 01:51:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH] brcmfmac: drop duplicated core selection from brcmf_pcie_attach
Date: Thu, 19 Jan 2017 10:51:25 +0100
Message-Id: <20170119095125.12276-1-zajec5@gmail.com> (sfid-20170119_105144_644350_29B6C32D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It was left after reworking PCIe reset in commit 07fe2e38c7fd
("brcmfmac: Reset PCIE devices after recognition.").

Cc: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 19db8f2..6fae4cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -601,7 +601,6 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
 {
 	u32 config;
 
-	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	/* BAR1 window may not be sized properly */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR, 0x4e0);
-- 
2.10.1
