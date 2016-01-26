Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36146 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966826AbcAZQ5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:38 -0500
Received: by mail-lf0-f52.google.com with SMTP id h129so110092566lfh.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:37 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] brcmfmac: add support for 14e4:4365 PCI ID with BCM4366 chipset
Date: Tue, 26 Jan 2016 17:57:05 +0100
Message-Id: <1453827425-16455-6-git-send-email-zajec5@gmail.com> (sfid-20160126_175747_285261_B8F2FB81)
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Broadcom ARM routers BCM4366 cards are available with 14e4:4365 ID.
Unfortunately this ID was already used by Broadcom for cards with
BCM43142, a totally different chipset requiring SoftMAC driver. To avoid
a conflict between brcmfmac and bcma use more specific ID entry with
subvendor and subdevice specified.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 0480b70..d5f9ef4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1951,6 +1951,9 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm = {
 
 #define BRCMF_PCIE_DEVICE(dev_id)	{ BRCM_PCIE_VENDOR_ID_BROADCOM, dev_id,\
 	PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_NETWORK_OTHER << 8, 0xffff00, 0 }
+#define BRCMF_PCIE_DEVICE_SUB(dev_id, subvend, subdev)	{ \
+	BRCM_PCIE_VENDOR_ID_BROADCOM, dev_id,\
+	subvend, subdev, PCI_CLASS_NETWORK_OTHER << 8, 0xffff00, 0 }
 
 static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
@@ -1966,6 +1969,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_5G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE_SUB(0x4365, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4365),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID),
-- 
1.8.4.5

