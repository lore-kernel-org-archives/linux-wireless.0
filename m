Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35700 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdGQSQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 14:16:53 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        hante.meuleman@broadcom.com, franky.lin@broadcom.com,
        wright.feng@cypress.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 11/11] net: brcmfmac: constify pci_device_id.
Date: Mon, 17 Jul 2017 23:46:42 +0530
Message-Id: <1500315402-3439-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170717_201711_111979_A6027D23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f878706..e6e9b00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1951,7 +1951,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm = {
 	BRCM_PCIE_VENDOR_ID_BROADCOM, dev_id,\
 	subvend, subdev, PCI_CLASS_NETWORK_OTHER << 8, 0xffff00, 0 }
 
-static struct pci_device_id brcmf_pcie_devid_table[] = {
+static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
-- 
2.7.4
