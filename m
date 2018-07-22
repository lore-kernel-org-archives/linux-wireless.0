Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42646 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbeGVWos (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 18:44:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id f1-v6so13576250ljc.9
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2018 14:46:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Aditya Xavier <adityaxavier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: fix regression in parsing NVRAM for multiple devices
Date: Sun, 22 Jul 2018 23:46:25 +0200
Message-Id: <20180722214625.12101-1-zajec5@gmail.com> (sfid-20180722_234656_333545_51BA3B88)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

NVRAM is designed to work with Broadcom's SDK Linux kernel which fakes
PCI domain 0 for all internal MMIO devices. Since official Linux kernel
uses platform devices for that purpose there is a mismatch in numbering
PCI domains.

There used to be a fix for that problem but it was accidentally dropped
during the last firmware loading rework. That resulted in brcmfmac not
being able to extract device specific NVRAM content and all kind of
calibration problems.

Reported-by: Aditya Xavier <adityaxavier@gmail.com>
Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() function")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 45928b5b8d97..4fffa6988087 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1785,7 +1785,8 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus);
+	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
+	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
 	return fwreq;
-- 
2.13.7
